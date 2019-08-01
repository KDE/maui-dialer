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
    about.appDescription: qsTr("Union lists your contacts and keeps them synced across devices.")
    about.appIcon: "qrc:/smartphone.svg"

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
    headBar.drawBorder: false
//    headBarBGColor: backgroundColor
//    headBarFGColor: textColor

    property bool darkTheme : Maui.FM.loadSettings("dark", "theme", false) == "true"

//    Maui.Dialog
//    {
//        id: _accountsForm
//        defaultButtons: false

//        maxHeight: 300* unit
//        maxWidth: maxHeight
//        Accounts.AddAccountForm {
//            anchors.fill: parent
//            appId: "org.maui.dialer"
//            onAccountAdded: {
//                console.log("Account Secret :", secret);
//            }
//        }
//    }


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
        },

        MenuItem
        {
            checkable: true
            text: qsTr("Accounts");
            onTriggered: _accountsForm.open()
        }
    ]

    headBar.rightContent:  ToolButton
    {
        id: _dialerButton
        icon.name: "show-grid"
//        icon.name: "dialer-pad"
//        icon.color: currentView === views.dialer ?  Kirigami.Theme.highlightColor : Kirigami.Theme.textColor
        //                        text: qsTr("Dialer")
        //            visible: isAndroid
        checked: currentView === views.dialer
        onClicked: currentView = views.dialer

    }



    headBar.middleContent: Kirigami.ActionToolBar
    {
        display: isWide ? ToolButton.TextBesideIcon : ToolButton.IconOnly
        actions: [

            Kirigami.Action
            {
                id: _favsButton
                icon.name: "draw-star"
//                icon.color: currentView === views.favs ? highlightColor : textColor
                text: qsTr("Favorites")
                checked: currentView === views.favs
                onTriggered: currentView = views.favs
                checkable: false

            },

            Kirigami.Action
            {
                id: _logButton
                icon.name: "view-media-recent"
//                icon.color: currentView === views.log ? highlightColor : textColor
                text: qsTr("Recent")
                checked: currentView === views.log
                onTriggered: currentView = views.log
                checkable: false
            },


            Kirigami.Action
            {
                icon.name: "view-pim-contacts"
//                icon.color: currentView === views.contacts ? highlightColor : textColor
                text: qsTr("Contacts")
                //            height: parent.height
                checked: currentView === views.contacts
                onTriggered: currentView = views.contacts
                checkable: false
           }
        ]
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

//            altToolBars: isMobile
            showAccountFilter: isAndroid

            Rectangle
            {
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: toolBarHeight
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

//            headBarExit: false
            headBar.drawBorder: false
//            headBar.implicitHeight: toolBarHeight * 1.4
            headBar.plegable: false

            headBar.middleContent: Maui.TextField
            {
                id: _searchField
//                height: toolBarHeightAlt
//                anchors.centerIn: parent
                Layout.preferredWidth: isWide ? _contacsView.width * 0.8 : _contacsView.width * 0.95
                focusReason : Qt.PopupFocusReason
                //        height: rowHeight
                placeholderText: qsTr("Search %1 contacts... ".arg(_contacsView.view.count))
                onAccepted: _contacsView.list.query = text
                onCleared: _contacsView.list.reset()
//                colorScheme.backgroundColor: cardColor
//                colorScheme.borderColor: "transparent"
//                colorScheme.textColor: textColor
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
        if(_favsView.view.count < 1)
            currentView = views.contacts
        if(isAndroid)
            Maui.Android.statusbarColor(backgroundColor, !darkTheme)
    }
}
