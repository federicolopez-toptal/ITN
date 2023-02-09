//
//  Notifications.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation

let Notification_reloadMainFeed = Notification.Name("ReloadMainFeed")               // Reload the main feed!
let Notification_refreshMainFeed = Notification.Name("RefreshMainFeed")             // Refresh the main feed
let Notification_removeBanner = Notification.Name("RemoveBanner")                   // Remove banner + reload main feed
let Notification_reloadMainFeedOnShow = Notification.Name("ReloadMainFeedOnSHow")   // Reload main feed on show viewController



func NOTIFY(_ name: Notification.Name) {
    NotificationCenter.default.post(name: name, object: nil)
}
