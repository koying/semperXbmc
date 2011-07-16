#ifndef VARIANTMODEL_H
#define VARIANTMODEL_H

#include <QtCore>
#include <QObject>
#include <QAbstractItemModel>

#include "thumbnailcache.h"

class VariantModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit VariantModel(QObject *parent = 0);

    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual int rowCount ( const QModelIndex & parent = QModelIndex() ) const;
    virtual int columnCount(const QModelIndex &parent = QModelIndex()) const ;

    virtual QModelIndex index(int row, int column,
                              const QModelIndex &parent = QModelIndex()) const;
    virtual QModelIndex parent(const QModelIndex &child) const;

    static const QSize thumbnailSize;

    /************ PROPERTIES ******************/

public:
    Q_PROPERTY(QVariantList fields READ fields WRITE setfields)
public:
    QVariantList fields() { return m_fields; }
    void setfields(QVariantList val);
private:
    QVariantList m_fields;

public:
    Q_PROPERTY(int count READ count)
public:
    int count() { return m_data.size(); }

    /************ END PROPERTIES **************/

public:

    /*********** METTHODS ***************/

    Q_INVOKABLE void append(const QVariantMap &vals);
    Q_INVOKABLE void clear();

    /********** END METHODS *************/
signals:

public slots:
    void thumbnailLoaded(const QModelIndex &index);

protected:
    bool m_initialised;

    QList< QVariantMap > m_data;
    mutable ThumbnailCache m_cache;
    QHash< QVariant, QString > m_thumbFields;
};

#endif // VARIANTMODEL_H
