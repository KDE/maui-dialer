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
                ColumnLayout
                {
                    id: _formLayout
                    width: parent.width
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
                            width: parent.width
                            height: rowHeight
                            text: contact.n
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
                            width: parent.width
                            text: contact.n.split(" ")[1]
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
                            width: parent.width
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
                            width: parent.width
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
                            width: parent.width
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
