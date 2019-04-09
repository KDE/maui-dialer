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

#ifndef DBACTIONS_H
#define DBACTIONS_H

#include <QObject>
#include "db.h"

#ifdef STATIC_MAUIKIT
#include "fmh.h"
#else
#include <MauiKit/fmh.h>
#endif

class DBActions : public DB
{
    Q_OBJECT

public:
    static DBActions *getInstance();

    bool execQuery(const QString &queryTxt);

    bool insertContact(const FMH::MODEL &con);
    bool removeContact(const QString &id);
    bool updateContact(const FMH::MODEL &con);
    void removeAll();

    /* utils */
    FMH::MODEL_LIST getDBData(const QString &queryTxt);

public slots:
    bool favContact(const QString &id, const bool &fav);
    bool isFav(const QString &id);

private:
    static DBActions* instance;
    explicit DBActions(QObject *parent = nullptr);
    ~DBActions();
    void init();

signals:
    void contactRemoved();
};

#endif // DBACTIONS_H
