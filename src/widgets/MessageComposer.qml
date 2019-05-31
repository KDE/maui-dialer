import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.mauikit 1.0 as Maui
import org.kde.kirigami 2.2 as Kirigami

Maui.Dialog
{

    id: control
    property var contact : ({})

    maxWidth: unit * 500
    maxHeight: maxWidth



    onAccepted:
    {
        if(!isMobile && !isAndroid)
            Maui.KDE.email(contact.email, "", "", _subjectTextField.text, _editor.text)
        else if(!isAndroid)
        {
            if(_combobox.currentText === contact.email)
                Qt.openUrlExternally("mailto:" + contact.email)
            else if(_combobox.currentText === contact.tel)
            {
                Qt.openUrlExternally("sms:" + contact.tel +"&sms_body:" + _editor.text)
                notify("emblem-info", qsTr("Message sent"), contact.tel)
            }
        }else
        {
            if(_combobox.currentText === contact.email)
                Qt.openUrlExternally("mailto:" + contact.email)
            else if(_combobox.currentText === contact.tel)
                Maui.Android.sendSMS(contact.tel, _subjectTextField.text, _editor.text)
        }


        close();
    }

    acceptButton.text: qsTr("Send...")
    rejectButton.visible: false

    ColumnLayout
    {
        anchors.fill: parent

        Maui.ComboBox
        {
            id: _combobox
            Layout.fillWidth: true
            Layout.preferredHeight: toolBarHeightAlt

            //                text: isAndroid ? contact.tel : contact.email
            font.bold: true
            font.weight: Font.Bold
            font.pointSize: fontSizes.big
            colorScheme.viewBackgroundColor: cardColor
            colorScheme.borderColor: "transparent"
            colorScheme.textColor: "#fff"
            model:
            {
                if(contact.email && contact.tel)
                    return [contact.email, contact.tel]
                else if(contact.email)
                    return [contact.email]
                else if(contact.tel)
                    return [contact.tel]
            }

            popup.z: control.z + 1
        }

        Maui.TextField
        {
            id: _subjectTextField
            visible: _combobox.currentText === contact.email
            Layout.fillWidth: true
            Layout.preferredHeight: toolBarHeightAlt
            placeholderText: qsTr("Subject")
            font.bold: true
            font.weight: Font.Bold
            font.pointSize: fontSizes.big
            colorScheme.backgroundColor: cardColor
            colorScheme.borderColor: "transparent"
            colorScheme.textColor: "#fff"
        }


        Maui.Editor
        {
            id: _editor
            Layout.fillHeight: true
            Layout.fillWidth: true
            headBar.drawBorder: false
            headBar.plegable: false
        }
    }


}
