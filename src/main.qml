import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3

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
    bgColor: "#1f2532"
    highlightColor: "#ff6a83"
    backgroundColor: bgColor
    textColor: "#fafafa"
    viewBackgroundColor: "#1e2431"
    accentColor: "#3c4862"
    altToolBars: false

    leftIcon.iconColor: footBar.visible ? highlightColor : textColor
    //    onSearchButtonClicked: footBar.visible = !footBar.visible
    leftIcon.visible: false
    rightIcon.visible: false
    headBar.implicitHeight: toolBarHeight * 1.5
    headBar.drawBorder: false
    headBarBGColor: backgroundColor
    headBarFGColor: textColor

    page.headBarItem: RowLayout
    {
        width: headBar.width
        height: headBar.height
//          width: footBar.middleLayout.width * 0.9
        spacing: space.large
        Item {
           Layout.fillWidth: !isMobile

        }
        Maui.ToolButton
        {
            id: _contactsButton
            Layout.fillWidth: isMobile
            iconName: "view-media-artist"
            iconColor: currentView === views.contacts ? highlightColor : textColor
//            text: qsTr("Contacts")
        }

        Maui.ToolButton
        {
            id: _dialerButton
            Layout.fillWidth: isMobile

            iconName: "view-list-icons"
            iconColor: currentView === views.dialer ? highlightColor : textColor
//            text: qsTr("Dialer")
            //            visible: isAndroid
        }


        Maui.ToolButton
        {
            id: _recentButton
            Layout.fillWidth: isMobile

            iconName: "view-media-recent"
            iconColor: currentView === views.favs ? highlightColor : textColor
//            text: qsTr("Recent")
            //            visible: isAndroid
        }

        Maui.ToolButton
        {
            id: _favsButton
            Layout.fillWidth: isMobile

            iconName: "draw-star"
            iconColor: currentView === views.favs ? highlightColor : textColor
//            text: qsTr("Favorites")
        }
        Item {
           Layout.fillWidth: !isMobile

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

        DialerView
        {
            id: _dialerView
        }
    }

    /** DIALOGS **/

    ContactDialog
    {
        id: _contactDialog

        footBar.leftContent: Maui.Button
        {
            icon.name: "user-trash"
            text: "Remove"
            onClicked:  _removeDialog.open()
        }

        Maui.Dialog
        {
            id: _removeDialog

            title: qsTr("Remove contact...")
            message: qsTr("Are you sure you want to remove this contact? This action can not be undone.")

            onRejected: close()
            onAccepted:
            {
                close()
                _contactDialog.close()
                _contacsView.list.remove(_contacsView.listView.currentIndex)

            }
        }

    }

    EditContactDialog
    {
        id: _newContactDialog
        onNewContact:
        {
            var con = contact;
            con["id"] = Math.random();
            _contacsView.list.insert(con)
        }
    }

    Maui.FileDialog
    {
        id: _fileDialog
    }

    Component.onCompleted:
    {
        if(isAndroid)
             Maui.Android.statusbarColor(backgroundColor, false)
    }
}
