import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3
import UnionModels 1.0

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

            Maui.Button
            {
                height: buttonSize
                width: height
                anchors.centerIn: parent
//                bg.radius: Math.max(width, height)
                text: modelData
                font.bold: true
                font.weight: Font.Bold
                font.pointSize: buttonFontSize
                onClicked:
                {
                    dialString += text;
                }
            }
        }
    }
}
