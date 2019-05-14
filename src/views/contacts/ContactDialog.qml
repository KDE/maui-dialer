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
    rejectButton.visible: false
    acceptButton.visible: false


    footBar.implicitHeight: toolBarHeight * 1.3
    footBar.rightContent:  Maui.Button
    {
        visible: isMobile
//                Layout.fillHeight: visible
        //                    Layout.fillWidth: visible
        icon.name: "phone"
        text: qsTr("Call")
        //        display: ToolButton.TextUnderIcon
        colorScheme.backgroundColor: infoColor
        colorScheme.textColor: "#fff"
        onClicked:
        {
            if(isAndroid)
                Maui.Android.call(contact.tel)
        }
    }

    footBar.leftContent:  Maui.Button
    {
        visible: isMobile
//                Layout.fillHeight: visible
        //                    Layout.fillWidth: visible
        text: qsTr("Close")
        //        display: ToolButton.TextUnderIcon
        colorScheme.backgroundColor: warningColor
        colorScheme.textColor: "#fff"
        onClicked: control.close()
    }


    footBar.middleContent: Maui.ToolButton
    {
                    Layout.fillHeight: true
        Layout.fillWidth: true
        iconName: "draw-text"
        //            text: qsTr("Message")
        display: ToolButton.TextUnderIcon
        onClicked:
        {
            _messageComposer.contact = control.contact
            _messageComposer.open()
        }

    }



    headBar.drawBorder: false
    headBar.rightContent: Maui.Button
    {
        icon.name: "document-edit"
        onClicked: _editContactDialog.open()
        colorScheme.backgroundColor: suggestedColor
        colorScheme.textColor: "#fff"
    }
    headBar.middleContent: [

        Maui.ToolButton
        {
                        Layout.fillHeight: true
//            Layout.fillWidth: true
            iconName: "draw-star"
            //            text: qsTr("Fav")
            display: ToolButton.TextUnderIcon
            iconColor: contact.fav == "1" ? "yellow" : textColor
            onClicked:
            {
                contact["fav"] = contact.fav == "1" ? "0" : "1"
                _contacsView.list.update(contact,  _contacsView.listView.currentIndex)
                control.contact = contact;
                _favsView.list.refresh()
            }
        },

        Maui.ToolButton
        {
                        Layout.fillHeight: true
//            Layout.fillWidth: true
            iconName: "document-share"
            //            text: qsTr("Share")
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
            _contacsView.list.update(con, _contacsView.listView.currentIndex)
            control.contact =  _contacsView.list.get(_contacsView.listView.currentIndex)

            _editContactDialog.close()

        }

        headBar.drawBorder: false
        headBar.rightContent:  Maui.Button
        {
            icon.name: "user-trash"
            //            text: qsTr("Remove")
            onClicked:  _removeDialog.open()
            colorScheme.backgroundColor: dangerColor
            colorScheme.textColor: "#fff"
        }

        Maui.Dialog
        {
            id: _removeDialog

            title: qsTr("Remove contact...")
            message: qsTr("Are you sure you want to remove this contact? This action can not be undone.")

            onRejected: close()
            onAccepted:
            {
                close()
                _contactDialog.close()
                _contacsView.list.remove(_contacsView.listView.currentIndex)

            }
        }
    }

    ColumnLayout
    {
        id: _layout
        height: parent.height * 0.7
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
                                    radius: radiusV* 2
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
                        visible: contact.n
                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: qsTr("Account")
                            font.pointSize: fontSizes.default
                            font.weight: Font.Light
                            color: textColor
                        }

                        Label
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            width: parent.width
                            text: contact.account
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                            wrapMode: Text.WrapAnywhere
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        visible: contact.n
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
                            text: contact.n
                            font.pointSize: fontSizes.big
                            font.weight: Font.Bold
                            color: textColor
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        visible: contact.tel

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
                        visible: contact.email

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


                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        spacing: space.small
                        visible: contact.org && contact.org.length

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
                        visible: contact.title

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
