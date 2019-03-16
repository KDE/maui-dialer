import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3
import UnionModels 1.0
import "../contacts"

Maui.Page
{
    id: control
    property string dialString : _textField.text

    onDialStringChanged: _suggestionList.query = dialString
    colorScheme.backgroundColor: backgroundColor
    headBar.visible: false

    footBar.middleContent: Maui.ToolButton
    {
        iconName: "view-list-icons"
        onClicked: _dialerPad.visible = !_dialerPad.visible
        checkable: true
        checked: _dialerPad.visible

    }

    floatingBar: true
    footBarAligment: Qt.AlignRight

    ColumnLayout
    {
        id: _layout
        width: parent.width * 0.8
        height: parent.height
        anchors.centerIn: parent
        spacing: space.big


        Maui.TextField
        {
            id: _textField
            Layout.preferredHeight: toolBarHeightAlt
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: qsTr("Number...")
        }

        ListView
        {
            id: _suggestionListView
            spacing: space.big
            clip: true
            visible: count >0
            Layout.fillWidth: true
            Layout.fillHeight: visible

            model: BaseModel
            {
                id: _suggestionModel
                list: ContactsList
                {
                    id: _suggestionList
                }
            }

            delegate: ContactDelegate
            {
                id: _delegate

                height: unit * 80
                width: _layout.width
                anchors.horizontalCenter: parent.horizontalCenter

                Connections
                {
                    target: _delegate
                    onClicked:
                    {
                        _suggestionListView.currentIndex = index
                        if(isAndroid)
                            Maui.Android.call(_suggestionList.get(_suggestionListView.currentIndex).tel)
                    }
                }
            }
        }

                Item
                {
                    id: _dialerPad
                    Layout.fillHeight: true
                    Layout.fillWidth: true

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

                        Maui.Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "1"; onClicked: { dialString += "1";} }
                        Maui.Button  { Layout.fillWidth: true; Layout.fillHeight: true; text: "2"; onClicked: { dialString += "2";} }
                        Maui.Button  { Layout.fillWidth: true; Layout.fillHeight: true; text: "3"; onClicked: { dialString += "3";} }
                        Maui.Button  { Layout.fillWidth: true; Layout.fillHeight: true; text: "4"; onClicked: { dialString += "4";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "5"; onClicked: { dialString += "5";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "6"; onClicked: { dialString += "6";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "7"; onClicked: { dialString += "7";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "8"; onClicked: { dialString += "8";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "9"; onClicked: { dialString += "9";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "*"; onClicked: { dialString += "*";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "0"; onClicked: { dialString += "0";} }
                        Maui.Button  {Layout.fillWidth: true; Layout.fillHeight: true; text: "#"; onClicked: { dialString += "#";} }
                    }
                }

    }



}
