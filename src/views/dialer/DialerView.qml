import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3
import UnionModels 1.0
import "../contacts"

Maui.Page
{
    id: control
    property alias dialString : _textField.text

    onDialStringChanged: {
        Qt.inputMethod.hide();
        _suggestionList.query = dialString
    }
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
    footBarOverlap: true
    footBarAligment: Qt.AlignRight

    ColumnLayout
    {
        id: _layout
        width: parent.width * 0.8
        height: parent.height
        anchors.centerIn: parent
        spacing: space.big


        Rectangle
        {
            Layout.preferredHeight: toolBarHeight * 1.3
            Layout.fillWidth: true
            color: "#4f5160"
            //        border.color: borderColor
            radius: radiusV * 2
            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: space.big * 2
                anchors.rightMargin: space.big * 2

                Maui.TextField
                {
                    id: _textField
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    inputMethodHints: Qt.ImhDialableCharactersOnly
                    placeholderText: qsTr("Number...")
                    readOnly: true
                    font.bold: true
                    font.weight: Font.Bold
                    font.pointSize: fontSizes.huge

                    colorScheme.backgroundColor: "transparent"
                    colorScheme.borderColor: "transparent"
                    colorScheme.textColor: "#fff"
                    //            enabled: false
                }

                Item
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle
                    {
                        height: iconSizes.big
                        width: height
                        anchors.centerIn: parent
                        color: accentColor
                        radius: radiusV * 2
                        Maui.ToolButton
                        {
                            iconName: "phone"
                            anchors.centerIn: parent
                            onClicked:
                            {
                                if(isAndroid)
                                    Maui.Android.call(dialString)
                            }
                        }
                    }


                }
            }



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
                quickButtons: Maui.ToolButton
                {
                    iconName: "phone"

                    onClicked:
                    {
                        if(isAndroid)
                            Maui.Android.call(contact.tel)
                    }
                }

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
            visible: false

            Dialer
            {
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
            }
        }

    }



}
