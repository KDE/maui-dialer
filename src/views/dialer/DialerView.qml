import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.7 as Kirigami
import QtQuick.Layouts 1.3
import "../contacts"

Maui.Page
{
    id: control
    property alias dialString : _textField.text

    property int buttonSize : Math.min( iconSizes.big * 2 , control.width * 0.25)
    onDialStringChanged:
    {
        //        Qt.inputMethod.hide();
        _contacsView.list.query = "tel=" + dialString
    }
    //    colorScheme.backgroundColor: backgroundColor

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

    headBar.middleContent:  Maui.TextField
    {
        id: _textField
        Layout.fillWidth: true
        inputMethodHints: Qt.ImhDialableCharactersOnly
        placeholderText: qsTr("Number...")
        readOnly: true
        font.bold: true
        font.weight: Font.Bold
        font.pointSize: fontSizes.huge
        font.letterSpacing: space.tiny
        horizontalAlignment: TextInput.AlignHCenter
        background: Rectangle
        {
            color: "transparent"
        }

        //            enabled: false
    }

    footBar.background: Rectangle
    {
        color: "transparent"
    }

    footBar.implicitHeight:  iconSizes.big * 3
    footBar.middleContent: [

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Button
            {
                icon.name: "message-new"
                icon.color: Kirigami.Theme.textColor
                height: buttonSize
                width: height
                anchors.centerIn: parent
                //                bg.radius: Math.max(width, height)
                //                colorScheme.backgroundColor: infoColor
                onClicked:
                {
                    _messageComposer.contact = ({tel : dialString})
                    _messageComposer.open()
                }
            }

        },

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Button
            {
                icon.name: "call-start"
                icon.color: "white"
                icon.width: iconSizes.big
                icon.height: iconSizes.big
                height: buttonSize
                width: height
                anchors.centerIn: parent
                //                bg.radius: Math.max(width, height)
                Kirigami.Theme.backgroundColor: suggestedColor

                onClicked:
                {
                    if(isAndroid)
                        Maui.Android.call(dialString)
                    else
                        Qt.openUrlExternally("call://" + dialString)
                }
            }
        },

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Button
            {
                icon.name: "edit-clear"
                icon.color: Kirigami.Theme.textColor
                height: iconSizes.big * 2
                width: height
                anchors.centerIn: parent
                //                bg.radius: Math.max(width, height)
                //                colorScheme.backgroundColor: warningColor

                onClicked:
                {
                    dialString = dialString.slice(0, -1);
                }
            }
        }
    ]

    ColumnLayout
    {
        id: _layout
        width: Math.min(isWide ? control.width * 0.8 : control.width * 0.95, unit * 500)
//        height: parent.height
        anchors.centerIn: parent
        spacing: space.big

        ListView
        {
            id: _suggestionListView
            spacing: space.big
            clip: true
            visible: count
            Layout.fillWidth: visible
            Layout.minimumHeight: visible ? _60 : 0
            Layout.preferredHeight: visible ? 60 * 2 : 0

            model: _contacsView.listModel

            delegate: ContactDelegate
            {
                id: _delegate

                height: unit * 60
                width: _layout.width
                anchors.horizontalCenter: parent.horizontalCenter

                quickButtons: ToolButton
                {
                    icon.name: "view-fullscreen"
                    onClicked:
                    {
                        _suggestionListView.currentIndex = index
                        control.dialString = _contacsView.list.get(_suggestionListView.currentIndex).tel
                    }
                }

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

            Layout.alignment: Qt.AlignBottom
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
