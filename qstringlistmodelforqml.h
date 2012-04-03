#ifndef QSTRINGLISTMODELFORQML_H
#define QSTRINGLISTMODELFORQML_H

#include <QObject>
#include <QStringListModel>

class QStringListModelForQML : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        CustomRole = Qt::UserRole + 1
    };

    Q_PROPERTY(int size
               READ getSize)

    explicit QStringListModelForQML(const QByteArray &roleName = "name");

    void setStringList(const QStringList &strings);

    QVariant data(const QModelIndex &index, int role) const;

    int rowCount(const QModelIndex&) const;

    int getSize() const;

public slots:
    QString get(int i) const;
    
private:
    QStringList list;
};

#endif // QSTRINGLISTMODELFORQML_H
