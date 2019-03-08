#include "synchroniser.h"
#include "./../db/dbactions.h"
#include "vcardproperty.h"

Synchroniser::Synchroniser(QObject *parent) : QObject (parent)
{
    this->dba = DBActions::getInstance();
}


FMH::MODEL_LIST Synchroniser::getContacts(const QString &query)
{
    return this->dba->getDBData(query);
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
