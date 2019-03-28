#include "synchroniser.h"
#include "./../db/dbactions.h"
#include "vcardproperty.h"
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
    this->dba = DBActions::getInstance();

#ifdef Q_OS_ANDROID
    qDebug()<< "trying to insert contact to android api";
    this->android = AndroidIntents::getInstance();
    connect(android, &AndroidIntents::contactsReady, [this]()
    {
        emit this->contactsReady();
    });

#endif


}


FMH::MODEL_LIST Synchroniser::getContacts(const QString &query)
{
    FMH::MODEL_LIST data /*=this->dba->getDBData(query)*/;

#ifdef Q_OS_ANDROID
    data << android->getContacts();
#else
    kcontactsinterface kcontacts;
    data << kcontacts.getContacts("");
#endif

    return data;
}

FMH::MODEL_LIST Synchroniser::getAccounts()
{
   FMH::MODEL_LIST res;
#ifdef Q_OS_ANDROID
    res = this->android->getAccounts();
    return res;
#endif

    return res;
}

bool Synchroniser::insertContact(const FMH::MODEL &contact)
{   
    //    return this->dba->insertContact(contact);
#ifdef Q_OS_ANDROID    
    android->addContact(contact, FMH::MODEL());
#else
    kcontactsinterface kcontacts;
    kcontacts.addContact(contact);
#endif

    return true;
}

bool Synchroniser::insertContact(const FMH::MODEL &contact, const FMH::MODEL &account)
{
    //    return this->dba->insertContact(contact);
#ifdef Q_OS_ANDROID
    android->addContact(contact, account);
#else
    kcontactsinterface kcontacts;
    kcontacts.addContact(contact);
#endif

    return true;
}

bool Synchroniser::updateContact(const FMH::MODEL &contact)
{
    return this->dba->updateContact(contact);
}

bool Synchroniser::removeContact(const FMH::MODEL &contact)
{
    return this->dba->removeContact(contact[FMH::MODEL_KEY::ID]);
}



vCard Synchroniser::tovCard(const FMH::MODEL &contact)
{
    Q_UNUSED(contact);
    vCard vcard;
    vCardProperty name_prop = vCardProperty::createName("Emanuele", "Bertoldi");
    vcard.addProperty(name_prop);
    return vcard;
}
