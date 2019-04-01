import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import QtQuick.Layouts 1.3

import "views/contacts"
import "views/dialer"
import "widgets"
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
    headBar.implicitHeight: toolBarHeight * 1.2
    headBar.drawBorder: false
    headBarBGColor: backgroundColor
    headBarFGColor: textColor

    page.headBarItem: RowLayout
    {
        width: headBar.width
        height: headBar.height
        //          width: footBar.middleLayout.width * 0.9
        spacing: space.large

        Item
        {
            Layout.fillWidth: !isMobile
        }

        Maui.ToolButton
        {
            id: _contactsButton
            Layout.fillWidth: isMobile
            Layout.fillHeight: true
            iconName: "view-media-artist"
            iconColor: currentView === views.contacts ? highlightColor : textColor
            //            text: qsTr("Contacts")
            //            height: parent.height
            showIndicator: currentView === views.contacts
            onClicked: currentView = views.contacts

        }

        Maui.ToolButton
        {
            id: _dialerButton
            Layout.fillWidth: isMobile

            iconName: "view-list-icons"
            Layout.fillHeight: true
            iconColor: currentView === views.dialer ? highlightColor : textColor
            //            text: qsTr("Dialer")
            //            visible: isAndroid
            showIndicator: currentView === views.dialer
            onClicked: currentView = views.dialer

        }


        Maui.ToolButton
        {
            id: _recentButton
            Layout.fillWidth: isMobile

            iconName: "view-media-recent"
            Layout.fillHeight: true
            iconColor: currentView === views.recent ? highlightColor : textColor
            //            text: qsTr("Recent")
            //            visible: isAndroid
            showIndicator: currentView === views.recent

        }

        Maui.ToolButton
        {
            id: _favsButton
            Layout.fillWidth: isMobile

            iconName: "draw-star"
            Layout.fillHeight: true
            iconColor: currentView === views.favs ? highlightColor : textColor
            //            text: qsTr("Favorites")
            showIndicator: currentView === views.favs

        }

        Item
        {
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
            if(currentView === views.contacts)
                _contacsView.list.query = ""
            else if(currentView === views.dialer)
                _contacsView.list.query = _dialerView.dialString
        }

        ContactsView
        {
            id: _contacsView
            list.query: ""
        }

        DialerView
        {
            id: _dialerView
        }

        ContactsView
        {
            id: _favsView
            list.query : "fav=1"

            //            listView.model: KPeople.PersonsModel {
            //                                id: contactsModel
            //                            }

            //            listView.delegate: Rectangle
            //            {
            //                color: "pink"
            //                height: 60
            //                width : 120
            //            }

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
            colorScheme.backgroundColor: dangerColor
            colorScheme.textColor: "#fff"
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
            if(contact.account)
                _contacsView.list.insert(con, contact.account)
            else
                _contacsView.list.insert(con)

        }
    }

    MessageComposer
    {
        id: _messageComposer
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
