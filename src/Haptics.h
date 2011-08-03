#ifndef HAPTICS_H
#define HAPTICS_H

#include <QObject>

class Haptics : public QObject
{
    Q_OBJECT
public:
    explicit Haptics(QObject *parent = 0);

signals:

public slots:
    Q_INVOKABLE void basicButtonClick();
    Q_INVOKABLE void sensitiveButtonClick();

};

#endif // HAPTICS_H
