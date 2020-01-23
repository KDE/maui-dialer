#include <QQmlApplicationEngine>
#include <QIcon>
#include <QCommandLineParser>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QIcon>
#else
#include <QApplication>
#endif

#include "src/union.h"
#include "src/models/contacts/contactsmodel.h"
#include "src/models/contacts/calllogs.h"
#include "contactimage.h"

#ifdef STATIC_KIRIGAMI
#include "./3rdparty/kirigami/src/kirigamiplugin.h"
#endif

#ifdef STATIC_MAUIKIT
#include "./3rdparty/mauikit/src/mauikit.h"
#include <QStyleHints>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE",
                                              "android.permission.READ_CALL_LOG",
                                              "android.permission.SEND_SMS",
                                              "android.permission.CALL_PHONE",
                                              "android.permission.MANAGE_ACCOUNTS",
                                              "android.permission.GET_ACCOUNTS",
                                              "android.permission.READ_CONTACTS"}))
        return -1;
#else
    QApplication app(argc, argv);
#endif

    app.setApplicationName(UNI::appName);
    app.setApplicationVersion(UNI::version);
    app.setApplicationDisplayName(UNI::displayName);
    app.setOrganizationName(UNI::orgName);
    app.setOrganizationDomain(UNI::orgDomain);
    app.setWindowIcon(QIcon(":/contacts.svg"));

    QCommandLineParser parser;
    parser.addOptions({
                          // A boolean option with a single name (-p)
                          {"sync",
                           QCoreApplication::translate("main", "Show progress during copy")},
                          // A boolean option with multiple names (-f, --force)
                          {{"f", "force"},
                           QCoreApplication::translate("main", "Overwrite existing files.")},
                          // An option with a value
                          {{"t", "target-directory"},
                           QCoreApplication::translate("main", "Copy all source files into <directory>."),
                           QCoreApplication::translate("main", "directory")},
                      });
    parser.process(app);

    QQmlApplicationEngine engine;

#ifdef STATIC_KIRIGAMI
    KirigamiPlugin::getInstance().registerTypes();
#endif

#ifdef STATIC_MAUIKIT
    MauiKit::getInstance().registerTypes();
#endif

    engine.addImageProvider("contact", new ContactImage(QQuickImageProvider::ImageType::Image));
    qmlRegisterType<ContactsModel>("UnionModels", 1, 0, "ContactsList");
    qmlRegisterType<CallLogs>("UnionModels", 1, 0, "CallLogs");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
