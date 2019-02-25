import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import UnionModels 1.0

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

    BaseModel
    {
        id: _contactsModel
        list: _contactsList
    }

    ContactsList
    {
        id: _contactsList
    }

    content: ListView
    {
        id: _listView
        anchors.fill: parent
        spacing: space.big

        section.property: "n"
        section.criteria: ViewSection.FirstCharacter
        section.labelPositioning: ViewSection.InlineLabels
        section.delegate: Maui.LabelDelegate
        {
            label: section
            isSection: true
            boldLabel: true
//            colorScheme.backgroundColor: "#333"
//            colorScheme.textColor: "#fafafa"
//            width: iconSize

//            background: Rectangle
//            {
//                color:  colorScheme.backgroundColor
//                radius: radiusV

//            }


        }

        model: _contactsModel
        delegate: ContactDelegate
        {
            id: _delegate

            height: unit * 80
            width: isWide ? control.width * 0.8 : control.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter

            Connections
            {
                target: _delegate
                onClicked:
                {
                    _listView.currentIndex = index
                    _contactDialog.show(_listModel.get(index))
                }
            }
        }
    }
}
