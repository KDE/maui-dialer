#ifndef UNION_H
#define UNION_H

#include <QString>

#include "dialer_version.h"

#define APPNAME "Communicator"
#define APPVERSION DIALER_VERSION_STRING

namespace UNI
{
const QString AppName = APPNAME;
const QString AppVersion = APPVERSION;
const QString AppComment = "Contacs manager and dialer";
};

#endif // UNION_H
