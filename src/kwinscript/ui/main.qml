// SPDX-FileCopyrightText: 2018-2019 Eon S. Jeon <esjeon@hyunmu.am>
// SPDX-FileCopyrightText: 2021 Mikhail Zolotukhin <mail@genda.life>
// SPDX-License-Identifier: MIT

import "../code/index.mjs" as Bismuth
import QtQuick 2.0
import org.kde.bismuth.core 1.0 as BiCore
import org.kde.kwin 2.0
import org.kde.taskmanager 0.1 as TaskManager

Item {
    id: scriptRoot

    property var controller

    Component.onCompleted: {
        console.log("[Bismuth] Initiating the script");
        const qmlObjects = {
            "scriptRoot": scriptRoot,
            "trayItem": trayItem,
            "activityInfo": activityInfo,
            "popupDialog": popupDialog
        };
        const kwinScriptingAPI = {
            "workspace": workspace,
            "options": options,
            "KWin": KWin
        };
        // Init core
        core.init();
        // Init legacy JS backend
        scriptRoot.controller = Bismuth.init(qmlObjects, kwinScriptingAPI, core.proxy);
    }
    Component.onDestruction: {
        console.log("[Bismuth] Everybody is dead");
        scriptRoot.controller.drop();
    }

    BiCore.Core {
        id: core
    }

    TrayItem {
        id: trayItem
    }

    TaskManager.ActivityInfo {
        id: activityInfo
    }

    Loader {
        id: popupDialog

        function show(text, icon, hint) {
            this.item.show(text, icon, hint);
        }

        source: "popup.qml"
    }

}
