#include "synchroniser.h"
#include "./../db/dbactions.h"
#include "vcardproperty.h"
#include "vcard.h"

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
    vCard vcard;
    vCardProperty name_prop = vCardProperty::createName("Emanuele", "Bertoldi");

    vcard.addProperty(name_prop);
    return this->dba->insertContact(contact);
}
