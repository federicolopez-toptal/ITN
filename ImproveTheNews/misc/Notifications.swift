//
//  Notifications.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation

let Notification_reloadMainFeed = Notification.Name("ReloadMainFeed")   // Reload the main feed!
let Notification_refreshMainFeed = Notification.Name("RefreshMainFeed") // Refresh the main feed!


func NOTIFY(_ name: Notification.Name) {
    NotificationCenter.default.post(name: name, object: nil)
}
