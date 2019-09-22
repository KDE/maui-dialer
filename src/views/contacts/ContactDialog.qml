import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.7 as Kirigami

Maui.Dialog
{
    id: control

    maxWidth: Maui.Style.unit * 500
    maxHeight: Maui.Style.unit * 800

    property var contact : ({})
    rejectButton.visible: true
    rejectButton.text: qsTr("Close")
    onRejected: control.close()

    acceptButton.visible: isMobile
    acceptButton.text: qsTr("Call")
    acceptButton.icon.name: "call-start"
    onAccepted:
    {
        if(isAndroid)
            Maui.Android.call(contact.tel)
        else
            Qt.openUrlExternally("call://" + contact.tel)

    }

    headBar.middleContent: Kirigami.ActionToolBar
    {
        Layout.fillWidth: true

        actions: [

            Kirigami.Action
            {
                icon.name: "mail-message"
                visible: contact.email
                text: qsTr("Email")
                //            display: ToolButton.TextUnderIcon
                onTriggered:
                {
                    _messageComposer.contact = control.contact
                    _messageComposer.open()
                }

            },

            Kirigami.Action
            {
                icon.name: "dialog-messages"
                visible: contact.tel

                text: qsTr("SMS")
                //            display: ToolButton.TextUnderIcon
                onTriggered:
                {
                    _messageComposer.contact = control.contact
                    _messageComposer.open()
                }
            },

            Kirigami.Action
            {
                //                        Layout.fillWidth: true
                //            Layout.fillHeight: true

                icon.name: "draw-star"
                text: qsTr("Fav")
                checked: contact.fav == "1"
                checkable: false
                Kirigami.Theme.textColor: checked ? "#FFD700" : Kirigami.Theme.textColor
                Kirigami.Theme.backgroundColor: checked ? "#FFD700" : Kirigami.Theme.textColor
                onTriggered:
                {
                    contact["fav"] = contact.fav == "1" ? "0" : "1"
                    list.update(contact,  view.currentIndex)
                    control.contact = contact;
                    _favsView.list.refresh()
                }
            },

            Kirigami.Action
            {
                //                        Layout.fillWidth: true
                //            Layout.fillHeight: true
                icon.name: "document-share"
                text: qsTr("Share")
            },

            Kirigami.Action
            {
                //            Layout.fillWidth: true
                //            Layout.fillHeight: true

                icon.name: "document-edit"
                text: qsTr("Edit")
                onTriggered: _editContactDialog.open()
                icon.color: suggestedColor
            }
        ]

        hiddenActions:[
            Kirigami.Action
            {
                text: qsTr("Delete...")
                icon.name: "user-trash"
                Kirigami.Theme.textColor: warningColor
                onTriggered: _removeDialog.open()
            }
        ]
    }

    Maui.Dialog
    {
        id: _removeDialog

        title: qsTr("Remove contact...")
        message: qsTr("Are you sure you want to remove this contact? This action can not be undone.")

        acceptButton.text: qsTr("Cancel")
        rejectButton.text: qsTr("Remove")
        onAccepted: close()
        onRejected:
        {
            close()
            _contactDialog.close()

            list.remove(view.currentIndex)

        }
    }

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
            list.update(con, view.currentIndex)
            control.contact =  list.get(view.currentIndex)
            _editContactDialog.close()
        }

        headBar.drawBorder: false
        headBar.rightContent:  Button
        {
            icon.name: "user-trash"
            //            text: qsTr("Remove")
            onClicked:  _removeDialog.open()
            Kirigami.Theme.backgroundColor: dangerColor
            Kirigami.Theme.textColor: "#fff"
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
            Layout.preferredHeight: Maui.Style.iconSizes.huge * (contact.photo ? 1.5 : 1)

            Rectangle
            {
                height: Math.min(parent.height, control.width)
                width: height
                anchors.centerIn: parent
                radius: radiusV* 2
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

                        source: "image://contact/"+ contact.id

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
                                    radius: Maui.Style.radiusV* 2
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
                        font.pointSize: Maui.Style.fontSizes.huge * 1.5
                        font.bold: true
                        font.weight: Font.Bold
                        text: contact.n ? contact.n[0] : "?"
                    }
                }

            }
        }

        //        Item
        //        {
        //            Layout.fillWidth: true
        //            Layout.preferredHeight: toolBarHeight

        //           Maui.Button
        //           {
        //               anchors.centerIn: parent
        //               icon.name: "document-edit"
        //               text: qsTr("Edit")
        //               onClicked: _editContactDialog.open()
        //               colorScheme.backgroundColor: suggestedColor
        //               colorScheme.textColor: "#fff"
        //           }

        //        }


            Kirigami.ScrollablePage
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Kirigami.Theme.backgroundColor: "transparent"
                padding: 0
                leftPadding: padding
                rightPadding: padding
                topPadding: padding
                bottomPadding: padding

                ColumnLayout
                {
                    id: _formLayout
                    width: parent.width
                    spacing: Maui.Style.space.large

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: Maui.Style.space.small
                        visible: contact.account
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Account")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            width: parent.width
                            text: contact.account
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                            wrapMode: Text.WrapAnywhere
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: Maui.Style.space.small
                        visible: contact.n
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Name")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            width: parent.width
                            text: contact.n
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: Maui.Style.space.small
                        visible: contact.tel

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Phone")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                            text: contact.tel

                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: Maui.Style.space.small
                        visible: contact.email

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Email")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor

                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                            text: contact.email
                        }
                    }


                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: Maui.Style.space.small
                        visible: contact.org && contact.org.length

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Organization")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            width: parent.width
                            text: contact.org
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                        }
                    }

                    ColumnLayout
                    {
                        visible: contact.title && contact.title.length
                        Layout.fillWidth: visible
                        spacing: Maui.Style.space.small

                        Label
                        {
                            Layout.fillHeight: parent.visible
                            Layout.fillWidth: parent.visible
                            text: qsTr("Title")
                            font.pointSize: Maui.Style.fontSizes.default
                            font.weight: Font.Light
                            color: Kirigami.Theme.textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            width: parent.width
                            text: parent.visible ? contact.title : undefined
                            font.pointSize: Maui.Style.fontSizes.big
                            font.weight: Font.Bold
                            color: Kirigami.Theme.textColor
                        }
                    }
                }
            }

    }


    function show(data)
    {
        control.contact = data
        console.log("curent itemn account", data.account, data.type)
        control.open()
    }
}
