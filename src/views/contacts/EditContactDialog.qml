import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami

import FMList 1.0

Maui.Dialog
{
    id: control

    maxWidth: unit * 500
    maxHeight: parent.height

    property var contact : ({})
    acceptButton.text: qsTr("Save")
    rejectButton.visible: false

    signal newContact(var contact)

    onAccepted:
    {
        var contact =({
                          n: _nameField.text +" "+ _lastNameField.text,
                          tel: _telField.text,
                          email: _emailField.text,
                          org: _orgField.text,
                          adr: _adrField.text,
                          gender: _genderField.currentText,
                          photo: _img.source
                      })
        newContact(contact)
        control.close()
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
                        _fileDialog.filterType= FMList.IMAGE
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

                Maui.ToolButton
                {
                    iconName: "list-add"
                    iconColor: "white"
                    enabled: false
                    size: iconSizes.big
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
                        Label
                        {
                            text: qsTr("Name")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                        }

                        Maui.TextField
                        {
                            id: _nameField
                            width: parent.width
                            text: contact.n.split(" ")[0]
                        }
                    }


                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Last name")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                        }

                        Maui.TextField
                        {
                            id: _lastNameField
                            width: parent.width
                            text: contact.n.split(" ")[1] ? contact.n.split(" ")[1] : ""
                        }
                    }

                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Genre")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                        }

                        ComboBox
                        {
                            id: _genderField
                            width: parent.width
                            model: ["Male", "Female", "Other"]
                            popup.z: control.z+1
                            //                            currentText: contact.gender
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
                        }

                        Maui.TextField
                        {
                            id: _orgField
                            width: parent.width
                            text: contact.org
                        }
                    }


                    Column
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            text: qsTr("Mobile phone")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                        }

                        Maui.TextField
                        {
                            id: _telField
                            width: parent.width
                            text: contact.tel
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
                        }

                        Maui.TextField
                        {
                            width: parent.width
                            text: contact.tel
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
                            text: qsTr("Address")
                            font.pointSize: fontSizes.default
                            font.bold: true
                            font.weight: Font.Bold
                        }

                        Maui.TextField
                        {
                            id: _adrField
                            width: parent.width
                            text: contact.adr
                        }
                    }
                }

            }
        }
    }


    function show(data)
    {
        control.contact = data
        control.open()
    }
}
