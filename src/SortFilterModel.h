/*
 *   Copyright 2010 by Marco MArtin <mart@kde.org>

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

#ifndef SORTFILTERMODEL_H
#define SORTFILTERMODEL_H

#include <QObject>
#include <QAbstractItemModel>
#include <QSortFilterProxyModel>
#include <QVector>

class SortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QObject *sourceModel READ sourceModel WRITE setModel)

    Q_PROPERTY(QString filterRegExp READ filterRegExp WRITE setFilterRegExp)
    Q_PROPERTY(QString filterRole READ filterRole WRITE setFilterRole)
    Q_PROPERTY(QString sortRole READ sortRole WRITE setSortRole)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder)
    Q_PROPERTY(int count READ count NOTIFY countChanged)

    friend class DataModel;

public:
    SortFilterModel(QObject* parent=0);
    ~SortFilterModel();

    //FIXME: find a way to make QML understnd QAbstractItemModel
    void setModel(QObject *source);

    void setFilterRegExp(const QString &exp);
    QString filterRegExp() const;

    void setFilterRole(const QString &role);
    QString filterRole() const;

    void setSortRole(const QString &role);
    QString sortRole() const;

    void setSortOrder(const Qt::SortOrder order);

    int count() const {return QSortFilterProxyModel::rowCount();}

Q_SIGNALS:
    void countChanged();

protected:
    int roleNameToId(const QString &name);

protected Q_SLOTS:
    void syncRoleNames();

private:
    QString m_filterRole;
    QString m_sortRole;
    QHash<QString, int> m_roleIds;
};

#endif // SORTFILTERMODEL_H
