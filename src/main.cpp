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
#include "models/contacts/contactsmodel.h"
#include "models/contacts/calllogs.h"
#include "interfaces/contactimage.h"

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
    //    QGuiApplication::styleHints()->setMousePressAndHoldInterval(2000); // in [ms]
#else
    QApplication app(argc, argv);
#endif

    app.setApplicationName(APPNAME);
    app.setApplicationVersion(APPVERSION);
    app.setApplicationDisplayName(APPNAME);
    app.setWindowIcon(QIcon(":/smartphone.svg"));

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
    if(parser.isSet("sync"))
    {
        qDebug()<< "TESTING P";
        return 0;
    }

    {
        QQmlApplicationEngine engine;
        //    QQuickStyle::setStyle("Material");

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
}
