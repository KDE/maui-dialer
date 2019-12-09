import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.6 as Kirigami
//import org.mauikit.accounts 1.0 as Accounts
import QtQuick.Layouts 1.3

import "views/contacts"
import "views/dialer"
import "views/logs"
import "widgets"
//import "views/favs"

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Contacts")
    Maui.App.description: qsTr("Union lists your contacts and keeps them synced across devices.")
    Maui.App.iconName: "qrc:/smartphone.svg"

    property int currentView : views.favs
    readonly property var views : ({
                                       favs: 0,
                                       log:  1,
                                       contacts : 2,
                                       dialer: 3,
                                   })


    /** UI PROPS**/
    property color cardColor: darkTheme ? "#4f5160" : Qt.darker(Maui.Style.buttonBackgroundColor, 1.05)

    //    bgColor: darkTheme ? "#1f2532" : Maui.Style.backgroundColor
    //    highlightColor: darkTheme ? "#ff6a83" : Maui.Style.highlightColor
    //    backgroundColor: darkTheme ? bgColor : Maui.Style.backgroundColor
    //    textColor: darkTheme ? "#fafafa" : Maui.Style.textColor
    //    viewBackgroundColor: darkTheme ? "#1e2431" : Maui.Style.viewBackgroundColor
    //    accentColor: darkTheme ? "#3c4862" : Maui.Style.highlightColor

    leftIcon.checked: footBar.visible
    //    onSearchButtonClicked: footBar.visible = !footBar.visible
    leftIcon.visible: true
    rightIcon.visible: false
    //    headBar.implicitHeight: toolBarHeight * 1.2
    //    headBarBGColor: backgroundColor
    //    headBarFGColor: textColor

    property bool darkTheme : Maui.FM.loadSettings("dark", "theme", false) == "true"

    mainMenu: [
        MenuItem
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

    headBar.rightContent:  ToolButton
    {
        id: _dialerButton
        icon.name: "call-start"
        checked: currentView === views.dialer
        onClicked: currentView = views.dialer
    }

    headBar.middleContent: Maui.ActionGroup
    {
        id: _actionGroup
        Layout.fillHeight: true
        //        Layout.fillWidth: true
        Layout.minimumWidth: implicitWidth
        currentIndex : swipeView.currentIndex
        onCurrentIndexChanged: swipeView.currentIndex = currentIndex

        Action
        {
            id: _favsButton
            icon.name: "draw-star"
            text: qsTr("Favorites")
        }

        Action
        {
            id: _logButton
            icon.name: "view-media-recent"
            text: qsTr("Recent")
        }

        Action
        {
            icon.name: "view-pim-contacts"
            text: qsTr("Contacts")
        }
        
    }

    SwipeView
    {
        id: swipeView
        anchors.fill : parent
        currentIndex: _actionGroup.currentIndex
        onCurrentIndexChanged:
        {
            _actionGroup.currentIndex = currentIndex
            if(currentIndex === views.contacts)
                _contacsView.list.query = ""
            else if(currentIndex === views.dialer)
                _contacsView.list.query = _dialerView.dialString
        }

        ContactsView
        {
            id: _favsView
            list.query : "fav=1"
            headBar.visible: false
            gridView: true
        }

        LogsView
        {
            id: _logView
        }

        ContactsView
        {
            id: _contacsView
            list.query: ""
            showAccountFilter: isAndroid

            Rectangle
            {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: Maui.Style.space.huge
                height: Maui.Style.toolBarHeight
                width: height

                color: Kirigami.Theme.highlightColor
                radius: Math.max(width, height)

                ToolButton
                {
                    anchors.centerIn: parent
                    icon.name: "list-add-user"
                    icon.color: "white"
                    flat: true
                    onClicked: _newContactDialog.open()
                }
            }

            headBar.middleContent: Maui.TextField
            {
                id: _searchField
                Layout.preferredWidth: isWide ? _contacsView.width * 0.8 : _contacsView.view.width
                focusReason : Qt.PopupFocusReason
                placeholderText: qsTr("Search %1 contacts... ".arg(_contacsView.view.count))
                onAccepted: _contacsView.list.query = text
                onCleared: _contacsView.list.reset()
                onTextEdited: _contacsView.list.query = text
                onTextChanged: _contacsView.list.query = text
            }
        }

        DialerView
        {
            id: _dialerView
        }
    }


    /** DIALOGS **/


    EditContactDialog
    {
        id: _newContactDialog
        onNewContact:
        {
            _contacsView.list.insert(contact)
            notify("list-add-user", qsTr("New contact added"), contact.n)
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
        if(_favsView.view.count < 1)
            currentView = views.contacts
        if(isAndroid)
            Maui.Android.statusbarColor(backgroundColor, !darkTheme)
    }
}
