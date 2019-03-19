import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import UnionModels 1.0

Maui.Page
{
    id: control

    colorScheme.accentColor: "#615f7d"
    colorScheme.backgroundColor: backgroundColor
    colorScheme.textColor: textColor

    property alias list : _contactsList
    property alias listModel : _contactsModel
    property alias listView : _listView

    altToolBars: isMobile
    floatingBar: true
    footBarMargins: space.huge
    footBarAligment: Qt.AlignRight
    footBar.middleContent: Maui.ToolButton
    {
        iconName: "list-add-user"
        iconColor: "white"
        onClicked: _newContactDialog.open()
    }

    footBar.colorScheme.borderColor: "transparent"
    headBarExit: false
    headBar.drawBorder: false
    footBar.drawBorder: false
    footBar.floating: false
    footBar.colorScheme.backgroundColor: highlightColor
    //    footBar.implicitHeight: toolBarHeight * 1.5

    //    footBar.leftContent: [
    //        Maui.ToolButton
    //        {
    //            iconName: "list-add-user"
    //            onClicked: _newContactDialog.open()
    ////            text: qsTr("New")
    //            display: ToolButton.TextUnderIcon
    //        }
    //    ]

    //    footBar.rightContent: [

    //        Maui.ToolButton
    //        {
    //            iconName: "view-sort"
    ////            text: qsTr("Sort")
    //            display: ToolButton.TextUnderIcon
    //        }
    //    ]

    headBar.implicitHeight: toolBarHeight * 1.4
    headBar.plegable: false
    headBarItem: Maui.TextField
    {
        id: _searchField
        height: toolBarHeightAlt
        anchors.centerIn: parent
        width: isWide ? control.width * 0.8 : control.width * 0.95
        //        height: rowHeight
        placeholderText: qsTr("Search contacts... ")
        onAccepted: list.query = text
        onCleared: list.reset()
        colorScheme.backgroundColor: "#4f5160"
        colorScheme.borderColor: "transparent"
        colorScheme.textColor: "#fff"
    }

    BaseModel
    {
        id: _contactsModel
        list: _contactsList
    }

    ContactsList
    {
        id: _contactsList

    }

    Maui.Holder
    {
        id: _holder
        emoji: "qrc:/Circuit.svg"
        isMask: false
        title: qsTr("There's not contacts")
        body: qsTr("Add new contacts")
        emojiSize: iconSizes.huge
        visible: !listView.count
        onActionTriggered: _newContactDialog.open()

    }


    ListView
    {
        id: _listView
        anchors.fill: parent
        spacing: space.big

        section.property: "n"
        section.criteria: ViewSection.FirstCharacter
        section.labelPositioning: ViewSection.InlineLabels
        section.delegate: Maui.LabelDelegate
        {
            label: section.toUpperCase()
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
            showMenuIcon: true

            Connections
            {
                target: _delegate
                onClicked:
                {
                    _listView.currentIndex = index
                    _contactDialog.show(list.get(index))
                }
                onFavClicked:
                {
                    var item = _contactsList.get(index)
                    item["fav"] = item.fav == "1" ? "0" : "1"
                    _contactsList.update(item, index)
                }
            }
        }
    }
}
