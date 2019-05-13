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
        qDebug() << "getInstance(AndroidIntents): First AndroidIntents instance\n";
        instance->init();

        return instance;
    } else
    {
        qDebug()<< "getInstance(AndroidIntents): previous AndroidIntents instance\n";
        return instance;
    }
}

void AndroidIntents::call(const QString &tel) const
{
    this->mauia->call(tel);
}

void AndroidIntents::addContact(const FMH::MODEL &contact, const FMH::MODEL &account) const
{
    qDebug() << "ADDING CONTACT TO ACCOUNT" << contact << account;
    this->mauia->addContact(contact[FMH::MODEL_KEY::N],
            contact[FMH::MODEL_KEY::TEL],
            contact[FMH::MODEL_KEY::TEL_2],
            contact[FMH::MODEL_KEY::TEL_3],
            contact[FMH::MODEL_KEY::EMAIL],
            contact[FMH::MODEL_KEY::TITLE],
            contact[FMH::MODEL_KEY::ORG],
            contact[FMH::MODEL_KEY::PHOTO],
            account[FMH::MODEL_KEY::ACCOUNT],
            account[FMH::MODEL_KEY::TYPE]);
}

FMH::MODEL_LIST AndroidIntents::getAccounts(const GET_TYPE &type)
{    
    if(type == GET_TYPE::CACHED)
    {
        if(!m_accounts.isEmpty())
            return this->m_accounts;
        else
            this->fetchAccounts();

    }else if(type == GET_TYPE::FETCH)
        return this->fetchAccounts();
}

void AndroidIntents::getContacts(const GET_TYPE &type)
{
    if(type == GET_TYPE::CACHED)
    {
        if(!this->m_contacts.isEmpty())
            emit this->contactsReady(this->m_contacts);
        else
            this->fetchContacts();

    }else if(type == GET_TYPE::FETCH)
        this->fetchContacts();
}

QVariantMap AndroidIntents::getContact(const QString &id) const
{
    return this->mauia->getContact(id);
}

void AndroidIntents::updateContact(const QString &id, const QString &field, const QString &value) const
{
    this->mauia->updateContact(id, field, value);
}



void AndroidIntents::fetchContacts()
{
    QFutureWatcher<FMH::MODEL_LIST> *watcher = new QFutureWatcher<FMH::MODEL_LIST>;
    connect(watcher, &QFutureWatcher<FMH::MODEL_LIST>::finished, [=]()
    {
        this->m_contacts = watcher->future().result();
        emit this->contactsReady(this->m_contacts);

        watcher->deleteLater();
    });

    const auto func = []() -> FMH::MODEL_LIST
    {
            FMH::MODEL_LIST data;

            auto list = MAUIAndroid::getContacts();

            for(auto item : list)
            data << FM::toModel(item.toMap());

            return data;
};

    QFuture<FMH::MODEL_LIST> t1 = QtConcurrent::run(func);
    watcher->setFuture(t1);
}

FMH::MODEL_LIST AndroidIntents::fetchAccounts()
{
    FMH::MODEL_LIST data;

    const auto array = this->mauia->getAccounts();
    QString xmlData(array);
    QDomDocument doc;

    if (!doc.setContent(xmlData)) return data;

    const QDomNodeList nodeList = doc.documentElement().childNodes();

    for (int i = 0; i < nodeList.count(); i++)
    {
        QDomNode n = nodeList.item(i);

        if(n.nodeName() == "account")
        {
            FMH::MODEL model;
            auto contact = n.toElement().childNodes();

            for(int i=0; i < contact.count(); i++)
            {
                const QDomNode m = contact.item(i);

                if(m.nodeName() == "name")
                {
                    const auto account = m.toElement().text();
                    model.insert(FMH::MODEL_KEY::ACCOUNT, account);

                }else if(m.nodeName() == "type")
                {
                    const auto type = m.toElement().text();
                    model.insert(FMH::MODEL_KEY::TYPE, type);

                }
            }

            data << model;
        }
    }
    return data;
}
