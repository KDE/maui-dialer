#ifndef ANDROIDINTENTS_H
#define ANDROIDINTENTS_H

#include <QObject>
#include "fmh.h"

class MAUIAndroid;
class AndroidIntents : public QObject
{
    Q_OBJECT
public:
    static AndroidIntents *getInstance();
//    explicit AndroidIntents(QObject *parent = nullptr);

    /**
     * @brief call
     * @param tel
     */
    void call(const QString &tel);

    /*!
     * \brief init
     */
    void init();

    //!
    //! \brief addContact
    //! \param contact
    //! \param account
    //!
    void addContact(const FMH::MODEL &contact, const FMH::MODEL &account);
    FMH::MODEL_LIST getAccounts() const;
    FMH::MODEL_LIST getContacts() const;
    void updateContact(const QString &id, const QString &field, const QString &value);


private:
    explicit AndroidIntents(QObject *parent = nullptr);
    static AndroidIntents *instance;
    MAUIAndroid *mauia;
    FMH::MODEL_LIST m_accounts;
    FMH::MODEL_LIST m_contacts;

    ///
    /// \brief accounts
    /// \return
    ///
    FMH::MODEL_LIST accounts();
    void contacts();

    ///
    /// \brief fetchContacts
    /// \return
    ///
    static FMH::MODEL_LIST fetchContacts();

signals:
    void contactsReady();

public slots:
};

#endif // ANDROIDINTENTS_H
