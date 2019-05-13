import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    hoverEnabled: true
    clip: true

    property bool showMenuIcon: false

    signal favClicked(int index)


    background: Rectangle
    {
//                radius: radiusV * 2
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
    }

    Maui.ToolButton
    {
        anchors
        {
            top: parent.top
            right: parent.right
            margins: space.medium
        }

        iconColor: "#fff"
        visible: showMenuIcon
        iconName: "overflow-menu"
        onClicked: swipe.position < 0 ? swipe.close() : swipe.open(SwipeDelegate.Right)

    }

    ColumnLayout
    {
        id: _layout
        anchors.fill : parent
        anchors.margins: space.medium
        Item
            {
                id: _contactPic

                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true




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
                            anchors.centerIn: parent
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter

                            color: "#fff"
                            font.pointSize: parent.width * 0.2
                            font.bold: true
                            font.weight: Font.Bold
                            text: model.n[0].toUpperCase()
                        }
                    }


            }
        Item
        {
            id: _contactInfo

//            Layout.fillHeight: true
            Layout.maximumHeight: parent.height * 0.4
            Layout.minimumHeight: parent.height * 0.1
            Layout.margins: space.big
            Layout.fillWidth: true
            clip: true

            ColumnLayout
            {
                anchors.fill: parent

                Label
                {
                    visible: (model.n && model.n.length)
                    Layout.fillHeight: visible
                    Layout.fillWidth: visible
                    Layout.alignment: Qt.AlignVCenter

                    text: model.n
                    font.pointSize: fontSizes.big
                    font.bold: true
                    font.weight: Font.Bold
                    elide: Text.ElideMiddle
                    color: "#fff"
                }

                Label
                {
                    visible: (model.tel && model.tel.length)
                    Layout.fillHeight: visible
                    Layout.fillWidth: visible
                    Layout.alignment: Qt.AlignVCenter
                    text: model.tel
                    font.pointSize: fontSizes.small
                    font.weight: Font.Light
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideMiddle
                    color: "#fff"
                }

                Label
                {
                    visible: (model.email && model.email.length)
                    Layout.fillHeight: visible
                    Layout.fillWidth: visible
                    Layout.alignment: Qt.AlignVCenter

                    text: model.email
                    font.pointSize: fontSizes.small
                    font.weight: Font.Light
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideMiddle
                    color: "#fff"
                }
            }
        }


    }

}
