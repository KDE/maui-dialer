#ifndef CONTACTSMODEL_H
#define CONTACTSMODEL_H

#include <QObject>
#include "../baselist.h"

class Synchroniser;

class ContactsModel : public BaseList
{
    Q_OBJECT
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged())
    Q_PROPERTY(ContactsModel::SORTBY sortBy READ getSortBy WRITE setSortBy NOTIFY sortByChanged)

public:

    enum SORTBY : uint_fast8_t
    {
        ADDDATE = FMH::MODEL_KEY::ADDDATE, //when the contact was added
        MODIFIED = FMH::MODEL_KEY::MODIFIED, // last modifed
        N = FMH::MODEL_KEY::N, //contact name
        TEL = FMH::MODEL_KEY::TEL, //contact phone
        ORG = FMH::MODEL_KEY::ORG, //contact organization
        EMAIl = FMH::MODEL_KEY::EMAIL, //contact email address
        GENDER = FMH::MODEL_KEY::GENDER, //contact gender
        ADR = FMH::MODEL_KEY::ADR, //contact phisical address
        TITLE = FMH::MODEL_KEY::TITLE, //contact title
        FAV = FMH::MODEL_KEY::FAV, //if contact if marked as fav
        COUNT = FMH::MODEL_KEY::COUNT, //how many times contacts has been messaged or called
        PHOTO = FMH::MODEL_KEY::PHOTO, //contact photo
        NONE

    }; Q_ENUM(SORTBY)

    explicit ContactsModel(QObject *parent = nullptr);

    FMH::MODEL_LIST items() const override;

    void setQuery(const QString &query);
    QString getQuery() const;

    void setSortBy(const ContactsModel::SORTBY &sort);
    ContactsModel::SORTBY getSortBy() const;

private:
    Synchroniser *syncer;
    FMH::MODEL_LIST list;
    void sortList();
    void setList();

    QString query;
    ContactsModel::SORTBY sort = ContactsModel::SORTBY::N;

signals:
    void queryChanged();
    void sortByChanged();

public slots:
    QVariantMap get(const int &index) const override;
    bool insert(const QVariantMap &map) override;
    void append(const QVariantMap &item, const int &at);
    void append(const QVariantMap &item);
    void appendQuery(const QString &query);
    void clear();

};

#endif // CONTACTSMODEL_H
