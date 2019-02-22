#include "contactsmodel.h"

ContactsModel::ContactsModel(QObject *parent) : BaseList(parent)
{
    connect(this, &ContactsModel::queryChanged, this, &ContactsModel::setList);
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
    qDebug()<< "SORTING LIST BY"<< this->sort;
    qSort(this->list.begin(), this->list.end(), [key](const FMH::MODEL &e1, const FMH::MODEL &e2) -> bool
    {
        auto role = key;

        switch(role)
        {
        case FMH::MODEL_KEY::RELEASEDATE:
        case FMH::MODEL_KEY::RATE:
        case FMH::MODEL_KEY::FAV:
        case FMH::MODEL_KEY::COUNT:
        {
            if(e1[role].toInt() > e2[role].toInt())
                return true;
            break;
        }

        case FMH::MODEL_KEY::TRACK:
        {
            if(e1[role].toInt() < e2[role].toInt())
                return true;
            break;
        }

        case FMH::MODEL_KEY::ADDDATE:
        {
            auto currentTime = QDateTime::currentDateTime();

            auto date1 = QDateTime::fromString(e1[role], Qt::TextDate);
            auto date2 = QDateTime::fromString(e2[role], Qt::TextDate);

            if(date1.secsTo(currentTime) <  date2.secsTo(currentTime))
                return true;

            break;
        }

        case FMH::MODEL_KEY::TITLE:
        case FMH::MODEL_KEY::ARTIST:
        case FMH::MODEL_KEY::ALBUM:
        case FMH::MODEL_KEY::FORMAT:
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

    qDebug()<< "my LIST" ;
    this->sortList();
    emit this->postListChanged();
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
