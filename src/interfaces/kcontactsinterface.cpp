
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
#include "kcontactsinterface.h"

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

kcontactsinterface::kcontactsinterface(QObject *parent) : QObject(parent)
{
    //    this->addContact("Daniel", "3298373843");
}

FMH::MODEL_LIST kcontactsinterface::getContacts(const QString &query)
{
    FMH::MODEL_LIST res;


//    VCardConverter converter;

//    QDirIterator it(this->path, {"*.vcf"}, QDir::Files, QDirIterator::Subdirectories);

//    while (it.hasNext())
//    {
//        const auto file = it.next();
//        QFile card(file);
//        qDebug()<< "Reading card << " << file;

//        if(card.open(QIODevice::ReadOnly | QIODevice::Text))
//        {
//            auto contact = converter.parseVCard(card.readAll());

//            res << FMH::MODEL  {
//            {FMH::MODEL_KEY::N, contact.name()},
//            {FMH::MODEL_KEY::EMAIL, contact.emails().join(",")},
//            {FMH::MODEL_KEY::TEL, contact.phoneNumber(PhoneNumber::Cell  | PhoneNumber::Home).toString()}
//        };
//        }
//    }



        KPeople::PersonsModel model;
        qDebug()<< "KPEOPLE CONTACTS" << model.rowCount();

        for(auto i = 0 ; i< model.rowCount(); i++)
        {

            auto uri = model.get(i, KPeople::PersonsModel::PersonUriRole).toString();

            KPeople::PersonData person(uri);

            res << FMH::MODEL  {
            {FMH::MODEL_KEY::N, person.name()},
            {FMH::MODEL_KEY::EMAIL, person.email()},
            {FMH::MODEL_KEY::TEL, person.contactCustomProperty("phoneNumber").toString()},
            {FMH::MODEL_KEY::PHOTO, person.pictureUrl().toString()}};

            qDebug()<< "KPEOPLE CONTACTS" << res;

        }

    return res;
}

void kcontactsinterface::addContact(const FMH::MODEL &contact)
{
    qDebug()<< "TRYIN TO INSERT VACRD CONTACT"<< contact;
    // addresses
    Addressee adr;
    adr.setName(contact[FMH::MODEL_KEY::N]);
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
        return;
    }
    file.write(vcard.data(), vcard.length());
    file.close();
}
