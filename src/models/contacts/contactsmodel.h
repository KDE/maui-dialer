#ifndef CONTACTSMODEL_H
#define CONTACTSMODEL_H

#include <QObject>
#include "../baselist.h"

class ContactsModel : public BaseList
{
    Q_OBJECT
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged())
    Q_PROPERTY(ContactsModel::SORTBY sortBy READ getSortBy WRITE setSortBy NOTIFY sortByChanged)

public:

    enum SORTBY : uint_fast8_t
    {
        ADDDATE = FMH::MODEL_KEY::ADDDATE,
        RELEASEDATE = FMH::MODEL_KEY::RELEASEDATE,
        FORMAT = FMH::MODEL_KEY::FORMAT,
        ARTIST = FMH::MODEL_KEY::ARTIST,
        TITLE = FMH::MODEL_KEY::TITLE,
        ALBUM = FMH::MODEL_KEY::ALBUM,
        RATE = FMH::MODEL_KEY::RATE,
        FAV = FMH::MODEL_KEY::FAV,
        TRACK = FMH::MODEL_KEY::TRACK,
        COUNT = FMH::MODEL_KEY::COUNT,
        NONE

    }; Q_ENUM(SORTBY)

    explicit ContactsModel(QObject *parent = nullptr);

    FMH::MODEL_LIST items() const override;

    void setQuery(const QString &query);
    QString getQuery() const;

    void setSortBy(const ContactsModel::SORTBY &sort);
    ContactsModel::SORTBY getSortBy() const;

private:
    FMH::MODEL_LIST list;
    void sortList();
    void setList();

    QString query;
    ContactsModel::SORTBY sort = ContactsModel::SORTBY::ADDDATE;

signals:
    void queryChanged();
    void sortByChanged();

public slots:
    QVariantMap get(const int &index) const override;
    void append(const QVariantMap &item);
    void append(const QVariantMap &item, const int &at);
    void appendQuery(const QString &query);
    void clear();

};

#endif // CONTACTSMODEL_H
