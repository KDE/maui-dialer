import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami

Maui.Dialog
{

    id: control

    maxWidth: unit * 500
    maxHeight: maxWidth


  Maui.Editor
    {
        id: _editor
        anchors.fill: parent
        headBar.drawBorder: false
    }
}
