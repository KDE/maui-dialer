#include "synchroniser.h"
#include <QtConcurrent>
#include <QtConcurrent/QtConcurrentRun>
#include <QFuture>
#include <QThread>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include "./src/interfaces/androidintents.h"
#else
#include "./src/interfaces/kcontactsinterface.h"
#endif

extern void test()
{
    qDebug()<< "from anotehr thread";
}

Synchroniser::Synchroniser(QObject *parent) : QObject (parent)
{
#ifdef Q_OS_ANDROID
    qDebug()<< "trying to insert contact to android api";
    this->android = AndroidIntents::getInstance();
    connect(android, &AndroidIntents::contactsReady, [this](FMH::MODEL_LIST contacts)
    {
        emit this->contactsReady(contacts);
    });

#endif
}

void Synchroniser::getContacts(const bool &cached)
{
#ifdef Q_OS_ANDROID
    this->android->getContacts(cached ? AndroidIntents::GET_TYPE::CACHED : AndroidIntents::GET_TYPE::FETCH);
#else
    kcontactsinterface kcontacts;
    emit this->contactsReady(kcontacts.getContacts());
#endif
}

FMH::MODEL_LIST Synchroniser::getAccounts(const bool &cached)
{
    FMH::MODEL_LIST res;
#ifdef Q_OS_ANDROID
    res = this->android->getAccounts(cached ? AndroidIntents::GET_TYPE::CACHED : AndroidIntents::GET_TYPE::FETCH);
    return res;
#endif

    return res;
}

QVariantMap Synchroniser::getContact(const QString &id)
{
    QVariantMap res;
#ifdef Q_OS_ANDROID
    res = this->android->getContact(id);
    return res;
#endif

    return res;
}

bool Synchroniser::insertContact(const FMH::MODEL &contact, const FMH::MODEL &account)
{
    //    return this->dba->insertContact(contact);
#ifdef Q_OS_ANDROID
    android->addContact(contact, account);
#else
    Q_UNUSED(account)
    kcontactsinterface kcontacts;
    kcontacts.addContact(contact);
#endif

    return true;
}

bool Synchroniser::updateContact(const FMH::MODEL &contact)
{
#ifdef Q_OS_ANDROID
    for(auto key : contact.keys())
        android->updateContact(contact[FMH::MODEL_KEY::ID], FMH::MODEL_NAME[key], contact[key]);
#else
    kcontactsinterface kcontacts;
    kcontacts.addContact(contact);
#endif

    return true;
}

bool Synchroniser::removeContact(const FMH::MODEL &contact)
{
//    return this->dba->removeContact(contact[FMH::MODEL_KEY::ID]);
    return true;
}

