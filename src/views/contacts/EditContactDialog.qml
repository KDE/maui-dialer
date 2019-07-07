import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.6 as Kirigami

Maui.Dialog
{
    id: control

    maxWidth: unit * 700
    maxHeight: unit * 800
    //    heightHint: 1
    //    widthHint: 1
    rejectButton.visible: false
    acceptButton.visible: false
    //    rejectButton.text: qsTr("Cancel")
    //    closeButton.visible: true

    property var contact : ({})
    signal newContact(var contact)

    onRejected: control.close()

    footBar.leftContent: Button
    {
        text: qsTr("Cancel")
        Kirigami.Theme.backgroundColor: warningColor
        Kirigami.Theme.textColor: "#fff"
        onClicked: control.close()
    }

    footBar.rightContent: Button
    {
        text: qsTr("Save")
        Kirigami.Theme.backgroundColor: infoColor
        Kirigami.Theme.textColor: "#fff"

        onClicked:
        {
            var contact =({
                              n: _nameField.text,
                              tel: _telField.text,
                              email: _emailField.text,
                              org: _orgField.text,
                              //                          adr: _adrField.text,
                              photo: _img.source,
                              account: isAndroid ? _accountsCombobox.model[_accountsCombobox.currentIndex] :({})
                          })

            if(contact.n.length && contact.tel.length)
                newContact(contact)
            control.clear()
        }
    }

    ColumnLayout
    {
        id: _layout
        height: parent.height
        width: parent.width * 0.8

        anchors.centerIn: parent

        Item
        {
            id: _contactPic
            Layout.fillWidth: true
            Layout.preferredHeight: iconSizes.huge

            Rectangle
            {
                height: Math.min(parent.height, control.width)
                width: height
                anchors.centerIn: parent
                radius: Math.min(width, height)
                color: Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                border.color: Qt.darker(color, 1.5)

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:{

                        _fileDialog.mode = _fileDialog.modes.OPEN
                        _fileDialog.filterType= Maui.FMList.IMAGE
                        _fileDialog.show(function(paths)
                        {
                            console.log("selected image", paths)
                            _img.source = "file://"+paths[0]
                        })
                    }
                }


                Image
                {
                    id: _img
                    width: parent.width
                    height: width

                    anchors.centerIn: parent

                    sourceSize.width: parent.width
                    sourceSize.height: parent.height

                    fillMode: Image.PreserveAspectCrop
                    cache: true
                    antialiasing: true
                    smooth: true
                    asynchronous: true

                    layer.enabled: true
                    layer.effect: OpacityMask
                    {
                        maskSource: Item
                        {
                            width: _img.width
                            height: _img.height

                            Rectangle
                            {
                                anchors.centerIn: parent
                                width: _img.width
                                height: _img.height
                                radius: Math.min(width, height)
                                border.color: borderColor
                            }
                        }
                    }
                }

                ToolButton
                {
                    icon.name: "list-add"
                    icon.color: "white"
                    enabled: false
                    icon.width: iconSizes.big
                    anchors.centerIn: parent
                }
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView
            {
                anchors.fill: parent
                contentHeight: _formLayout.implicitHeight
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                //                boundsBehavior: Flickable.StopAtBounds
                //interactive: false
                ColumnLayout
                {
                    id: _formLayout
                    width: _layout.width * 0.95
                    //                    implicitHeight: control.height
                    spacing: space.large

                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        visible: isAndroid
                        Label
                        {
                            text: qsTr("Account")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                            color: textColor
                        }

                        Maui.ComboBox
                        {
                            id: _accountsCombobox
                            textRole: "account"
                            popup.z: control.z +1
                            width: parent.width
                        }
                    }

                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Name")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                            color: textColor
                        }

                        Maui.TextField
                        {
                            id: _nameField
                            width: parent.width
                            text: contact.n
                        }
                    }



                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Phone")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                            color: textColor
                        }

                        Maui.TextField
                        {
                            id: _telField
                            width: parent.width
                            text: contact.tel
                            inputMethodHints: Qt.ImhDigitsOnly
                        }
                    }

                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Email")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                            color: textColor
                        }

                        Maui.TextField
                        {
                            id: _emailField
                            width: parent.width
                            text: contact.email
                        }
                    }

                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Organization")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                            color: textColor
                        }

                        Maui.TextField
                        {
                            id: _orgField
                            width: parent.width
                            text: contact.org
                        }
                    }


                    //                    Column
                    //                    {
                    //                        Layout.fillWidth: true
                    //                        spacing: space.small
                    //                        Label
                    //                        {
                    //                            text: qsTr("Phone")
                    //                            font.pointSize: fontSizes.default
                    //                            font.bold: true
                    //                            font.weight: Font.Bold
                    //                        }

                    //                        Maui.TextField
                    //                        {
                    //                            width: parent.width
                    //                            text: contact.tel
                    //                            inputMethodHints: Qt.ImhDigitsOnly
                    //                        }
                    //                    }



                    //                    Column
                    //                    {
                    //                        Layout.fillWidth: true
                    //                        spacing: space.small
                    //                        Label
                    //                        {
                    //                            text: qsTr("Address")
                    //                            font.pointSize: fontSizes.default
                    //                            font.bold: true
                    //                            font.weight: Font.Bold
                    //                            color: textColor
                    //                        }

                    //                        Maui.TextField
                    //                        {
                    //                            id: _adrField
                    //                            width: parent.width
                    //                            text: contact.adr
                    //                        }
                    //                    }
                }

            }
        }
    }

    function clear()
    {
        _nameField.clear()
        _telField.clear()
        _emailField.clear()
        _orgField.clear()
        //        _adrField.clear()
        _img.source = ""
        control.close()

    }    

    Component.onCompleted:
    {
        var androidAccounts = _contacsView.list.getAccounts();
        _accountsCombobox.model = androidAccounts;
    }
}
