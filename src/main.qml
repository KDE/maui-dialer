import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui

import "views/contacts"
import "views/dialer"
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

    bgColor: viewBackgroundColor
    highlightColor: "#ff6a83"

    leftIcon.iconColor: footBar.visible ? highlightColor : textColor
    onSearchButtonClicked: footBar.visible = !footBar.visible

    headBar.implicitHeight: toolBarHeight * 1.5
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
            id: _dialerButton
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

        DialerView
        {
            id: _dialerView
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
