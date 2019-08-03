#ifndef CONTACTSMODEL_H
#define CONTACTSMODEL_H

#include <QObject>

#ifdef STATIC_MAUIKIT
#include "mauilist.h"
#else
#include <MauiKit/mauilist.h>
#endif

class AbstractInterface;
class ContactsModel : public MauiList
{
    Q_OBJECT
    Q_PROPERTY(QString query READ getQuery WRITE setQuery NOTIFY queryChanged)
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

    FMH::MODEL_LIST items() const override final;

    QString getQuery() const;
    void setQuery(const QString &query);

    void setSortBy(const ContactsModel::SORTBY &sort);
    ContactsModel::SORTBY getSortBy() const;

private:
    /*
     * *syncer (abstract interface) shouyld work with whatever interface derived from
     * AbstractInterface, for now we have Android and Linux interfaces
     */

    AbstractInterface *syncer;

    /**
     * There is the list that holds the conatcts data,
     * and the list-bk which holds a cached version of the list,
     * this helps to not have to fecth contents all over again
     * when filtering the list
     */
    FMH::MODEL_LIST list;
    FMH::MODEL_LIST listbk;


    void sortList();
    void getList(const bool &cached = false);
    void filter();

    /**
     * query is a property to start filtering the list, the filtering is
     * done over the list-bk cached list instead of the main list
     */
    QString query = "undefined";
    ContactsModel::SORTBY sort = ContactsModel::SORTBY::N;

signals:
    void queryChanged();
    void sortByChanged();

public slots:
    QVariantMap get(const int &index) const;
    bool insert(const QVariantMap &map);
    bool update(const QVariantMap &map, const int &index);
    bool remove(const int &index);

    void append(const QVariantMap &item, const int &at);
    void append(const QVariantMap &item);

    void appendQuery(const QString &query);
    void clear();
    void reset();
    void refresh();
    QVariantList getAccounts();
};

#endif // CONTACTSMODEL_H
