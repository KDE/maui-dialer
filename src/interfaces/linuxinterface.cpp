
/*
 * Copyright 2019  Linus Jahn <lnj@kaidan.im>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "linuxinterface.h"

#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QCryptographicHash>
#include <KContacts/Addressee>
#include <KContacts/VCardConverter>
#include <KPeople/KPeople/PersonsModel>
#include <KPeople/PersonData>
#include <KPeople/KPeopleBackend/AbstractContact>
#include <QDirIterator>

using namespace KContacts;
LinuxInterface::LinuxInterface(QObject *parent) : AbstractInterface(parent) {}

void LinuxInterface::getContacts()
{
    KPeople::PersonsModel model;
    qDebug()<< "KPEOPLE CONTACTS" << model.rowCount();

    for(auto i = 0 ; i< model.rowCount(); i++)
    {
        const auto uri = model.get(i, KPeople::PersonsModel::PersonUriRole).toString();

        KPeople::PersonData person(uri);
        this->m_contacts << FMH::MODEL  {
        {FMH::MODEL_KEY::ID, person.personUri()},
        {FMH::MODEL_KEY::N, person.name()},
        {FMH::MODEL_KEY::FAV, person.contactCustomProperty(FMH::MODEL_NAME[FMH::MODEL_KEY::FAV]).toString()},
    {FMH::MODEL_KEY::EMAIL, person.email()},
    {FMH::MODEL_KEY::TEL, person.contactCustomProperty("phoneNumber").toString()},
    {FMH::MODEL_KEY::PHOTO, person.pictureUrl().toString()}};
}

emit this->contactsReady(this->m_contacts);
}

FMH::MODEL LinuxInterface::getContact(const QString &id)
{
    FMH::MODEL res;
    auto personUri = id;

    if (!(QUrl(personUri).scheme() == "vcard")) {
        qWarning() << "uri of contact to update is not a vcard, cannot update.";
        return res;
    }

    QFile file(personUri.remove("vcard:/"));
    if (!(file.exists())) {
        qWarning() << "Can't read vcard, file doesn't exist";
        return res;
    }
    if (!file.open(QIODevice::ReadWrite | QIODevice::Truncate)) {
        qWarning() << "Couldn't update vCard: Couldn't open file for reading / writing.";
        return res;
    }

    VCardConverter converter;
    Addressee adr = converter.parseVCard(file.readAll());

   res =  {
            {FMH::MODEL_KEY::ID, id},
            {FMH::MODEL_KEY::N, adr.name()},
//            {FMH::MODEL_KEY::FAV, adr.customs()},
        {FMH::MODEL_KEY::EMAIL, adr.emails().join(",")},
        {FMH::MODEL_KEY::TEL, adr.phoneNumber(PhoneNumber::Cell).toString()},
        {FMH::MODEL_KEY::PHOTO, adr.photo().url()}};

    return res;
}

bool LinuxInterface::insertContact(const FMH::MODEL &contact)
{
    qDebug()<< "TRYIN TO INSERT VACRD CONTACT"<< contact;
    // addresses
    Addressee adr;
    adr.setName(contact[FMH::MODEL_KEY::N]);
    adr.setUid(contact[FMH::MODEL_KEY::ID]);
    adr.setUrl(contact[FMH::MODEL_KEY::URL]);
    adr.setNote(contact[FMH::MODEL_KEY::NOTE]);
    adr.setTitle(contact[FMH::MODEL_KEY::TITLE]);
    adr.setOrganization(contact[FMH::MODEL_KEY::ORG]);
    adr.setGender(contact[FMH::MODEL_KEY::GENDER]);

    adr.setCustoms({QString("%1:%2").arg(FMH::MODEL_NAME[FMH::MODEL_KEY::FAV], contact[FMH::MODEL_KEY::FAV])});

    Email email;
    email.setEmail(contact[FMH::MODEL_KEY::EMAIL]);
    adr.setEmailList({email});

    Picture photo;
    photo.setUrl(contact[FMH::MODEL_KEY::PHOTO]);
    adr.setPhoto(photo);

    PhoneNumber phoneNum;
    phoneNum.setNumber(contact[FMH::MODEL_KEY::TEL]);
    phoneNum.setType(PhoneNumber::Cell);
    adr.setPhoneNumbers({phoneNum});

    // create vcard
    VCardConverter converter;
    QByteArray vcard = converter.createVCard(adr);
    qDebug() << vcard;

    // save vcard
    QCryptographicHash hash(QCryptographicHash::Sha1);
    hash.addData(adr.name().toUtf8());
    QFile file(this->path + "/" + hash.result().toHex() + ".vcf");
    if (!file.open(QFile::WriteOnly)) {
        qWarning() << "Couldn't save vCard: Couldn't open file for writing.";
        return false;
    }

    file.write(vcard.data(), vcard.length());
    file.close();

    return true;
}

bool LinuxInterface::updateContact(const QString &id, const FMH::MODEL &contact)
{
    auto personUri = id;

    if (!(QUrl(personUri).scheme() == "vcard")) {
        qWarning() << "uri of contact to update is not a vcard, cannot update.";
        return false;
    }

    QFile file(personUri.remove("vcard:/"));
    if (!(file.exists())) {
        qWarning() << "Can't read vcard, file doesn't exist";
        return false;
    }
    if (!file.open(QIODevice::ReadWrite | QIODevice::Truncate)) {
        qWarning() << "Couldn't update vCard: Couldn't open file for reading / writing.";
        return false;
    }

    VCardConverter converter;
    Addressee adr = converter.parseVCard(file.readAll());

    for(const auto &key : contact.keys())
    {
        const auto data = contact[key];
        qDebug()<< "updating filed:" << key << data;
        switch(key)
        {
            case FMH::MODEL_KEY::N:
            {
                if (!data.isEmpty())
                    adr.setName(data);
                break;
            }

            case FMH::MODEL_KEY::TEL:
            {
                PhoneNumber::List phoneNums;
                PhoneNumber phoneNum;
                phoneNum.setNumber(data);
                phoneNum.setType(PhoneNumber::Cell);
                phoneNums.append(phoneNum);
                adr.setPhoneNumbers(phoneNums);
                break;
            }

            case FMH::MODEL_KEY::ORG:
            {
                adr.setOrganization(data);
                break;
            }

            case FMH::MODEL_KEY::TITLE:
            {
                adr.setTitle(data);
                break;
            }

            case FMH::MODEL_KEY::FAV:
            {
                adr.setCustoms({QString("%1:%2").arg(FMH::MODEL_NAME[FMH::MODEL_KEY::FAV],data)});
                break;
            }

            case FMH::MODEL_KEY::EMAIL:
            {
                Email email;
                email.setEmail(data);
                adr.setEmailList({email});
                break;
            }

            case FMH::MODEL_KEY::NOTE:
            {
                adr.setNote(data);
                break;
            }

            case FMH::MODEL_KEY::GENDER:
            {
                adr.setGender(data);
                break;
            }

            case FMH::MODEL_KEY::PHOTO:
            {
                Picture photo;
                photo.setUrl(data);
                adr.setPhoto(photo);
                break;
            }

            case FMH::MODEL_KEY::URL:
            {
                adr.setUrl(data);
                break;
            }

            default: break;
        }
    }

    QByteArray vcard = converter.createVCard(adr);
    qDebug() << vcard;

    file.write(vcard);
    file.close();
    return true;
}

bool LinuxInterface::removeContact(const QString &id)
{
    if (!(QUrl(id).scheme() == "vcard")) {
        qWarning() << "uri of contact to remove is not a vcard, cannot remove.";
        return false;
    }

    return QFile::remove(QString(id).remove("vcard:/"));
}
