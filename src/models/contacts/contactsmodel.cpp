#include "contactsmodel.h"
#include "abstractinterface.h"

#ifdef Q_OS_ANDROID
#include "androidinterface.h"
#else
#include "linuxinterface.h"
#endif

#ifdef STATIC_MAUIKIT
#include "fm.h"
#else
#include <MauiKit/fm.h>
#endif

#ifdef Q_OS_ANDROID
ContactsModel::ContactsModel(QObject *parent) : MauiList(parent), syncer(AndroidInterface::getInstance())
#else
ContactsModel::ContactsModel(QObject *parent) : MauiList(parent), syncer(new LinuxInterface(this))
#endif
{
    connect(syncer, &AbstractInterface::contactsReady, [this](FMH::MODEL_LIST contacts)
    {
        qDebug() << "CONATCTS READY AT MODEL 1" << contacts;
        emit this->preListChanged();
        this->list = contacts;
        this->listbk = this->list;
        qDebug() << "CONATCTS READY AT MODEL" << this->list;

        this->filter();
        this->sortList();
        emit this->postListChanged();
    });

    this->getList(true);
}

FMH::MODEL_LIST ContactsModel::items() const
{
    return this->list;
}

void ContactsModel::setQuery(const QString &query)
{
    if(this->query == query)
        return;

    this->query = query;
    this->filter();

    emit this->queryChanged();
}

QString ContactsModel::getQuery() const
{
    return this->query;
}

void ContactsModel::setSortBy(const SORTBY &sort)
{
    if(this->sort == sort)
        return;

    this->sort = sort;

    this->preListChanged();
    this->sortList();
    this->postListChanged();
    emit this->sortByChanged();
}

ContactsModel::SORTBY ContactsModel::getSortBy() const
{
    return this->sort;
}

void ContactsModel::sortList()
{
    if(this->sort == ContactsModel::SORTBY::NONE)
        return;

    const auto key = static_cast<FMH::MODEL_KEY>(this->sort);
    std::sort(this->list.begin(), this->list.end(), [&key](const FMH::MODEL &e1, const FMH::MODEL &e2) -> bool
    {

        switch(key)
        {
            case FMH::MODEL_KEY::FAV:
            {
                if(e1[key].toInt() > e2[key].toInt())
                    return true;
                break;
            }

            case FMH::MODEL_KEY::ADDDATE:
            case FMH::MODEL_KEY::MODIFIED:
            {
                auto currentTime = QDateTime::currentDateTime();

                auto date1 = QDateTime::fromString(e1[key], Qt::TextDate);
                auto date2 = QDateTime::fromString(e2[key], Qt::TextDate);

                if(date1.secsTo(currentTime) <  date2.secsTo(currentTime))
                    return true;

                break;
            }

            case FMH::MODEL_KEY::TITLE:
            case FMH::MODEL_KEY::N:
            case FMH::MODEL_KEY::TEL:
            case FMH::MODEL_KEY::ORG:
            case FMH::MODEL_KEY::EMAIL:
            case FMH::MODEL_KEY::GENDER:
            case FMH::MODEL_KEY::ADR:
            {
                const auto str1 = QString(e1[key]).toLower();
                const auto str2 = QString(e2[key]).toLower();

                if(str1 < str2)
                    return true;
                break;
            }

            default:
                if(e1[key] < e2[key])
                    return true;
        }

        return false;
    });
}

void ContactsModel::getList(const bool &cached)
{
    qDebug()<< "TRYING TO SET FULL LIST";
    this->syncer->getContacts();
}

QVariantMap ContactsModel::get(const int &index) const
{
    if(index >= this->list.size() || index < 0)
        return QVariantMap();
    QVariantMap res;

    const auto item = this->list.at(index);

    res = FM::toMap(item);

#ifdef Q_OS_ANDROID
    const auto id = this->list.at(index)[FMH::MODEL_KEY::ID];
    res.unite(FMH::toMap(this->syncer->getContact(id)));
#endif

    return res;
}

bool ContactsModel::insert(const QVariantMap &map)
{
    qDebug() << "INSERTING NEW CONTACT" << map;

    if(map.isEmpty())
        return false;

    const auto model = FM::toModel(map);
    if(!this->syncer->insertContact(model))
        return false;

    qDebug()<< "inserting new contact count" << this->list.count();
    emit this->preItemAppended();
    this->list << model;
    emit this->postItemAppended();
    this->sortList();

    qDebug()<< "inserting new contact count" << this->list.count();

    return true;
}

