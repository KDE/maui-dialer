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
    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    property alias quickButtons : _buttonsRow.data
    property bool showMenuIcon: false

    signal favClicked(int index)

    property alias label1 : _label1
    property alias label2 : _label2
    property alias label3 : _label3
    property alias label4 : _label4

    property int radius : Maui.Style.radiusV * 2

    swipe.enabled: showMenuIcon

    Rectangle
    {
        id: _bg
        visible: swipe.position < 0
        Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
        Kirigami.Theme.inherit: false
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        radius: control.radius
        z: background.z -1
    }


    DropShadow
    {
        visible: _bg.visible
          anchors.fill: background
          horizontalOffset: 5
          verticalOffset: 0
          radius: 8.0
          samples: 17
          color: Qt.darker(_bg.color, 5)
          source: background
      }

    background: Rectangle
    {

        color:  hovered ? Kirigami.Theme.hoverColor : Kirigami.Theme.backgroundColor
//                border.color: Qt.rgba(_bg.color.r, _bg.color.g, _bg.color.b, swipe.position < 0)
        radius: control.radius

        RowLayout
        {
            id: _layout

            anchors.fill: parent
            anchors.margins: Maui.Style.space.small

            Item
            {
                id: _contactPic
                visible: control.width > Kirigami.Units.gridUnit * 15

                Layout.fillHeight: true
                Layout.preferredWidth: Maui.Style.iconSizes.huge
                clip: true

                Rectangle
                {
                    height: parent.height * 0.7
                    width: height
                    anchors.centerIn: parent
                    radius: control.radius
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
                                        radius: control.radius
                                    }
                                }
                            }
                        }
                    }

                    Component
                    {
                        id: _iconComponent

                        Label
                        {
                            anchors.fill: parent
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            color: "white"
                            font.pointSize: Maui.Style.fontSizes.huge
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
                        font.pointSize: Maui.Style.fontSizes.big
                        font.bold: true
                        font.weight: Font.Bold
                        elide: Text.ElideMiddle
                        color: Kirigami.Theme.textColor
                    }

                    Label
                    {
                        id: _label2
                        visible: text.length
                        Layout.fillHeight: visible
                        Layout.fillWidth: visible
                        text: model.tel
                        font.pointSize: Maui.Style.fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: Kirigami.Theme.textColor
                    }
                }
            }

            Item
            {
                visible: control.width >  Kirigami.Units.gridUnit * 30
                Layout.fillHeight: visible
                Layout.fillWidth: visible

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
                        font.pointSize: Maui.Style.fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: Kirigami.Theme.textColor
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
                        font.pointSize: Maui.Style.fontSizes.small
                        font.weight: Font.Light
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideMiddle
                        color: Kirigami.Theme.textColor
                    }
                }
            }


            Item
            {
                Layout.fillHeight: true
                Layout.preferredWidth: Maui.Style.iconSizes.big
                Layout.alignment: Qt.AlignRight
                Layout.margins: Maui.Style.space.big

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
        id: _rowActions
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: Maui.Style.space.big
        padding: Maui.Style.space.medium

        ToolButton
        {
            icon.name: "draw-star"
            anchors.verticalCenter: parent.verticalCenter
            onClicked:
            {
                control.favClicked(index)
                swipe.close()
            }

            icon.color: model.fav == "1" ? "yellow" : _bg.Kirigami.Theme.textColor
        }

        ToolButton
        {
            icon.name: "document-share"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: if(isAndroid) Maui.Android.shareContact(model.id)
            icon.color: _bg.Kirigami.Theme.textColor
        }

        ToolButton
        {
            icon.name: "message-new"
            anchors.verticalCenter: parent.verticalCenter
            icon.color: _bg.Kirigami.Theme.textColor
            onClicked:
            {
                _messageComposer.contact = list.get(index)
                _messageComposer.open()
                swipe.close()
            }
        }

        ToolButton
        {
            icon.name: "call-start"
            anchors.verticalCenter: parent.verticalCenter
            icon.color: _bg.Kirigami.Theme.textColor

            onClicked:
            {
                if(isAndroid)
                    Maui.Android.call(model.tel)
                else
                    Qt.openUrlExternally("call://" + model.tel)

                swipe.close()
            }
        }
    }
}
