#include "VariantModel.h"

#include <QVariant>
#include <QPixmap>

uint qHash(const QVariant &v) { return qHash(v.toString()); }

const QSize VariantModel::thumbnailSize(128, 128);

VariantModel::VariantModel(QObject *parent)
    : QAbstractItemModel(parent)
    , m_relatedModel(0)
    , m_initialised(false)
    , m_dirty(false)
    , m_cacheThread(0)
{
    qRegisterMetaType<QModelIndex>("QModelIndex");
}

VariantModel::~VariantModel()
{
    if (m_cacheThread) {
        m_cacheThread->quit();
        m_cacheThread->wait(5000);
    }
}

int VariantModel::roleNameToId(const QString &name)
{
    int role = m_fields.indexOf(name);
    if (role == -1)
        return -1;

    return role + Qt::UserRole;
}

QVariant VariantModel::data(const QModelIndex &index, int role) const
{
    if (!m_initialised)
        return QVariant();

    if (!index.isValid())
        return QVariant();

    if (index.column() != 0)
        return QVariant();

    if (role < Qt::UserRole || role > Qt::UserRole + m_fields.size()-1)
        return QVariant();

    QVariant sRole = m_fields[role - Qt::UserRole];
    if (m_relatedModel) {
        if (m_relatedFields.contains(sRole)) {
            return m_relatedModel->getValue(m_data.at(index.row()).value(m_key), sRole.toString());
        }
    }

    if (m_thumbFields.contains(sRole)) {
        return m_cacheThread->thumbnail(QUrl(m_data.at(index.row()).value(m_thumbFields[sRole]).toString()), index);
    }

    return m_data.at(index.row()).value(sRole.toString());
}

int VariantModel::rowCount(const QModelIndex &parent) const
{
    return m_data.size();
}

int VariantModel::columnCount(const QModelIndex &parent) const
{
    return 1;
}

QModelIndex VariantModel::index(int row, int column, const QModelIndex &parent) const
{
    return hasIndex(row, column, parent) ? createIndex(row, column, 0) : QModelIndex();
}

QModelIndex VariantModel::parent(const QModelIndex &child) const
{
    return QModelIndex();
}

void VariantModel::setfields(QVariantList val)
{
    beginResetModel();

    m_fields = val;

    QHash<int, QByteArray> roleNames;
    for (int i=0; i<m_fields.size(); ++i) {
        roleNames[Qt::UserRole + i] = m_fields[i].toByteArray();

        if (m_fields[i].toString().endsWith("Thumb")) {
            QString imgField = m_fields[i].toString().remove("Thumb") ;
            for (int j=0; j<m_fields.size(); ++j) {
                if (m_fields[j] == imgField) {
                    m_thumbFields.insert(m_fields[i], m_fields[j].toString());
                    break;
                }
            }
        }
    }

    if (roleNames.size()) {
        setRoleNames(roleNames);
        m_initialised = true;
    }

    endResetModel();
}

void VariantModel::setthumbDir(QString val)
{
    m_thumbDir = val;
    if (m_cacheThread) {
        m_cacheThread->terminate();
        m_cacheThread->deleteLater();
    }
    m_cacheThread = new ThumbnailCacheThread(m_thumbDir, this);
    connect(m_cacheThread, SIGNAL(thumbnailReady(QModelIndex)), this, SLOT(thumbnailLoaded(QModelIndex)));

    m_cacheThread->start(QThread::LowPriority);
}

QString VariantModel::getKey()
{
    if (!m_key.isEmpty())
        return m_key;
    else
        return m_fields[0].toString();
}

QVariant VariantModel::getKeyValue(const QVariantMap &vals)
{
    return vals[getKey()];
}

QVariant VariantModel::getKeyValue(int row)
{
    return m_data[row].value(getKey());
}

QVariant VariantModel::getValue(const QVariant &keyvalue, const QString &valueField, const QVariant& defValue) const
{
    int row = m_index.value(keyvalue, -1);
    if (row == -1 || row >= m_data.size()) return QVariant(defValue);

    QVariant ret =  m_data[row].value(valueField);
    if (!ret.isValid()) return QVariant(defValue);

    return ret;
}

QVariantMap VariantModel::getValues(const QVariant &keyvalue) const
{
    int row = m_index.value(keyvalue, -1);
    if (row == -1 || row >= m_data.size()) return QVariantMap();

    return  m_data[row];
}

void VariantModel::setValue(const QVariant &keyvalue, const QString &valueField, const QVariant& value)
{
    int row = m_index.value(keyvalue, -1);
    if (row == -1 || row >= m_data.size()) {
        QVariantMap rowVal;
        rowVal.insert(m_key, keyvalue);
        rowVal.insert(valueField, value);
        return append(rowVal);
    } else {
        m_data[row][valueField] = value;
        QModelIndex index = createIndex(row, 0, 0);
        emit dataChanged(index, index);
        m_dirty = true;
    }
}

void VariantModel::removeValue(const QVariant &keyvalue, const QString &valueField)
{
    int row = m_index.value(keyvalue, -1);
    if (row == -1 || row >= m_data.size())
        return;

    m_data[row].remove(valueField);
    if (m_data[row].count() == 1) {
        QVariantMap rowVal;
        rowVal.insert(m_key, keyvalue);
        return remove(rowVal);
    }
    QModelIndex index = createIndex(row, 0, 0);
    emit dataChanged(index, index);
    m_dirty = true;
}

QVariant VariantModel::property(int i, QString sRole)
{
    return data(index(i, 0), roleNameToId(sRole));
}

