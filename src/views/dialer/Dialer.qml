import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3
import UnionModels 1.0

GridLayout
{
    height: parent.height
    width: parent.width
    anchors.centerIn: parent
    columns: 3
    rows: 3
    rowSpacing: space.big
    columnSpacing: space.big
    //                spacing: space.medium
    readonly property int buttonFontSize: fontSizes.huge * 1.5
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "1";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "2";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "3";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "4";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "5";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "6";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "7";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "8";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "9";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "*";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "0 / +";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked: dialString += "0"
        onPressAndHold: dialString += "+"


    }
    Maui.Button
    {
        Layout.fillWidth: true;
        Layout.fillHeight: true;
        text: "#";
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: buttonFontSize
        onClicked:
        {
            dialString += text;
        }
    }
}
