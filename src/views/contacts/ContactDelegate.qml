import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami


ItemDelegate
{
    id: control
    hoverEnabled: true

    background: Rectangle
    {
        color: backgroundColor
        opacity: hovered ?  1  : 0.75
//        border.color: borderColor
        radius: radiusV * 2
    }

    RowLayout
    {
        id: _layout

        anchors.fill: parent
        anchors.margins: space.big

        Item
        {
            id: _contactPic
            Layout.fillHeight: true
            Layout.preferredWidth: iconSizes.huge

            Rectangle
            {
                height: parent.height
                width: height
                anchors.centerIn: parent
                radius: Math.min(width, height)
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

                        source: "file://"+ model.photo

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
                }

                Label
                {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: model.title
                    font.pointSize: fontSizes.small
                    font.weight: Font.Light
                }
            }
        }

        Item
        {
            Layout.fillHeight: true
            Layout.preferredWidth: iconSizes.medium
            Layout.alignment: Qt.AlignRight

            Maui.ToolButton
            {
                anchors.centerIn: parent
                iconName: "overflow-menu"
            }
        }
    }


}
