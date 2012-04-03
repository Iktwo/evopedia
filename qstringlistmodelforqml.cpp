
#include "qstringlistmodelforqml.h"
#include <QDebug>

QStringListModelForQML::QStringListModelForQML(const QByteArray &roleName) {
    QHash<int, QByteArray> roleNames;
    roleNames.insert(CustomRole, roleName);
    setRoleNames(roleNames);
}

void QStringListModelForQML::setStringList(const QStringList &strings) {
    list = strings;

    reset();
}

QVariant QStringListModelForQML::data(const QModelIndex &index, int role) const {
    if (role != CustomRole)
        return QVariant();

    int i = index.row();

    if (i < 0 || i >= list.size())
        return QVariant();

    return list[i];
}

int QStringListModelForQML::rowCount(const QModelIndex &) const {
    return list.size();
}

int QStringListModelForQML::getSize() const {
    return list.size();
}

QString QStringListModelForQML::get(int i) const {
    return list[i];
}
