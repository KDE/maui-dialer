#ifndef SYNCHRONISER_H
#define SYNCHRONISER_H

#include <QObject>
#ifdef STATIC_MAUIKIT
#include "fmh.h"
#else
#include <MauiKit/fmh.h>
#endif

#include "vcard.h"


class DBActions;
class Synchroniser : public QObject
{
    Q_OBJECT
public:
    explicit Synchroniser(QObject *parent = nullptr);

    FMH::MODEL_LIST getContacts(const QString &query);
    bool insertContact(const FMH::MODEL &contact);
    bool updateContact(const FMH::MODEL &contact);

private:
    DBActions *dba;
    vCard tovCard(const FMH::MODEL &contact);

signals:

public slots:
};

#endif // SYNCHRONISER_H
