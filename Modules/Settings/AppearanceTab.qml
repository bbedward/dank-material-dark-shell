import QtQuick
import QtQuick.Controls
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets

ScrollView {
    id: appearanceTab

    contentWidth: availableWidth
    contentHeight: column.implicitHeight + Theme.spacingXL
    clip: true

    Column {
        id: column

        width: parent.width
        spacing: Theme.spacingXL
        topPadding: Theme.spacingL
        bottomPadding: Theme.spacingXL

        // Display Settings Section
        StyledRect {
            width: parent.width
            height: displaySection.implicitHeight + Theme.spacingL * 2
            radius: Theme.cornerRadiusLarge
            color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Column {
                id: displaySection

                anchors.fill: parent
                anchors.margins: Theme.spacingL
                spacing: Theme.spacingM

                Row {
                    width: parent.width
                    spacing: Theme.spacingM

                    DankIcon {
                        name: "monitor"
                        size: Theme.iconSize
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: "Display Settings"
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                DankToggle {
                    width: parent.width
                    text: "Night Mode"
                    description: "Apply warm color temperature to reduce eye strain"
                    checked: Prefs.nightModeEnabled
                    onToggled: (checked) => {
                        Prefs.setNightModeEnabled(checked);
                        if (checked)
                            nightModeEnableProcess.running = true;
                        else
                            nightModeDisableProcess.running = true;
                    }
                }

                DankToggle {
                    width: parent.width
                    text: "Light Mode"
                    description: "Use light theme instead of dark theme"
                    checked: Prefs.isLightMode
                    onToggled: (checked) => {
                        Prefs.setLightMode(checked);
                        Theme.isLightMode = checked;
                    }
                }

                DankDropdown {
                    width: parent.width
                    text: "Icon Theme"
                    description: "Select icon theme (requires restart)"
                    currentValue: Prefs.iconTheme
                    options: Prefs.availableIconThemes
                    onValueChanged: (value) => {
                        Prefs.setIconTheme(value);
                    }
                }

            }

        }

        // Transparency Settings Section
        StyledRect {
            width: parent.width
            height: transparencySection.implicitHeight + Theme.spacingL * 2
            radius: Theme.cornerRadiusLarge
            color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Column {
                id: transparencySection

                anchors.fill: parent
                anchors.margins: Theme.spacingL
                spacing: Theme.spacingM

                Row {
                    width: parent.width
                    spacing: Theme.spacingM

                    DankIcon {
                        name: "opacity"
                        size: Theme.iconSize
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: "Transparency Settings"
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                Column {
                    width: parent.width
                    spacing: Theme.spacingS

                    StyledText {
                        text: "Top Bar Transparency"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceText
                        font.weight: Font.Medium
                    }

                    DankSlider {
                        width: parent.width
                        height: 24
                        value: Math.round(Prefs.topBarTransparency * 100)
                        minimum: 0
                        maximum: 100
                        unit: ""
                        showValue: true
                        onSliderValueChanged: (newValue) => {
                            Prefs.setTopBarTransparency(newValue / 100);
                        }
                    }

                }

                Column {
                    width: parent.width
                    spacing: Theme.spacingS

                    StyledText {
                        text: "Popup Transparency"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceText
                        font.weight: Font.Medium
                    }

                    DankSlider {
                        width: parent.width
                        height: 24
                        value: Math.round(Prefs.popupTransparency * 100)
                        minimum: 0
                        maximum: 100
                        unit: ""
                        showValue: true
                        onSliderValueChanged: (newValue) => {
                            Prefs.setPopupTransparency(newValue / 100);
                        }
                    }

                }

            }

        }

        // Theme Picker Section
        StyledRect {
            width: parent.width
            height: themeSection.implicitHeight + Theme.spacingL * 2
            radius: Theme.cornerRadiusLarge
            color: Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3)
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.2)
            border.width: 1

            Column {
                id: themeSection

                anchors.fill: parent
                anchors.margins: Theme.spacingL
                spacing: Theme.spacingM

                Row {
                    width: parent.width
                    spacing: Theme.spacingM

                    DankIcon {
                        name: "palette"
                        size: Theme.iconSize
                        color: Theme.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: "Theme Color"
                        font.pixelSize: Theme.fontSizeLarge
                        font.weight: Font.Medium
                        color: Theme.surfaceText
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                Column {
                    width: parent.width
                    spacing: Theme.spacingS

                    StyledText {
                        text: "Current Theme: " + (Theme.isDynamicTheme ? "Auto" : (Theme.currentThemeIndex < Theme.themes.length ? Theme.themes[Theme.currentThemeIndex].name : "Blue"))
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceText
                        font.weight: Font.Medium
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    StyledText {
                        text: {
                            if (Theme.isDynamicTheme)
                                return "Wallpaper-based dynamic colors";

                            var descriptions = ["Material blue inspired by modern interfaces", "Deep blue inspired by material 3", "Rich purple tones for BB elegance", "Natural green for productivity", "Energetic orange for creativity", "Bold red for impact", "Cool cyan for tranquility", "Vibrant pink for expression", "Warm amber for comfort", "Soft coral for gentle warmth"];
                            return descriptions[Theme.currentThemeIndex] || "Select a theme";
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        anchors.horizontalCenter: parent.horizontalCenter
                        wrapMode: Text.WordWrap
                        width: Math.min(parent.width, 400)
                        horizontalAlignment: Text.AlignHCenter
                    }

                }

                // Theme Grid
                Column {
                    spacing: Theme.spacingS
                    anchors.horizontalCenter: parent.horizontalCenter

                    // First row - Blue, Deep Blue, Purple, Green, Orange
                    Row {
                        spacing: Theme.spacingM
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: 5

                            Rectangle {
                                width: 32
                                height: 32
                                radius: 16
                                color: Theme.themes[index].primary
                                border.color: Theme.outline
                                border.width: (Theme.currentThemeIndex === index && !Theme.isDynamicTheme) ? 2 : 1
                                scale: (Theme.currentThemeIndex === index && !Theme.isDynamicTheme) ? 1.1 : 1

                                // Theme name tooltip
                                Rectangle {
                                    width: nameText.contentWidth + Theme.spacingS * 2
                                    height: nameText.contentHeight + Theme.spacingXS * 2
                                    color: Theme.surfaceContainer
                                    border.color: Theme.outline
                                    border.width: 1
                                    radius: Theme.cornerRadiusSmall
                                    anchors.bottom: parent.top
                                    anchors.bottomMargin: Theme.spacingXS
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: mouseArea.containsMouse

                                    StyledText {
                                        id: nameText

                                        text: Theme.themes[index].name
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceText
                                        anchors.centerIn: parent
                                    }

                                }

                                MouseArea {
                                    id: mouseArea

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        Theme.switchTheme(index, false);
                                    }
                                }

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.emphasizedEasing
                                    }

                                }

                                Behavior on border.width {
                                    NumberAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.emphasizedEasing
                                    }

                                }

                            }

                        }

                    }

                    // Second row - Red, Cyan, Pink, Amber, Coral
                    Row {
                        spacing: Theme.spacingM
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: 5

                            Rectangle {
                                property int themeIndex: index + 5

                                width: 32
                                height: 32
                                radius: 16
                                color: themeIndex < Theme.themes.length ? Theme.themes[themeIndex].primary : "transparent"
                                border.color: Theme.outline
                                border.width: Theme.currentThemeIndex === themeIndex ? 2 : 1
                                visible: themeIndex < Theme.themes.length
                                scale: Theme.currentThemeIndex === themeIndex ? 1.1 : 1

                                // Theme name tooltip
                                Rectangle {
                                    width: nameText2.contentWidth + Theme.spacingS * 2
                                    height: nameText2.contentHeight + Theme.spacingXS * 2
                                    color: Theme.surfaceContainer
                                    border.color: Theme.outline
                                    border.width: 1
                                    radius: Theme.cornerRadiusSmall
                                    anchors.bottom: parent.top
                                    anchors.bottomMargin: Theme.spacingXS
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: mouseArea2.containsMouse && themeIndex < Theme.themes.length

                                    StyledText {
                                        id: nameText2

                                        text: themeIndex < Theme.themes.length ? Theme.themes[themeIndex].name : ""
                                        font.pixelSize: Theme.fontSizeSmall
                                        color: Theme.surfaceText
                                        anchors.centerIn: parent
                                    }

                                }

                                MouseArea {
                                    id: mouseArea2

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (themeIndex < Theme.themes.length)
                                            Theme.switchTheme(themeIndex);

                                    }
                                }

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.emphasizedEasing
                                    }

                                }

                                Behavior on border.width {
                                    NumberAnimation {
                                        duration: Theme.shortDuration
                                        easing.type: Theme.emphasizedEasing
                                    }

                                }

                            }

                        }

                    }

                    // Spacer
                    Item {
                        width: 1
                        height: Theme.spacingM
                    }

                    // Auto theme button
                    Rectangle {
                        width: 120
                        height: 40
                        radius: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: {
                            if (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")
                                return Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.12);
                            else
                                return Qt.rgba(Theme.surfaceVariant.r, Theme.surfaceVariant.g, Theme.surfaceVariant.b, 0.3);
                        }
                        border.color: {
                            if (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")
                                return Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.5);
                            else if (Theme.isDynamicTheme)
                                return Theme.primary;
                            else
                                return Theme.outline;
                        }
                        border.width: Theme.isDynamicTheme ? 2 : 1
                        scale: Theme.isDynamicTheme ? 1.1 : (autoMouseArea.containsMouse ? 1.02 : 1)

                        Row {
                            anchors.centerIn: parent
                            spacing: Theme.spacingS

                            DankIcon {
                                name: {
                                    if (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")
                                        return "error";
                                    else
                                        return "palette";
                                }
                                size: 16
                                color: {
                                    if (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")
                                        return Theme.error;
                                    else
                                        return Theme.surfaceText;
                                }
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            StyledText {
                                text: {
                                    if (ToastService.wallpaperErrorStatus === "error")
                                        return "Error";
                                    else if (ToastService.wallpaperErrorStatus === "matugen_missing")
                                        return "No matugen";
                                    else
                                        return "Auto";
                                }
                                font.pixelSize: Theme.fontSizeMedium
                                color: {
                                    if (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")
                                        return Theme.error;
                                    else
                                        return Theme.surfaceText;
                                }
                                font.weight: Font.Medium
                                anchors.verticalCenter: parent.verticalCenter
                            }

                        }

                        MouseArea {
                            id: autoMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (ToastService.wallpaperErrorStatus === "matugen_missing")
                                    ToastService.showError("matugen not found - install matugen package for dynamic theming");
                                else if (ToastService.wallpaperErrorStatus === "error")
                                    ToastService.showError("Wallpaper processing failed - check wallpaper path");
                                else
                                    Theme.switchTheme(10, true);
                            }
                        }

                        // Tooltip for Auto button
                        Rectangle {
                            width: autoTooltipText.contentWidth + Theme.spacingM * 2
                            height: autoTooltipText.contentHeight + Theme.spacingS * 2
                            color: Theme.surfaceContainer
                            border.color: Theme.outline
                            border.width: 1
                            radius: Theme.cornerRadiusSmall
                            anchors.bottom: parent.top
                            anchors.bottomMargin: Theme.spacingS
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: autoMouseArea.containsMouse && (!Theme.isDynamicTheme || ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing")

                            StyledText {
                                id: autoTooltipText

                                text: {
                                    if (ToastService.wallpaperErrorStatus === "error")
                                        return "Wallpaper symlink missing at ~/quickshell/current_wallpaper";
                                    else if (ToastService.wallpaperErrorStatus === "matugen_missing")
                                        return "Install matugen package for dynamic themes";
                                    else
                                        return "Dynamic wallpaper-based colors";
                                }
                                font.pixelSize: Theme.fontSizeSmall
                                color: (ToastService.wallpaperErrorStatus === "error" || ToastService.wallpaperErrorStatus === "matugen_missing") ? Theme.error : Theme.surfaceText
                                anchors.centerIn: parent
                                wrapMode: Text.WordWrap
                                width: Math.min(implicitWidth, 250)
                                horizontalAlignment: Text.AlignHCenter
                            }

                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: Theme.shortDuration
                                easing.type: Theme.emphasizedEasing
                            }

                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.mediumDuration
                                easing.type: Theme.standardEasing
                            }

                        }

                        Behavior on border.color {
                            ColorAnimation {
                                duration: Theme.mediumDuration
                                easing.type: Theme.standardEasing
                            }

                        }

                    }

                }

            }

        }

    }

    // Night mode processes
    Process {
        id: nightModeEnableProcess

        command: ["bash", "-c", "if command -v wlsunset > /dev/null; then pkill wlsunset; wlsunset -t 3000 & elif command -v redshift > /dev/null; then pkill redshift; redshift -P -O 3000 & else echo 'No night mode tool available'; fi"]
        running: false
        onExited: (exitCode) => {
            if (exitCode !== 0) {
                console.warn("Failed to enable night mode");
                Prefs.setNightModeEnabled(false);
            }
        }
    }

    Process {
        id: nightModeDisableProcess

        command: ["bash", "-c", "pkill wlsunset; pkill redshift; if command -v wlsunset > /dev/null; then wlsunset -t 6500 -T 6500 & sleep 1; pkill wlsunset; elif command -v redshift > /dev/null; then redshift -P -O 6500; redshift -x; fi"]
        running: false
        onExited: (exitCode) => {
            if (exitCode !== 0)
                console.warn("Failed to disable night mode");

        }
    }

}
