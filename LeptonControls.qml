import QtQuick 2.0
import QtQuick.Controls 2.0
import GetThermal 1.0

Item {
    id: root
    width: 200
    property UvcAcquisition acq: null

    GroupBox {
        id: groupBox1

        anchors.margins: 5
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        title: qsTr("Camera Info")

        Grid {

            columns: 1
            rows: 8
            anchors.fill: parent
            spacing: 10
            flow: Grid.TopToBottom

            Label {
                id: label1
                text: qsTr("Label")
            }

            Label {
                id: label2
                text: qsTr("Label")
            }
        }


    }

    Frame {
        id: frame1
        height: buttonFfc.height + 20

        anchors.margins: 5
        anchors.top: groupBox1.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        Button {
            id: buttonFfc
            text: qsTr("Perform AGC")
        }

        BusyIndicator {
            id: busyFfc
            height: buttonFfc.height
            visible: false
            width: height
            anchors.left: buttonFfc.right
            anchors.leftMargin: 5
        }
    }

    GroupBox {
        id: frame2
        title: qsTr("VID module")

        anchors.margins: 5
        anchors.top: frame1.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        ComboBox {
            id: comboVidPcolorLut

            anchors.margins: 5
            anchors.top: parent.top

            model: ListModel {
                ListElement { text: "Wheel"; data: LEP_PCOLOR_LUT_E.LEP_VID_WHEEL6_LUT }
                ListElement { text: "Fusion"; data: LEP_PCOLOR_LUT_E.LEP_VID_FUSION_LUT }
                ListElement { text: "Rainbow"; data: LEP_PCOLOR_LUT_E.LEP_VID_RAINBOW_LUT }
                ListElement { text: "Glowbow"; data: LEP_PCOLOR_LUT_E.LEP_VID_GLOBOW_LUT }
                ListElement { text: "Sepia"; data: LEP_PCOLOR_LUT_E.LEP_VID_SEPIA_LUT }
                ListElement { text: "Color"; data: LEP_PCOLOR_LUT_E.LEP_VID_COLOR_LUT }
                ListElement { text: "Ice & Fire"; data: LEP_PCOLOR_LUT_E.LEP_VID_ICE_FIRE_LUT }
                ListElement { text: "Rain"; data: LEP_PCOLOR_LUT_E.LEP_VID_RAIN_LUT }
                ListElement { text: "User"; data: LEP_PCOLOR_LUT_E.LEP_VID_USER_LUT }
            }
            textRole: qsTr("text")

            currentIndex: acq.cci.vidPcolorLut
        }
    }

    Connections {
        target: comboVidPcolorLut
        onCurrentIndexChanged: {
            var currentItem = comboVidPcolorLut.model.get(comboVidPcolorLut.currentIndex);
            acq.cci.vidPcolorLut = currentItem.data;
        }
    }

    function delay(delayTime, cb) {
        function Timer() {
            return Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
        }
        var timer = new Timer();
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Connections {
        target: buttonFfc
        onClicked: {
            busyFfc.visible = true;
            acq.pauseStream();
            delay(150, function(){
                acq.cci.performFfc();
                delay(1500, function() {
                    acq.resumeStream();
                    busyFfc.visible = false;
                });
            });
        }
    }
}