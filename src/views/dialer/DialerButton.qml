import QtQuick 2.0
import QtQuick.Controls 2.3
import org.kde.kirigami 2.7 as Kirigami

Button
{
    id: control
    //                bg.radius: Math.max(width, height)
    font.bold: true
    font.weight: Font.Bold
    font.pointSize: buttonFontSize
    onClicked:
    {
        dialString += text;
    }

    contentItem: Label
        {
            id: _text
            anchors.fill: parent
            visible: text
            text: control.text
            font: control.font
            color: !control.enabled ? Kirigami.Theme.disabledTextColor :
                                      control.highlighted || control.down ? Kirigami.Theme.highlightedTextColor : Kirigami.Theme.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

    background: Rectangle
    {
        radius: Math.max(parent.height, parent.width)
        color: !control.enabled ? Kirigami.Theme.backgroundColor :
                                  control.highlighted || control.down ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
        border.color: Qt.tint(Kirigami.Theme.textColor, Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7))

    }
}
