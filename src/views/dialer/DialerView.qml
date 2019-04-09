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

    onDialStringChanged:
    {
        //        Qt.inputMethod.hide();
        _contacsView.list.query = dialString
    }
    colorScheme.backgroundColor: backgroundColor
    headBar.visible: false

    //    footBar.middleContent: Maui.ToolButton
    //    {
    //        iconName: "view-list-icons"
    //        onClicked: _dialerPad.visible = !_dialerPad.visible
    //        checkable: true
    //        checked: _dialerPad.visible

    //    }

    //    floatingBar: true
    //    footBarOverlap: true
    //    footBarAligment: Qt.AlignRight

    ColumnLayout
    {
        id: _layout
        width: Math.min(isWide ? control.width * 0.8 : control.width * 0.95, unit * 500)
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
                anchors.fill : parent
                spacing: 0

                Item
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
//                    Layout.leftMargin: space.big * 2
                    Maui.TextField
                    {
                        id: _textField
                        anchors.fill: parent
                        inputMethodHints: Qt.ImhDialableCharactersOnly
                        placeholderText: qsTr("Number...")
                        readOnly: true
                        font.bold: true
                        font.weight: Font.Bold
                        font.pointSize: fontSizes.huge
                        font.letterSpacing: space.tiny

                        colorScheme.backgroundColor: "transparent"
                        colorScheme.borderColor: "transparent"
                        colorScheme.textColor: "#fff"
                        //            enabled: false
                    }

                }


                Item
                {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height
                    visible: dialString.length

                    Rectangle
                    {
                        height: parent.height
                        width: height
                        anchors.centerIn: parent
                        color: highlightColor
                        radius: radiusV * 2

                        Rectangle
                        {
                            height: parent.height
                            width: parent.radius
                            anchors.left: parent.left
                            color: parent.color
                        }

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
            visible: dialString.length
            Layout.fillWidth: true
            Layout.minimumHeight: (unit * 80) * 1.5
            Layout.fillHeight: true
            Layout.preferredHeight: control.height * 0.3

            model: _contacsView.listModel

            delegate: ContactDelegate
            {
                id: _delegate

                height: unit * 60
                width: _layout.width
                anchors.horizontalCenter: parent.horizontalCenter
//                quickButtons: Maui.ToolButton
//                {
//                    iconName: "phone"
//                    backgroundRec.radius: radiusV
//                    backgroundRec.color: highlightColor
//                    backgroundRec.opacity: 0.5
//                    iconColor: highlightColor

//                    onClicked:
//                    {
//                        if(isAndroid)
//                            Maui.Android.call(contact.tel)
//                    }
//                }

                Connections
                {
                    target: _delegate
                    onClicked:
                    {
                        _suggestionListView.currentIndex = index
                        if(isAndroid)
                            Maui.Android.call(_contacsView.list.get(_suggestionListView.currentIndex).tel)
                    }
                }
            }
        }

        Item
        {
            id: _dialerPad
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: unit*300
            Layout.maximumHeight: unit*300

            Layout.alignment: Qt.AlignCenter
            //            visible: true

            Dialer
            {
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
            }
        }

    }



}
