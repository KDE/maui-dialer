#ifndef SYNCHRONISER_H
#define SYNCHRONISER_H

#include <QObject>
#ifdef STATIC_MAUIKIT
#include "fmh.h"
#else
#include <MauiKit/fmh.h>
#endif

#ifdef Q_OS_ANDROID
class AndroidIntents;
#endif

class DBActions;
class Synchroniser : public QObject
{
    Q_OBJECT
public:
    explicit Synchroniser(QObject *parent = nullptr);

    FMH::MODEL_LIST getContacts(const QString &query);
    FMH::MODEL_LIST getAccounts();
    bool insertContact(const FMH::MODEL &contact);
    bool insertContact(const FMH::MODEL &contact, const FMH::MODEL &account);
    bool updateContact(const FMH::MODEL &contact);
    bool removeContact(const FMH::MODEL &contact);

//    FMH::MODEL_LIST getAccounts() const;

private:
    DBActions *dba;

#ifdef Q_OS_ANDROID
    AndroidIntents *android;
#endif


signals:
    void contactsReady();

public slots:
};

#endif // SYNCHRONISER_H
