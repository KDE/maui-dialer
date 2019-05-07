#include "androidintents.h"
#include "./mauikit/src/android/mauiandroid.h"
#include <QDomDocument>

#include <QtConcurrent>
#include <QtConcurrent/QtConcurrentRun>
#include <QFuture>
#include <QFutureWatcher>
#include "fm.h"

AndroidIntents::AndroidIntents(QObject *parent) : QObject(parent)
{

}

void AndroidIntents::init()
{
    this->mauia = new MAUIAndroid(this);
}

AndroidIntents *AndroidIntents::instance = nullptr;

AndroidIntents *AndroidIntents::getInstance()
{
    if(!instance)
    {
        instance = new AndroidIntents();
        qDebug() << "getInstance(): First AndroidIntents instance\n";
        instance->init();

        return instance;
    } else
    {
        qDebug()<< "getInstance(): previous AndroidIntents instance\n";
        return instance;
    }
}

void AndroidIntents::call(const QString &tel)
{
    this->mauia->call(tel);
}

void AndroidIntents::contacts()
{        
    QFutureWatcher<FMH::MODEL_LIST> *watcher = new QFutureWatcher<FMH::MODEL_LIST>;
    connect(watcher, &QFutureWatcher<FMH::MODEL_LIST>::finished, [this, watcher]()
    {
        auto contacts = watcher->future().result();
        this->m_contacts = contacts;
        emit this->contactsReady();
    });

    QFuture<FMH::MODEL_LIST> t1 = QtConcurrent::run(AndroidIntents::fetchContacts);
    watcher->setFuture(t1);
}


FMH::MODEL_LIST AndroidIntents::fetchContacts()
{
    FMH::MODEL_LIST data;

    auto list = MAUIAndroid::getContacts();

    for(auto item : list)
        data << FM::toModel(item.toMap());

    return data;
}

void AndroidIntents::addContact(const FMH::MODEL &contact, const FMH::MODEL &account)
{
    qDebug() << "ADDING CONTACT TO ACCOUNT" << contact << account;
    //    this->mauia->addContact(contact[FMH::MODEL_KEY::N],
    //            contact[FMH::MODEL_KEY::TEL],
    //            contact[FMH::MODEL_KEY::TEL_2],
    //            contact[FMH::MODEL_KEY::TEL_3],
    //            contact[FMH::MODEL_KEY::EMAIL],
    //            contact[FMH::MODEL_KEY::TITLE],
    //            contact[FMH::MODEL_KEY::ORG],
    //            contact[FMH::MODEL_KEY::PHOTO],
    //            account[FMH::MODEL_KEY::ACCOUNT],
    //            account[FMH::MODEL_KEY::TYPE]);
}

FMH::MODEL_LIST AndroidIntents::getAccounts() const
{
    return this->m_accounts;
}

FMH::MODEL_LIST AndroidIntents::getContacts() const
{
    return this->m_contacts;
}

void AndroidIntents::updateContact(const QString &id, const QString &field, const QString &value)
{
    //    this->mauia->updateContact(id, field, value);
}

void AndroidIntents::fetch()
{
    //    this->m_accounts = this->accounts();
    this->contacts();
}

FMH::MODEL_LIST AndroidIntents::accounts()
{
    FMH::MODEL_LIST data;

    //    const auto array = this->mauia->getAccounts();
    //    QString xmlData(array);
    //    QDomDocument doc;

    //    if (!doc.setContent(xmlData)) return data;

    //    const QDomNodeList nodeList = doc.documentElement().childNodes();

    //    for (int i = 0; i < nodeList.count(); i++)
    //    {
    //        QDomNode n = nodeList.item(i);

    //        if(n.nodeName() == "account")
    //        {
    //            FMH::MODEL model;
    //            auto contact = n.toElement().childNodes();

    //            for(int i=0; i < contact.count(); i++)
    //            {
    //                const QDomNode m = contact.item(i);

    //                if(m.nodeName() == "name")
    //                {
    //                    const auto account = m.toElement().text();
    //                    model.insert(FMH::MODEL_KEY::ACCOUNT, account);

    //                }else if(m.nodeName() == "type")
    //                {
    //                    const auto type = m.toElement().text();
    //                    model.insert(FMH::MODEL_KEY::TYPE, type);

    //                }
    //            }

    //            data << model;
    //        }
    //    }

    return data;
}
