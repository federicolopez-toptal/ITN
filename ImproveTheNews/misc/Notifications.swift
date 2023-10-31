//
//  Notifications.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import Foundation

let Notification_reloadMainFeed = Notification.Name("ReloadMainFeed")               // Reload the main feed
let Notification_refreshMainFeed = Notification.Name("RefreshMainFeed")             // Refresh the main feed
let Notification_removeBanner = Notification.Name("RemoveBanner")                   // Remove banner + reload main feed
let Notification_reloadMainFeedOnShow = Notification.Name("ReloadMainFeedOnSHow")   // Reload main feed on show viewController

let Notification_stanceIconTap = Notification.Name("StanceIconTap")                 // User taps on a Stance icon

let Notification_tryAgainButtonTap = Notification.Name("TryAgainButtonTap")         // User taps on a "Try again" button


func NOTIFY(_ name: Notification.Name, userInfo: [AnyHashable: Any]? = nil) {
    NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
}
