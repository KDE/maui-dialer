import QtQuick 2.9
import QtQuick.Controls 2.3
import org.kde.mauikit 1.0 as Maui
import UnionModels 1.0

import "../contacts"

Maui.Page
{
    id: control
    headBarExit: false
    headBar.visible: false

    colorScheme.accentColor: "#615f7d"
    colorScheme.backgroundColor: backgroundColor
    colorScheme.textColor: textColor

    BaseModel
    {
        id: _contactsModel
        list: _callLogsModel
    }

    CallLogs
    {
        id: _callLogsModel
    }

    Maui.Menu
    {
        id: _menu
        Maui.MenuItem
        {
            text: qsTr("Call")
            icon.name: "dialer-call"
            onTriggered:
            {
                if(isAndroid)
                    Maui.Android.call(_callLogsModel.get(_listView.currentIndex).tel)
            }
        }

        Maui.MenuItem
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
        spacing: space.big
        clip: true

        section.property: "modified"
        section.criteria: ViewSection.FullString
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

            label1.text: model.n
            label2.text: Maui.FM.formatDate(model.date, "HH:mm", "dd-MM-yyyy HH:mm") + " / " + new Date(model.duration * 1000).toISOString().substr(11, 8);
            label3.text: model.type

            height: unit * 60
            width: isWide ? control.width * 0.8 : control.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            showMenuIcon: false

            quickButtons: Maui.ToolButton
            {
                iconName: switch (model.type)
                          {
                          case "INCOMING" : return "go-bottom";
                          case "OUTGOING" : return "go-top";
                          case "MISSED" : return "dialog-close";

                          }

                iconColor: switch (model.type)
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
