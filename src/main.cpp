#include <QQmlApplicationEngine>

#include <QQmlApplicationEngine>
#include <QQmlContext>
 #include <QQuickStyle>
#include <QIcon>
#include <QCommandLineParser>
#include <QFileInfo>
#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QIcon>
#else
#include <QApplication>
#endif

#include "src/union.h"

#include "./src/models/basemodel.h"
#include "./src/models/baselist.h"
#include "./src/models/contacts/contactsmodel.h"

#ifdef STATIC_KIRIGAMI
#include "./3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#ifdef STATIC_MAUIKIT
#include "./mauikit/src/mauikit.h"
#include <QStyleHints>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    QGuiApplication::styleHints()->setMousePressAndHoldInterval(2000); // in [ms]
#else
    QApplication app(argc, argv);
#endif

    app.setApplicationName(APPNAME);
    app.setApplicationVersion(APPVERSION);
    app.setApplicationDisplayName(APPNAME);
    app.setWindowIcon(QIcon(":/smartphone.svg"));


    QQmlApplicationEngine engine;
//    QQuickStyle::setStyle("Material");

#ifdef STATIC_KIRIGAMI
    KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
    MauiKit::getInstance().registerTypes();

#endif

    qmlRegisterUncreatableType<BaseList>("UnionModels", 1, 0, "BaseList", QStringLiteral("BaseList should not be created in QML"));
    qmlRegisterType<BaseModel>("UnionModels", 1, 0, "BaseModel");
    qmlRegisterType<ContactsModel>("UnionModels", 1, 0, "ContactsList");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
