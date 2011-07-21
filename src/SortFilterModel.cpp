/*
 *   Copyright 2010 by Marco Martin <mart@kde.org>

 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include "SortFilterModel.h"

#include <QDebug>

SortFilterModel::SortFilterModel(QObject* parent)
    : QSortFilterProxyModel(parent)
    , m_boolFilterIntRole(-1)
{
    setObjectName("SortFilterModel");
//    setDynamicSortFilter(true);
    connect(this, SIGNAL(rowsInserted(const QModelIndex &, int, int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(const QModelIndex &, int, int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(modelReset()),
            this, SIGNAL(countChanged()));
}

SortFilterModel::~SortFilterModel()
{
}

void SortFilterModel::syncRoleNames()
{
    m_roleIds.clear();

    setRoleNames(sourceModel()->roleNames());
    QHash<int, QByteArray>::const_iterator i;
    for (i = roleNames().constBegin(); i != roleNames().constEnd(); ++i) {
        m_roleIds[i.value()] = i.key();
    }
    setFilterRole(m_filterRole);
    setSortRole(m_sortRole);
}

int SortFilterModel::roleNameToId(const QString &name)
{
    if (!m_roleIds.contains(name)) {
        return -1;
    }
    return m_roleIds.value(name);
}

void SortFilterModel::setModel(QObject *source)
{
    QAbstractItemModel *model = qobject_cast<QAbstractItemModel *>(source);
    if (!model) {
        qDebug() << "Error: QAbstractItemModel type expected";
        return;
    }

    connect(model, SIGNAL(modelReset()), this, SLOT(syncRoleNames()));
    QSortFilterProxyModel::setSourceModel(model);
}




void SortFilterModel::setFilterRegExp(const QString &exp)
{
    //FIXME: this delaying of the reset signal seems to make the views behave a bit better, i.e. less holes and avoids some crashes, in theory shouldn't be necessary
    beginResetModel();
    blockSignals(true);
    QSortFilterProxyModel::setFilterRegExp(QRegExp(exp, Qt::CaseInsensitive));
    blockSignals(false);
    endResetModel();
}

QString SortFilterModel::filterRegExp() const
{
    return QSortFilterProxyModel::filterRegExp().pattern();
}

void SortFilterModel::setFilterRole(const QString &role)
{
    QSortFilterProxyModel::setFilterRole(roleNameToId(role));
    m_filterRole = role;
}

QString SortFilterModel::filterRole() const
{
    return m_filterRole;
}

void SortFilterModel::setBoolFilterRole(const QString &role)
{
    m_boolFilterIntRole = roleNameToId(role);
    m_boolFilterRole = role;
    invalidateFilter();
}

QString SortFilterModel::boolFilterRole() const
{
    return m_boolFilterRole;
}

void SortFilterModel::setSortRole(const QString &role)
{
    QSortFilterProxyModel::setSortRole(roleNameToId(role));
    m_sortRole = role;
    sort(0, sortOrder());
}

QString SortFilterModel::sortRole() const
{
    return m_sortRole;
}

void SortFilterModel::setSortOrder(const Qt::SortOrder order)
{
    sort(0, order);
}

bool SortFilterModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    if (m_boolFilterIntRole >= Qt::UserRole) {
        bool value = sourceModel()->data( sourceModel()->index(source_row, 0, source_parent), m_boolFilterIntRole ).toBool();
        if (value)
            return false;
    }
    return QSortFilterProxyModel::filterAcceptsRow(source_row, source_parent);
}

