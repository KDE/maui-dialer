import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami

Maui.Dialog
{
    id: control

    maxWidth: unit * 500
    maxHeight: unit * 800

    property var contact : ({})
    acceptButton.text: qsTr("Edit")
    rejectButton.visible: false
    onAccepted: _editContactDialog.open()

    headBar.implicitHeight: toolBarHeight * 1.3
    headBar.middleContent: [
        Maui.ToolButton
        {
            iconName: "phone"
            text: qsTr("Call...")
            display: ToolButton.TextUnderIcon
            onClicked:
            {
                if(isAndroid)
                Maui.Android.call(contact.tel)
            }
        },

        Maui.ToolButton
        {
            iconName: "draw-text"
            text: qsTr("Message...")
            display: ToolButton.TextUnderIcon
        },

        Maui.ToolButton
        {
            iconName: "draw-star"
            text: qsTr("Fav...")
            display: ToolButton.TextUnderIcon
        },

        Maui.ToolButton
        {
            iconName: "document-share"
            text: qsTr("Share...")
            display: ToolButton.TextUnderIcon
        }
    ]

    EditContactDialog
    {
        id: _editContactDialog
        contact: control.contact
        onNewContact:
        {
            var con = contact
            var id = control.contact.id
            con["id"] = id
            console.log("trying to edit contact", id)
            if(_contacsView.list.update(con, _contacsView.listView.currentIndex))
                control.contact =  _contacsView.list.get(_contacsView.listView.currentIndex)

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


                Loader
                {
                    id: _contactPicLoader
                    anchors.fill: parent
                    sourceComponent: contact.photo ? _imgComponent : _iconComponent
                }

                Component
                {
                    id: _imgComponent

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

                        source: contact.photo

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
                }

                Component
                {
                    id: _iconComponent

                    //                    Maui.ToolButton
                    //                    {
                    //                        iconName: "view-media-artist"
                    //                        size: iconSizes.big
                    //                        iconColor: "white"
                    //                    }

                    Label
                    {
                        anchors.fill: parent
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter

                        color: "white"
                        font.pointSize: fontSizes.huge * 1.5
                        font.bold: true
                        font.weight: Font.Bold
                        text: contact.n[0]
                    }
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
                contentWidth: _formLayout.width
                clip: true
                ColumnLayout
                {
                    id: _formLayout
                    width: parent.width
                    spacing: space.large

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Name")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            width: parent.width
                            text: contact.n.split(" ")[0]
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                        }
                    }


                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Last name")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: contact.n.split(" ")[1] ? contact.n.split(" ")[1] : ""
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Organization")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            width: parent.width
                            text: contact.org
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Title")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            width: parent.width
                            text: contact.title
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                        }
                    }


                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Mobile phone")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                            text: contact.tel

                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Phone")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                            text: contact.tel
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Email")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor

                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                            text: contact.email
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
