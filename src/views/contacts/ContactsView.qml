import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui

Maui.Page
{
    id: control

    colorScheme.accentColor: "#615f7d"

//    floatingBar: true
//    footBarMargins: space.huge
//    footBarAligment: Qt.AlignRight
//    footBar.middleContent: Maui.ToolButton
//    {
//        iconName: "list-add-user"
//        iconColor: "white"
//        onClicked: _contactDialog.open()
//    }

//    footBar.colorScheme.backgroundColor: control.colorScheme.accentColor
//    footBar.colorScheme.borderColor: Qt.darker(control.colorScheme.accentColor, 1.4)

    headBarExit: false
    headBar.drawBorder: false
    headBar.leftContent: [
        Maui.ToolButton
            {
                iconName: "view-list-icons"
            }/*,
        Maui.ToolButton
            {
                iconName: "view-sort"
            }*/
    ]

    content: ListView
    {
        id: _listView
        anchors.fill: parent
        spacing: space.big

        model: ListModel
        {
            id: _listModel

            ListElement {n: "Camilo Higuita"; title: "MauiKit developer"; photo:"/home/camilo/Downloads/photo_2018-11-08_00-34-58.jpg" }
            ListElement {n: "Uri Herrera"; title: "Nitrux Founder";  }
            ListElement {n: "Anupam Basak"; title: "Nitrux developer"; photo:"/home/camilo/Downloads/photo_2018-11-08_05-57-10.jpg" }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }
            ListElement {n: "Example Contact"; title: "COntact title and description"; }

        }

        delegate: ContactDelegate
        {
            id: _delegate

            height: unit * 80
            width: isWide ? control.width * 0.8 : control.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter

            Connections
            {
                target: _delegate
                onClicked: _contactDialog.show(_listModel.get(index))
            }
        }
    }
}
