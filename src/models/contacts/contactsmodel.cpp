#include "contactsmodel.h"
#include "./src/interfaces/synchroniser.h"

#ifdef Q_OS_ANDROID
#include "./src/interfaces/androidintents.h"
#endif

#ifdef STATIC_MAUIKIT
#include "fm.h"
#else
#include <MauiKit/fm.h>
#endif

ContactsModel::ContactsModel(QObject *parent) : BaseList(parent)
{
    this->syncer = new Synchroniser(this);
    connect(syncer, &Synchroniser::contactsReady, [this]()
    {
        this->setList();

    });
    //    connect(this, &ContactsModel::queryChanged, this, &ContactsModel::setList);
    //    this->getList();
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
    qDebug()<< "setting query"<< this->query;

    if(list.isEmpty())
        this->setList();

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
    qSort(this->list.begin(), this->list.end(), [key](const FMH::MODEL &e1, const FMH::MODEL &e2) -> bool
    {
        auto role = key;

        switch(role)
        {
        case FMH::MODEL_KEY::FAV:
        {
            if(e1[role].toInt() > e2[role].toInt())
                return true;
            break;
        }

        case FMH::MODEL_KEY::ADDDATE:
        case FMH::MODEL_KEY::MODIFIED:
        {
            auto currentTime = QDateTime::currentDateTime();

            auto date1 = QDateTime::fromString(e1[role], Qt::TextDate);
            auto date2 = QDateTime::fromString(e2[role], Qt::TextDate);

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
            const auto str1 = QString(e1[role]).toLower();
            const auto str2 = QString(e2[role]).toLower();

            if(str1 < str2)
                return true;
            break;
        }

        default:
            if(e1[role] < e2[role])
                return true;
        }

        return false;
    });
}

void ContactsModel::setList()
{
    emit this->preListChanged();
    this->getList();
    this->filter();
    this->sortList();
    emit this->postListChanged();
}

void ContactsModel::getList(const QString &query)
{
    qDebug()<< "TRYING TO SET FULL LIST";
    this->list = this->syncer->getContacts(query);
}

QVariantMap ContactsModel::get(const int &index) const
{
    if(index >= this->list.size() || index < 0)
        return QVariantMap();

    QVariantMap res;
    const auto item = this->list.at(index);

    for(auto key : item.keys())
        res.insert(FMH::MODEL_NAME[key], item[key]);

    return res;
}

bool ContactsModel::insert(const QVariantMap &map)
{
    if(map.isEmpty())
        return false;

    auto model = FM::toModel(map);
    if(!this->syncer->insertContact(model))
        return false;

    emit this->preListChanged();
    this->setList();
    emit this->postListChanged();

    return true;
}

bool ContactsModel::insert(const QVariantMap &map, const QVariantMap &account)
{
    if(map.isEmpty() || account.isEmpty())
        return false;

    auto model = FM::toModel(map);
    model[FMH::MODEL_KEY::ACCOUNT] = account[FMH::MODEL_NAME[FMH::MODEL_KEY::ACCOUNT]].toString();
    if(!this->syncer->insertContact(model,  FM::toModel(account)))
        return false;

    qDebug()<< "inserting new contact count" << this->list.count();
    emit this->preItemAppended();
    this->list.append(model);
    this->sortList();

    emit this->postItemAppended();
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

        for(auto key : newItem.keys())
        {
            if(newItem[key] != oldItem[key])
            {
                updatedItem.insert(key, newItem[key]);
                roles << key;
            }
        }

        this->syncer->updateContact(updatedItem);
        this->list[index] = newItem;
        emit this->updateModel(index, roles);


    return false;
}

bool ContactsModel::remove(const int &index)
{
    if(index >= this->list.size() || index < 0)
        return false;

    if(this->syncer->removeContact(this->list[index]))
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
    if(list.isEmpty())
        return;

    if(this->query.isEmpty())    
        return;

    FMH::MODEL_LIST res;

    if(this->query.contains("="))
    {
        auto q = this->query.split("=", QString::SkipEmptyParts);
        if(q.size() == 2)
        {
            for(const auto item : this->list)
            {
                if(item[FMH::MODEL_NAME_KEY[q.first().trimmed()]] == q.last().trimmed())
                    res << item;
            }
        }
    }else
    {
        for(const auto item : this->list)
        {
            for(const auto data : item)
            {
                if(data.contains(this->query, Qt::CaseInsensitive) && !res.contains(item))
                    res << item;
            }
        }
    }

    emit this->preListChanged();
    this->list = res;
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
    this->setList();
}

QVariantList ContactsModel::getAccounts()
{
    QVariantList res;
    for(auto account : syncer->getAccounts())
        res << FM::toMap(account);
    return res;
}
