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

class Synchroniser : public QObject
{
    Q_OBJECT
public:
    explicit Synchroniser(QObject *parent = nullptr);

    void getContacts(const bool &cached = false);
    FMH::MODEL_LIST getAccounts(const bool &cached = false);

    QVariantMap getContact(const QString &id);
    bool insertContact(const FMH::MODEL &contact, const FMH::MODEL &account = {{}});
    bool updateContact(const FMH::MODEL &contact);
    bool removeContact(const FMH::MODEL &contact);


//    FMH::MODEL_LIST getAccounts() const;

private:
#ifdef Q_OS_ANDROID
    AndroidIntents *android;
#endif


signals:
    void contactsReady(FMH::MODEL_LIST contacts);
    void callLogsReady();

public slots:
};

#endif // SYNCHRONISER_H
