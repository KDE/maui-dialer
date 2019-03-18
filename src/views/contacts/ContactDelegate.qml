import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami


SwipeDelegate
{
    id: control
    hoverEnabled: true
    clip: true
    property alias quickButtons : _buttonsRow.data

    background: Rectangle
    {
        color:  hovered ? Qt.lighter("#4f5160") : "#4f5160"
        //        border.color: borderColor
        radius: radiusV * 2

        //        anchors.fill: control

        RowLayout
        {
            id: _layout

            anchors.fill: parent
            anchors.margins: space.big

            Item
            {
                id: _contactPic
                visible: control.width >  Kirigami.Units.gridUnit * 15

                Layout.fillHeight: true
                Layout.preferredWidth: iconSizes.huge
                clip: true

                Rectangle
                {
                    height: parent.height
                    width: height
                    anchors.centerIn: parent
                    radius: radiusV * 2
                    color: Qt.rgba(Math.random(),Math.random(),Math.random(),1);
                    border.color: Qt.darker(color, 1.5)


                    Loader
                    {
                        id: _contactPicLoader
                        anchors.fill: parent
                        sourceComponent: model.photo ? _imgComponent : _iconComponent
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

                            source: /*"file://"+ */model.photo

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
                                        radius: radiusV * 2
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
                            font.pointSize: fontSizes.huge
                            font.bold: true
                            font.weight: Font.Bold
                            text: model.n[0]
                        }
                    }

                }
            }

            Item
            {
                id: _contactInfo

                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true

                ColumnLayout
                {
                    anchors.fill: parent

                    Label
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: model.n
                        font.pointSize: fontSizes.big
                        font.bold: true
                        font.weight: Font.Bold
                        elide: Text.ElideMiddle
                        color: textColor
                    }

                    Label
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        text: model.tel
                        font.pointSize: fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: textColor
                    }
                }
            }

            Item
            {
                visible: control.width >  Kirigami.Units.gridUnit * 20
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true

                ColumnLayout
                {
                    anchors.fill: parent

                    Label
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignRight
                        horizontalAlignment: Qt.AlignRight

                        text: model.email
                        font.pointSize: fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: textColor
                    }

                    Label
                    {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignRight
                        horizontalAlignment: Qt.AlignRight
                        text: model.title
                        font.pointSize: fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: textColor
                    }
                }
            }


            Item
            {
                Layout.fillHeight: true
                Layout.preferredWidth: iconSizes.big
                Layout.alignment: Qt.AlignRight
                Layout.margins: space.big

                Row
                {
                    id: _buttonsRow
                    anchors.centerIn: parent
                    Maui.ToolButton
                    {

                        iconName: "overflow-menu"
                        onClicked: swipe.position < 0 ? swipe.close() : swipe.open(SwipeDelegate.Right)

                    }
                }


            }
        }
    }

    swipe.right: Row
    {
        padding: space.medium
        height: control.height
        anchors.right: parent.right
        spacing: space.big

        Maui.ToolButton
        {
            iconName: "draw-star"
            anchors.verticalCenter: parent.verticalCenter

        }

        Maui.ToolButton
        {
            iconName: "document-share"
            anchors.verticalCenter: parent.verticalCenter

        }

        Maui.ToolButton
        {
            iconName: "draw-text"
            anchors.verticalCenter: parent.verticalCenter

        }

        Maui.ToolButton
        {
            iconName: "phone"
            anchors.verticalCenter: parent.verticalCenter

            onClicked:
            {
                if(isAndroid)
                    Maui.Android.call(contact.tel)

                swipe.close()
            }
        }
    }
}