bool ContactsModel::update(const QVariantMap &map, const int &index)
{
    if(index >= this->list.size() || index < 0)
        return false;

    const auto newItem = FM::toModel(map);
    const auto oldItem = this->list[index];

    auto updatedItem = FMH::MODEL();
    updatedItem[FMH::MODEL_KEY::ID] = oldItem[FMH::MODEL_KEY::ID];

    QVector<int> roles;
    for(const auto &key : newItem.keys())
    {
        if(newItem[key] != oldItem[key])
        {
            updatedItem.insert(key, newItem[key]);
            roles << key;
        }
    }

    qDebug()<< "trying to update contact:" << oldItem << "\n\n" << newItem << "\n\n" << updatedItem;

    this->syncer->updateContact(oldItem[FMH::MODEL_KEY::ID], newItem);
    this->list[index] = newItem;
    emit this->updateModel(index, roles);

    return true;
}

bool ContactsModel::remove(const int &index)
{
    if(index >= this->list.size() || index < 0)
        return false;
    qDebug()<< "trying to remove :" << this->list[index][FMH::MODEL_KEY::ID];
    if(this->syncer->removeContact(this->list[index][FMH::MODEL_KEY::ID]))
    {
        emit this->preItemRemoved(index);
        this->list.removeAt(index);
        emit this->postItemRemoved();
        return true;
    }

    return false;
}

void ContactsModel::filter()
{
    if(this->listbk.isEmpty())
        return;

    FMH::MODEL_LIST res;
    if(this->query.isEmpty())
        res = this->listbk;
    else
    {
        if(this->query.contains("="))
        {
            auto q = this->query.split("=", QString::SkipEmptyParts);
            if(q.size() == 2)
            {
                for(auto item : this->listbk)
                {
                    if(item[FMH::MODEL_NAME_KEY[q.first().trimmed()]].replace(" ", "").contains(q.last().trimmed()))
                        res << item;
                }
            }
        }else
        {
            for(const auto &item : this->listbk)
            {
                for(auto data : item)
                {
                    if((data.replace(" ", "").contains(this->query, Qt::CaseInsensitive)) && !res.contains(item))
                        res << item;
                }
            }
        }
    }

    emit this->preListChanged();
    this->list = res;
    this->sortList();
    emit this->postListChanged();
}

void ContactsModel::append(const QVariantMap &item)
{
    if(item.isEmpty())
        return;

    emit this->preItemAppended();

    FMH::MODEL model;
    for(auto key : item.keys())
        model.insert(FMH::MODEL_NAME_KEY[key], item[key].toString());

    qDebug() << "Appending item to list" << item;
    this->list << model;

    qDebug()<< this->list;

    emit this->postItemAppended();
}

void ContactsModel::append(const QVariantMap &item, const int &at)
{
    if(item.isEmpty())
        return;

    if(at > this->list.size() || at < 0)
        return;

    qDebug()<< "trying to append at" << at << item["title"];

    emit this->preItemAppendedAt(at);

    FMH::MODEL model;
    for(auto key : item.keys())
        model.insert(FMH::MODEL_NAME_KEY[key], item[key].toString());

    this->list.insert(at, model);

    emit this->postItemAppended();
}

void ContactsModel::appendQuery(const QString &query)
{
    if(query.isEmpty() || query == this->query)
        return;

    this->query = query;

    emit this->preListChanged();
    emit this->postListChanged();
}


void ContactsModel::clear()
{
    emit this->preListChanged();
    this->list.clear();
    emit this->postListChanged();
}

void ContactsModel::reset()
{
    this->query.clear();
    this->getList(true);
}

void ContactsModel::refresh()
{
    this->getList(false);
}

QVariantList ContactsModel::getAccounts()
{
    QVariantList res;
    auto accounts= syncer->getAccounts();
//    for(const auto &account : syncer->getAccounts())
//        res << FM::toMap(account);

    std::transform(accounts.begin(), accounts.end(), res.begin(), FM::toMap);
    return res;
}
