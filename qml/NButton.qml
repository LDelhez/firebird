import QtQuick 2.0
import Firebird.Emu 1.0

Rectangle {
    property string active_color: "#555"
    property string back_color: "#223"
    property string font_color: "#fff"
    property alias text: label.text
    property bool active: false
    property int keymap_id: 1

    border.width: active ? 2 : 1
    border.color: "#888"
    radius: 4
    color: active ? active_color : back_color

    Text {
        id: label
        text: "Foo"
        anchors.fill: parent
        anchors.centerIn: parent
        font.pixelSize: height*0.55
        color: font_color
        font.bold: true
        // Workaround: Text.AutoText doesn't seem to work for properties (?)
        textFormat: text.indexOf(">") == -1 ? Text.PlainText : Text.RichText
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        // Pressing the right mouse button "locks" the button in enabled state
        property bool fixable: false
        property bool state: false

        preventStealing: true

        Component.onCompleted: {
            Emu.registerNButton(keymap_id, this);
        }

        anchors.centerIn: parent
        width: parent.width * 1.3
        height: parent.height * 1.3
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        hoverEnabled: !Emu.isMobile()

        onStateChanged: {
            parent.active = state || containsMouse;

            Emu.keypadStateChanged(parent.keymap_id, state);
        }

        onContainsMouseChanged: {
            parent.active = state || containsMouse;
        }

        onPressed: {
            mouse.accepted = true;

            if(mouse.button == Qt.LeftButton)
            {
                if(!fixable)
                    state = true;
            }
            else if(fixable == state) // Right button
            {
                fixable = !fixable;
                state = !state;
            }
        }

        onReleased: {
            mouse.accepted = true;

            if(mouse.button == Qt.LeftButton
                    && !fixable)
                state = false;
        }
    }
}
