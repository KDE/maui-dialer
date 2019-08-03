
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
        {FMH::MODEL_KEY::EMAIL, person.email()},
        {FMH::MODEL_KEY::TEL, person.contactCustomProperty("phoneNumber").toString()},
        {FMH::MODEL_KEY::PHOTO, person.pictureUrl().toString()}};
        qDebug() << person.pictureUrl();

    }


    emit this->contactsReady(this->m_contacts);
}

FMH::MODEL LinuxInterface::getContact(const QString &id)
{
    return FMH::MODEL();
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

    adr.setCustoms({QString("fav:%1").arg(contact[FMH::MODEL_KEY::FAV])});

    Email::List emailList;
    Email email;
    email.setEmail(contact[FMH::MODEL_KEY::EMAIL]);
    emailList << email;
    adr.setEmailList(emailList);

    Picture photo;
    photo.setUrl(contact[FMH::MODEL_KEY::PHOTO]);
    adr.setPhoto(photo);

    adr.setTitle(contact[FMH::MODEL_KEY::TITLE]);
    adr.setOrganization(contact[FMH::MODEL_KEY::ORG]);
    adr.setGender(contact[FMH::MODEL_KEY::GENDER]);

    PhoneNumber::List phoneNums;
    PhoneNumber phoneNum;
    phoneNum.setNumber(contact[FMH::MODEL_KEY::TEL]);
    phoneNum.setType(PhoneNumber::Cell);
    phoneNums.append(phoneNum);
    adr.setPhoneNumbers(phoneNums);

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
    return false;
}

bool LinuxInterface::removeContact(const QString &id)
{
    if (!(QUrl(id).scheme() == "vcard")) {
          qWarning() << "uri of contact to remove is not a vcard, cannot remove.";
          return false;
      }

      return QFile::remove(QString(id).remove("vcard:/"));
}
