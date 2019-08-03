import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3

GridLayout
{
    id: _grid
    height: parent.height
    width: parent.width
    anchors.centerIn: parent
    columns: 3
    rows: 3
    rowSpacing: space.big
    columnSpacing: space.big
    //                spacing: space.medium
    readonly property int buttonFontSize: fontSizes.huge * 1.5
    property var model : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"]

    Repeater
    {
        model: _grid.model

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            DialerButton
            {
                height: buttonSize
                width: height
                anchors.centerIn: parent
                text: modelData
            }
        }
    }
}
