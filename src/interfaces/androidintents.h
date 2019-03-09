#ifndef ANDROIDINTENTS_H
#define ANDROIDINTENTS_H

#include <QObject>

class AndroidIntents : public QObject
{
    Q_OBJECT
public:
    explicit AndroidIntents(QObject *parent = nullptr);

signals:

public slots:
};

#endif // ANDROIDINTENTS_H