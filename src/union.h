#ifndef UNION_H
#define UNION_H

#include <QString>

#ifndef STATIC_MAUIKIT
#include "contacts_version.h"
#endif

namespace UNI
{
const static inline QString appName = "contacts";
const static inline QString version = CONTACTS_VERSION_STRING;
const static inline QString comment = "Contacs manager and dialer";
const static inline QString displayName = "Contacts";
const static inline QString orgName = "Maui";
const static inline QString orgDomain = "org.maui.contacts";
};

#endif // UNION_H
