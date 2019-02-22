import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui

import "views/contacts"
//import "views/dialer"
//import "views/favs"

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Contacts")
    about.appDescription: qsTr("Union lists your contacts and keeps them synced across devices.")
    about.appIcon: "qrc:/smartphone.svg"

    property int currentView : views.contacts
    readonly property var views : ({
                                       contacts : 0,
                                       dialer: 1,
                                       recent: 2,
                                       favs: 3

                                   })


    /** UI PROPS**/
    //    altToolBars: true
    floatingBar: false
    footBarOverlap: false
    bgColor: viewBackgroundColor
    highlightColor: "#8682c1"

    leftIcon.iconColor: footBar.visible ? highlightColor : textColor
    onSearchButtonClicked: footBar.visible = !footBar.visible

    headBar.drawBorder: false
    headBarBGColor: viewBackgroundColor
    headBar.middleContent: [

        Maui.ToolButton
        {
            id: _contactsButton
            iconName: "view-media-artist"
            iconColor: currentView === views.contacts ? highlightColor : textColor
            text: qsTr("Contacts")
        },

        Maui.ToolButton
        {
            id: _dialerView
            iconName: "view-list-icons"
            iconColor: currentView === views.dialer ? highlightColor : textColor
            text: qsTr("Dialer")
            //            visible: isAndroid
        },


        Maui.ToolButton
        {
            id: _recentButton
            iconName: "view-media-recent"
            iconColor: currentView === views.favs ? highlightColor : textColor
            text: qsTr("Recent")
            //            visible: isAndroid
        },

        Maui.ToolButton
        {
            id: _favsButton
            iconName: "draw-star"
            iconColor: currentView === views.favs ? highlightColor : textColor
            text: qsTr("Favorites")
        }
    ]

    footBar.drawBorder: false
//    footBar.implicitHeight: toolBarHeight * 1.5
//    footBar.margins: space.big

    footBar.middleContent: Maui.TextField
    {
        id: _searchField
        width: footBar.middleLayout.width * 0.7
//        height: rowHeight
        placeholderText: qsTr("Search contacts... ")
    }

    footBar.leftContent:  Maui.ToolButton
    {
        iconName: "list-add-user"
        iconColor: "white"
        onClicked: _newContactDialog.open()
//        height: _searchField.height
//        width: height
//        text: qsTr("Add new...")
//        display: ToolButton.TextUnderIcon


        background: Rectangle
        {
            color: "#615f7d"
            radius: radiusV
            border.color: Qt.darker("#615f7d", 1.3)
        }
    }

    SwipeView
    {
        anchors.fill : parent
        currentIndex: currentView
        onCurrentIndexChanged:
        {
            currentView = currentIndex
        }

        ContactsView
        {
            id: _contacsView
        }
    }

    /** DIALOGS **/

    ContactDialog
    {
        id: _contactDialog
    }

    EditContactDialog
    {
        id: _newContactDialog
    }

    Maui.FileDialog
    {
        id: _fileDialog
    }
}
