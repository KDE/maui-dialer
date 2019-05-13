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
                                       favs: 0,
                                       dialer: 1,
                                       contacts : 2
                                   })


    /** UI PROPS**/
    property color cardColor: darkTheme ? "#4f5160" : Qt.darker(Maui.Style.buttonBackgroundColor, 1.05)

    bgColor: darkTheme ? "#1f2532" : Maui.Style.backgroundColor
    highlightColor: darkTheme ? "#ff6a83" : Maui.Style.highlightColor
    backgroundColor: darkTheme ? bgColor : Maui.Style.backgroundColor
    textColor: darkTheme ? "#fafafa" : Maui.Style.textColor
    viewBackgroundColor: darkTheme ? "#1e2431" : Maui.Style.viewBackgroundColor
    accentColor: darkTheme ? "#3c4862" : Maui.Style.highlightColor
    altToolBars: false

    leftIcon.iconColor: footBar.visible ? highlightColor : textColor
    //    onSearchButtonClicked: footBar.visible = !footBar.visible
    leftIcon.visible: true
    rightIcon.visible: false
    headBar.implicitHeight: toolBarHeight * 1.2
    headBar.drawBorder: false
    headBarBGColor: backgroundColor
    headBarFGColor: textColor

    property bool darkTheme : Maui.FM.loadSettings("dark", "theme", true) == "true"

    mainMenu: [
        Maui.MenuItem
        {
            checkable: true
            text: qsTr("Dark theme");
            checked: darkTheme
            onTriggered:
            {
                darkTheme = !darkTheme
                Maui.FM.saveSettings("dark", darkTheme, "theme")

                if(isAndroid)
                Maui.Android.statusbarColor(backgroundColor, !darkTheme)
            }
        }
    ]


    headBar.middleContent: [

        Maui.ToolButton
        {
            id: _favsButton
            Layout.fillWidth: isMobile
            Layout.alignment: Qt.AlignCenter
            iconName: "draw-star"
            Layout.fillHeight: true
            iconColor: currentView === views.favs ? highlightColor : textColor
            //                        text: qsTr("Favorites")
            showIndicator: currentView === views.favs
            onClicked: currentView = views.favs

        },

        Maui.ToolButton
        {
            id: _dialerButton
            Layout.fillWidth: isMobile
            Layout.alignment: Qt.AlignCenter

            iconName: "view-list-icons"
            Layout.fillHeight: true
            iconColor: currentView === views.dialer ? highlightColor : textColor
            //                        text: qsTr("Dialer")
            //            visible: isAndroid
            showIndicator: currentView === views.dialer
            onClicked: currentView = views.dialer

        },


        Maui.ToolButton
        {
            id: _contactsButton
            Layout.alignment: Qt.AlignCenter

            Layout.fillWidth: isMobile
            Layout.fillHeight: true
            iconName: "view-media-artist"
            iconColor: currentView === views.contacts ? highlightColor : textColor
            //                        text: qsTr("Contacts")
            //            height: parent.height
            showIndicator: currentView === views.contacts
            onClicked: currentView = views.contacts

        }
    ]

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
            id: _favsView
            list.query : "fav=1"
            headBar.visible: false
            gridView: true

        }

        DialerView
        {
            id: _dialerView
        }

        ContactsView
        {
            id: _contacsView
            list.query: ""

            altToolBars: isMobile
            showAccountFilter: isAndroid

            Rectangle
            {
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: toolBarHeight
                width: height

                color: highlightColor
                radius: radiusV

                Maui.ToolButton
                {
                    anchors.centerIn: parent
                    iconName: "list-add-user"
                    iconColor: "white"
                    onClicked: _newContactDialog.open()
                }
            }

            headBarExit: false
            headBar.drawBorder: false
            headBar.implicitHeight: toolBarHeight * 1.4
            headBar.plegable: false


            headBarItem: Maui.TextField
            {
                id: _searchField
                height: toolBarHeightAlt
                anchors.centerIn: parent
                width: isWide ? _contacsView.width * 0.8 : _contacsView.width * 0.95
                //        height: rowHeight
                placeholderText: qsTr("Search %1 contacts... ".arg(_contacsView.listView.count))
                onAccepted: _contacsView.list.query = text
                onCleared: _contacsView.list.reset()
                colorScheme.backgroundColor: cardColor
                colorScheme.borderColor: "transparent"
                colorScheme.textColor: textColor
                onTextEdited: _contacsView.list.query = text
                onTextChanged: _contacsView.list.query = text
            }
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
        onNewContact:
        {
            var con = contact;
            con["id"] = Math.random();
            if(contact.account)
                _contacsView.list.insert(con, contact.account)
            else
                _contacsView.list.insert(con, ({}))

            notify("list-add-user", qsTr("New contact added"), con.n)

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
            Maui.Android.statusbarColor(backgroundColor, !darkTheme)
    }
}