bool VariantModel::setProperty(int i, QString sRole, QVariant val)
{
    m_data[i][sRole] = val;

    QModelIndex idx = index(i, 0);
    emit dataChanged(idx, idx);

    return true;
}


void VariantModel::append(const QVariantMap &vals)
{
    if (!m_initialised) return;

    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());

    m_data.append(vals);
    if (!m_key.isEmpty())
        m_index[getKeyValue(vals)] = m_data.size()-1;

    endInsertRows();
    m_dirty = true;
}

void VariantModel::update(const QVariantMap &vals)
{
    if (!m_initialised) return;

    QVariant keyVal = getKeyValue(vals);
    if (!keyVal.isValid()) {
        qDebug() << "VariantModel::update: invalid key: ";
        return;
    }

    int row = 0;
    for (; row < m_data.size(); ++row)
        if (getKeyValue(row) == keyVal)
            break;
    if (row == m_data.size()) {
        qDebug() << "VariantModel::update: key not found";
        return;
    }

    bool updated = false;
    QMapIterator<QString, QVariant> it(vals);
    while (it.hasNext()) {
        it.next();

        if (m_fields.contains(it.key()) && it.key() != getKey()) {
            m_data[row][it.key()] = it.value();
            qDebug() << "VariantModel::update: " << m_data[row][it.key()] << " = " << it.value();
            updated = true;
        }
    }

    if (updated) {
        QModelIndex index = createIndex(row, 0, 0);
        emit dataChanged(index, index);
        m_dirty = true;
    }
}

void VariantModel::keyUpdate(const QVariantMap &vals)
{
    if (!m_initialised) return;

    QVariant keyVal = getKeyValue(vals);
    if (!keyVal.isValid()) return;

    int row = m_index.value(keyVal, -1);
    if (row == -1)
        append(vals);
    else {
        bool updated = false;
        QMapIterator<QString, QVariant> it(vals);
        while (it.hasNext()) {
            it.next();

            if (m_fields.contains(it.key()) && it.key() != getKey()) {
                m_data[row][it.key()] = it.value();
                updated = true;
            }
        }

        if (updated) {
            QModelIndex index = createIndex(row, 0, 0);
            emit dataChanged(index, index);
            m_dirty = true;
        }
    }
}

void VariantModel::remove(const QVariantMap &vals)
{
    if (!m_initialised) return;

    QVariant keyVal = getKeyValue(vals);
    if (!keyVal.isValid()) return;

    int row = 0;
    for (; row < m_data.size(); ++row)
        if (getKeyValue(row) == keyVal)
            break;
    if (row == m_data.size()) return;

    if (!m_key.isEmpty())
        m_index.remove(keyVal);

    beginRemoveRows(QModelIndex(), row, row);
    m_data.removeAt(row);
    endRemoveRows();
    m_dirty = true;
}

void VariantModel::clear()
{
    if (!m_data.size())
        return;

    beginRemoveRows(QModelIndex(), 0, m_data.size()-1);
    m_data.clear();
    endRemoveRows();
}

void VariantModel::thumbnailLoaded(const QModelIndex& index)
{
    emit dataChanged(index, index);
}

void VariantModel::setrelatedModel(QObject *val)
{
    m_relatedModel = qobject_cast<VariantModel *>(val);
    if (!m_relatedModel) {
        qDebug() << "Error: VariantModel type expected";
        return;
    }
    connect(m_relatedModel, SIGNAL(dataChanged(QModelIndex,QModelIndex)), SLOT(onRelatedModelDataChanged(QModelIndex,QModelIndex)));
    connect(m_relatedModel, SIGNAL(rowsInserted(QModelIndex,int,int)), SLOT(onRelatedModelRowsInserted(QModelIndex,int,int)));
}

void VariantModel::onRelatedModelDataChanged(QModelIndex idxStart, QModelIndex idxEnd)
{
    for (int row=idxStart.row(); row<=idxEnd.row(); ++row) {
        QVariant keyval = m_relatedModel->getKeyValue(row);
        int myRow = m_index.value(keyval, -1);
        if (myRow != -1) {
            QModelIndex index = createIndex(myRow, 0, 0);
            emit dataChanged(index, index);
        }
    }
}

void VariantModel::onRelatedModelRowsInserted(QModelIndex parent, int start, int end)
{
    Q_UNUSED(parent);

    for (int row=start; row<=end; ++row) {
        QVariant keyval = m_relatedModel->getKeyValue(row);
        int myRow = m_index.value(keyval, -1);
        if (myRow != -1) {
            QModelIndex index = createIndex(myRow, 0, 0);
            emit dataChanged(index, index);
        }
    }
}

#define SERIALIZE_VERSION 2

void VariantModel::load()
{
    if (m_stream.isEmpty())
        return;

    clear();

    QFile file(m_stream);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Error reading from " << m_stream;
        return;
    }
    QDataStream in(&file);

    qint32 ver;
    in >> ver;

    if (ver != SERIALIZE_VERSION) {
        qDebug() << "File is from a previous version. Ignoring " << m_stream;
        return;
    }
    in >> m_data;
    in >> m_index;

    file.close();

    beginInsertRows(QModelIndex(), 0, m_data.size()-1);
    endInsertRows();

    m_dirty = false;
}

void VariantModel::save()
{
    if (m_stream.isEmpty() || !m_dirty)
        return;

    QFile file(m_stream);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Error serializing to " << m_stream;
        return;
    }
    QDataStream out(&file);

    out << (qint32) SERIALIZE_VERSION;  // version
    out << m_data;
    out << m_index;

    file.close();

    m_dirty = false;
}

void VariantModel::setstream(QString val)
{
    m_stream = val;
}
