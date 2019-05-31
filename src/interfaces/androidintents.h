#ifndef ANDROIDINTENTS_H
#define ANDROIDINTENTS_H

#include <QObject>
#include "fmh.h"

class AndroidIntents : public QObject
{
    Q_OBJECT
public:
    enum GET_TYPE : uint_fast8_t
    {
        CACHED,
        FETCH
    };

    static AndroidIntents *getInstance();
    void call(const QString &tel) const;

    void addContact(const FMH::MODEL &contact, const FMH::MODEL &account) const;

    FMH::MODEL_LIST getAccounts(const GET_TYPE &type = GET_TYPE::CACHED);
    void getContacts(const GET_TYPE &type = GET_TYPE::CACHED);
    void getCallLogs();

    QVariantMap getContact(const QString &id) const;

    void updateContact(const QString &id, const QString &field, const QString &value) const;

private:
    explicit AndroidIntents(QObject *parent = nullptr);

    static AndroidIntents *instance;
    FMH::MODEL_LIST m_contacts;
    FMH::MODEL_LIST m_accounts;

    void fetchContacts();
    FMH::MODEL_LIST fetchAccounts();

signals:
    void contactsReady(FMH::MODEL_LIST contacts) const;

public slots:
};

#endif // ANDROIDINTENTS_H
