#ifndef UNION_H
#define UNION_H

#if (defined (Q_OS_LINUX) && !defined (Q_OS_ANDROID))
#include <MauiKit/fmh.h>
#else
#include "fmh.h"
#endif

#define APPNAME "Communicator"
#define APPVERSION "1.0.0"

namespace UNI
{
const QString AppName = APPNAME;
const QString AppVersion = APPVERSION;
const QString AppComment = "Contacs manager and dialer";
const QString DBName = "collection.db";
const QString CollectionDBPath = FMH::DataPath + QString("/%1/").arg(APPNAME);

enum class TABLE : uint8_t
{
    CONTACTS
};

static const QMap<TABLE,QString> TABLEMAP =
{
    {TABLE::CONTACTS,"contacts"}
};

};

#endif // UNION_H
