#ifndef QSTRINGLISTMODELFORQML_H
#define QSTRINGLISTMODELFORQML_H

#include <QObject>
#include <QStringListModel>

class QStringListModelForQML : public QStringListModel
{
    Q_OBJECT
public:
    explicit QStringListModelForQML(const QByteArray &displayRoleName = "name", QObject *parent = 0);
    void setStringList(const QStringList &strings);
    
signals:

//    void stringAdded(const QString &newString);
    void stringAdded(QVariant newString);
    // Emitted when setStringList is called if already contained strings
    void stringsReset();

};

#endif // QSTRINGLISTMODELFORQML_H
