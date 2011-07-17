#include "VariantModel.h"

#include <QVariant>
#include <QPixmap>

uint qHash(const QVariant &v) { return qHash(v.toString()); }

const QSize VariantModel::thumbnailSize(128, 128);

VariantModel::VariantModel(QObject *parent)
    : QAbstractItemModel(parent)
    , m_initialised(false)
    , m_cacheThread(0)
{
    qRegisterMetaType<QModelIndex>("QModelIndex");
}

VariantModel::~VariantModel()
{
    if (m_cacheThread) {
        m_cacheThread->terminate();
        m_cacheThread->wait(5000);
    }
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

    if (m_thumbFields.contains(m_fields[role - Qt::UserRole])) {
        return m_cacheThread->thumbnail(QUrl(m_data.at(index.row()).value(m_thumbFields[m_fields[role - Qt::UserRole]]).toString()), index);
    }

    return m_data.at(index.row()).value(m_fields[role - Qt::UserRole].toString());
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
    setRoleNames(roleNames);

    m_initialised = true;

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

void VariantModel::append(const QVariantMap &vals)
{
    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());

    m_data.append(vals);

    endInsertRows();
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
