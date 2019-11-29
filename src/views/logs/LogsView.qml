import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import UnionModels 1.0

import "../contacts"

Maui.Page
{
    id: control
//    headBarExit: false
    headBar.visible: false

//    colorScheme.accentColor: "#615f7d"
//    colorScheme.backgroundColor: backgroundColor
//    colorScheme.textColor: textColor

    Maui.Holder
    {
        id: _holder
        emoji: "qrc:/Bench.svg"
        isMask: false
        title: qsTr("There's no recent contacts")
        body: qsTr("recently contacted contacts will appear here")
        emojiSize: Maui.Style.iconSizes.huge
        visible: !_listView.count
        onActionTriggered: _newContactDialog.open()
    }

    Maui.BaseModel
    {
        id: _contactsModel
        list: _callLogsModel
    }

    CallLogs
    {
        id: _callLogsModel
    }

    Menu
    {
        id: _menu
        MenuItem
        {
            text: qsTr("Call")
            icon.name: "dialer-call"
            onTriggered:
            {
                if(isAndroid)
                    Maui.Android.call(_callLogsModel.get(_listView.currentIndex).tel)
            }
        }

        MenuItem
        {
            text: qsTr("Save as..")
            icon.name: "list-add-user"
            onTriggered:
            {
                _newContactDialog.contact = _callLogsModel.get(_listView.currentIndex)
                _newContactDialog.open()
            }
        }
    }

    ListView
    {

        id: _listView
        anchors.fill: parent
        spacing: Maui.Style.space.big
        clip: true

        section.property: "modified"
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.InlineLabels
        section.delegate: Maui.LabelDelegate
        {
            label: section
            isSection: true
            width: parent.width
            //            colorScheme.backgroundColor: "#333"
            //            colorScheme.textColor: "#fafafa"
            //            width: iconSize

            //            background: Rectangle
            //            {
            //                color:  colorScheme.backgroundColor
            //                radius: Maui.Style.radiusV

            //            }


        }

        model: _contactsModel
        delegate: ContactDelegate
        {
            id: _delegate

            label1.text: model.n
            label2.text: Maui.FM.formatDate(model.date, "HH:mm", "dd-MM-yyyy HH:mm") + " / " + new Date(model.duration * 1000).toISOString().substr(11, 8);
            label3.text: model.type

            height: Maui.Style.unit * 60
            width: isWide ? control.width * 0.8 : control.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            showMenuIcon: false

            quickButtons: ToolButton
            {
                icon.name: switch (model.type)
                          {
                          case "INCOMING" : return "go-bottom";
                          case "OUTGOING" : return "go-top";
                          case "MISSED" : return "dialog-close";

                          }

                icon.color: switch (model.type)
                           {
                           case "INCOMING" : return suggestedColor;
                           case "OUTGOING" : return warningColor;
                           case "MISSED" : return dangerColor;

                           }
            }

            Connections
            {
                target: _delegate
                onClicked:
                {
                    _listView.currentIndex = index
                    _menu.popup()
                }
            }
        }

        ScrollBar.vertical: ScrollBar {}
    }


}
