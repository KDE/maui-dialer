#ifndef SYNCING_H
#define SYNCING_H

#include <QObject>
#ifdef STATIC_MAUIKIT
#include "fmh.h"
#else
#include <MauiKit/fmh.h>
#endif

class Syncing : public QObject
{
    Q_OBJECT
public:
    explicit Syncing(QObject *parent = nullptr);

    FMH::MODEL_LIST getContacts(const QString &query);

signals:

public slots:
};

#endif // SYNCING_H
