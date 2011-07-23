#ifndef VARIANTMODEL_H
#define VARIANTMODEL_H

#include <QtCore>
#include <QObject>
#include <QAbstractItemModel>
#include <QThread>

#include "thumbnailcache.h"

class VariantModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit VariantModel(QObject *parent = 0);
    ~VariantModel();

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

    Q_PROPERTY(QString key READ key WRITE setkey)
public:
    QString key() { return m_key; }
    void setkey(QString val) { m_key = val; }
private:
    QString m_key;

    Q_PROPERTY(QObject* relatedModel READ relatedModel WRITE setrelatedModel)
public:
    QObject* relatedModel() { return static_cast<QObject*>(m_relatedModel); }
    void setrelatedModel(QObject* val);
private:
    VariantModel* m_relatedModel;

    Q_PROPERTY(QVariantList relatedFields READ relatedFields WRITE setrelatedFields)
public:
    QVariantList relatedFields() { return m_relatedFields; }
    void setrelatedFields(QVariantList val) { m_relatedFields = val; }
private:
    QVariantList m_relatedFields;


public:
    Q_PROPERTY(int count READ count)
public:
    int count() { return m_data.size(); }

    Q_PROPERTY(QString thumbDir READ thumbDir WRITE setthumbDir)
public:
    QString thumbDir() { return m_thumbDir; }
    void setthumbDir(QString val);
private:
    QString m_thumbDir;


    Q_PROPERTY(QString stream READ stream WRITE setstream)
public:
    QString stream() { return m_stream; }
    void setstream(QString val);
private:
    QString m_stream;


    /************ END PROPERTIES **************/

public:

    /*********** METTHODS ***************/

    Q_INVOKABLE void append(const QVariantMap &vals);
    Q_INVOKABLE void update(const QVariantMap &vals);
    Q_INVOKABLE void keyUpdate(const QVariantMap &vals);
    Q_INVOKABLE void remove(const QVariantMap &vals);
    Q_INVOKABLE void clear();

    Q_INVOKABLE void load();
    Q_INVOKABLE void save();

    /********** END METHODS *************/

protected:
    QVariant getKeyValue(const QVariantMap &vals);
    QVariant getKeyValue(int row);
    QVariant getIndexedKeyValue(const QVariant &key, const QString &valueField);

signals:

public slots:
    void thumbnailLoaded(const QModelIndex &index);
    void onRelatedModelDataChanged(QModelIndex,QModelIndex);
    void onRelatedModelRowsInserted(QModelIndex,int,int);

protected:
    bool m_initialised;
    bool m_dirty;

    QList< QVariantMap > m_data;
    QHash <QVariant, int> m_index;
    ThumbnailCacheThread* m_cacheThread;
    QHash< QVariant, QString > m_thumbFields;
};

Q_DECLARE_METATYPE ( QModelIndex )

#endif // VARIANTMODEL_H
