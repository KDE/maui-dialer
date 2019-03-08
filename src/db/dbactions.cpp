/***
Pix  Copyright (C) 2018  Camilo Higuita
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.

 This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
***/

#include "dbactions.h"

#ifdef STATIC_MAUIKIT
#include "fm.h"
#else
#include <MauiKit/fm.h>
#endif

DBActions::DBActions(QObject *parent) : DB(parent) {}

DBActions::~DBActions() {}

void DBActions::init()
{
    qDebug() << "Getting collectionDB info from: " << UNI::CollectionDBPath;

    qDebug()<< "Starting DBActions";
}

DBActions *DBActions::instance = nullptr;

DBActions *DBActions::getInstance()
{
    if(!instance)
    {
        instance = new DBActions();
        qDebug() << "getInstance(): First DBActions instance\n";
        instance->init();
        return instance;
    } else
    {
        qDebug()<< "getInstance(): previous DBActions instance\n";
        return instance;
    }
}

bool DBActions::execQuery(const QString &queryTxt)
{
    auto query = this->getQuery(queryTxt);
    return query.exec();
}

bool DBActions::insertContact(const FMH::MODEL &con)
{

    auto contact = FM::toMap(con);
    contact.insert(FMH::MODEL_NAME[FMH::MODEL_KEY::ADDDATE], QDateTime::currentDateTime().toString(Qt::TextDate));
    contact.insert(FMH::MODEL_NAME[FMH::MODEL_KEY::MODIFIED], QDateTime::currentDateTime().toString(Qt::TextDate));


    return this->insert(UNI::TABLEMAP[UNI::TABLE::CONTACTS], contact);
}


bool DBActions::removeContact(const QString &id)
{
    const auto queryTxt = QString("DELETE FROM contacts WHERE id =  \"%1\"").arg(id);
    return this->execQuery(queryTxt);
}

bool DBActions::updateContact(const FMH::MODEL &con)
{
    auto contact = con;
    contact.insert(FMH::MODEL_KEY::MODIFIED, QDateTime::currentDateTime().toString(Qt::TextDate));
    QVariantMap where =  {{FMH::MODEL_NAME[FMH::MODEL_KEY::ID], con[FMH::MODEL_KEY::ID]}};
    return this->update(UNI::TABLEMAP[UNI::TABLE::CONTACTS], con, where);
}

bool DBActions::favContact(const QString &id, const bool &fav )
{
    if(!this->checkExistance(UNI::TABLEMAP[UNI::TABLE::CONTACTS], FMH::MODEL_NAME[FMH::MODEL_KEY::ID], id))
        return false;

    const FMH::MODEL faved = {{FMH::MODEL_KEY::FAV, fav ? "1" : "0"}};
    return this->update(UNI::TABLEMAP[UNI::TABLE::CONTACTS], faved, QVariantMap({{FMH::MODEL_NAME[FMH::MODEL_KEY::ID], id}}) );
}


bool DBActions::isFav(const QString &id)
{
    const auto data = this->getDBData(QString("select * from contacts where id = '%1'").arg(id));

    if (data.isEmpty()) return false;

    return data.first()[FMH::MODEL_KEY::FAV] == "1" ? true : false;
}


FMH::MODEL_LIST DBActions::getDBData(const QString &queryTxt)
{
    FMH::MODEL_LIST mapList;

    auto query = this->getQuery(queryTxt);

    if(query.exec())
    {
        while(query.next())
        {
            FMH::MODEL data;
            for(auto key : FMH::MODEL_NAME.keys())
                if(query.record().indexOf(FMH::MODEL_NAME[key]) > -1)
                    data.insert(key, query.value(FMH::MODEL_NAME[key]).toString());
            mapList<< data;
        }

    }else qDebug()<< query.lastError()<< query.lastQuery();

    return mapList;
}


