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
    property bool showMenuIcon: false

    signal favClicked(int index)

    property alias label1 : _label1
    property alias label2 : _label2
    property alias label3 : _label3
    property alias label4 : _label4

    swipe.enabled: showMenuIcon
    background: Rectangle
    {
        color:  hovered ? Qt.lighter(cardColor) : cardColor
        //        border.color: borderColor
        radius: radiusV * 2

        //        anchors.fill: control

        RowLayout
        {
            id: _layout

            anchors.fill: parent
            anchors.margins: space.small

            Item
            {
                id: _contactPic
                visible: control.width >  Kirigami.Units.gridUnit * 15

                Layout.fillHeight: true
                Layout.preferredWidth: iconSizes.huge
                clip: true

                Rectangle
                {
                    height: parent.height * 0.7
                    width: height
                    anchors.centerIn: parent
                    radius: radiusV * 2
                    color:
                    {
                        var c = Qt.rgba(Math.random(),Math.random(),Math.random(),1)
                        return Qt.hsla(c.hslHue, 0.7, c.hslLightness, c.a);
                    }

                    //                    color: Qt.hsl(Math.random(),Math.random(),Math.random(),1);
                    //                    color: "hsl(" + 360 * Math.random() + ',' +
                    //                           (25 + 70 * Math.random()) + '%,' +
                    //                           (85 + 10 * Math.random()) + '%)';
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

                            source:  "image://contact/"+ model.id

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

                        //                    ToolButton
                        //                    {
                        //                        icon.name: "view-media-artist"
                        //                        size: iconSizes.big
                        //                        icon.color: "white"
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
                            text: model.n[0].toUpperCase()
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
                        id: _label1
                        visible: text.length
                        Layout.fillHeight: visible
                        Layout.fillWidth: visible
                        text: model.n
                        font.pointSize: fontSizes.big
                        font.bold: true
                        font.weight: Font.Bold
                        elide: Text.ElideMiddle
                        color: textColor
                    }

                    Label
                    {
                        id: _label2
                        visible: text.length
                        Layout.fillHeight: visible
                        Layout.fillWidth: visible
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
                visible: control.width >  Kirigami.Units.gridUnit * 30
                Layout.fillHeight: visible
                Layout.fillWidth: visible
                clip: true

                ColumnLayout
                {
                    anchors.fill: parent

                    Label
                    {
                        id: _label3
                        visible: text.length
                        Layout.fillHeight: visible
                        Layout.fillWidth: visible
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
                        id: _label4
                        visible: text.length
                        Layout.fillHeight: visible
                        Layout.fillWidth: visible
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
                    ToolButton
                    {
                        visible: showMenuIcon
                        icon.name: "overflow-menu"
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

        ToolButton
        {
            icon.name: "draw-star"
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                control.favClicked(index)
                swipe.close()
            }

            icon.color: model.fav == "1" ? "yellow" : textColor
        }

        ToolButton
        {
            icon.name: "document-share"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: if(isAndroid) Maui.Android.shareContact(model.id)
        }

        ToolButton
        {
            icon.name: "draw-text"
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                _messageComposer.contact = list.get(index)
                _messageComposer.open()
                swipe.close()
            }
        }

        ToolButton
        {
            icon.name: "phone"
            anchors.verticalCenter: parent.verticalCenter

            onClicked:
            {
                if(isAndroid)
                    Maui.Android.call(model.tel)

                swipe.close()
            }
        }
    }
}
