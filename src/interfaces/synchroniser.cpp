#include "synchroniser.h"
#include "./../db/dbactions.h"
#include "vcardproperty.h"

#ifdef Q_OS_ANDROID
#include "./src/interfaces/androidintents.h"
#else
#include "./src/interfaces/kcontactsinterface.h"
#endif

Synchroniser::Synchroniser(QObject *parent) : QObject (parent)
{
    this->dba = DBActions::getInstance();
}


FMH::MODEL_LIST Synchroniser::getContacts(const QString &query)
{
    FMH::MODEL_LIST data/* =this->dba->getDBData(query)*/;

#ifdef Q_OS_ANDROID
    AndroidIntents android;
    data << android.getContacts();
#else
    kcontactsinterface kcontacts;
    data << kcontacts.getContacts("");
#endif

    return data;
}

bool Synchroniser::insertContact(const FMH::MODEL &contact)
{   
    return this->dba->insertContact(contact);
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
