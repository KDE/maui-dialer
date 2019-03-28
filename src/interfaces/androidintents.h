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

    void call(const QString &tel);
    void init();

    void addContact(const FMH::MODEL &contact, const FMH::MODEL &account);
    FMH::MODEL_LIST getAccounts() const;
    FMH::MODEL_LIST getContacts() const;


private:
    explicit AndroidIntents(QObject *parent = nullptr);
    static AndroidIntents *instance;
    MAUIAndroid *mauia;
    FMH::MODEL_LIST m_accounts;
    FMH::MODEL_LIST m_contacts;


    FMH::MODEL_LIST accounts();
    FMH::MODEL_LIST contacts();

signals:
    void contactsReady();

public slots:
};

#endif // ANDROIDINTENTS_H
