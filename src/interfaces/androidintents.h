#ifndef ANDROIDINTENTS_H
#define ANDROIDINTENTS_H

#include <QObject>
#include "fmh.h"

class MAUIAndroid;
class AndroidIntents : public QObject
{
    Q_OBJECT
public:
    explicit AndroidIntents(QObject *parent = nullptr);
    void call(const QString &tel);

    FMH::MODEL_LIST getContacts();

private:
    MAUIAndroid *mauia;

signals:

public slots:
};

#endif // ANDROIDINTENTS_H
