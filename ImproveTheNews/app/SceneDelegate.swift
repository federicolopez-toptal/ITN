//
//  SceneDelegate.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit
import FBSDKCoreKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var lastActiveTime: Date?

    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    // MARK: - Go to inactive
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        self.lastActiveTime = Date()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Back to active
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        let MIN: TimeInterval = 60.0
        let limitDiff: TimeInterval = MIN * 5
        
        if(self.lastActiveTime != nil) {
            let diff = Date().timeIntervalSince(self.lastActiveTime!)
            print("SceneDelegate / Time difference:", diff)
            if(diff >= limitDiff) {
                NOTIFY(Notification_reloadMainFeed)
                NOTIFY(Notification_reloadMainFeedOnShow)
            }
        }
        
        if(UIFontMetrics.default.scaledValue(for: 100) != AppDelegate.fontScale) {
            AppDelegate.fontScale = UIFontMetrics.default.scaledValue(for: 100)
            
            CustomNavController.shared.tabsBar.selectTab(1, loadContent: false)
            let vc = NAV_MAINFEED_VC()
            CustomNavController.shared.viewControllers = [vc]
        }
        
        self.checkForOSThemeChange()
    }
    
    func checkForOSThemeChange() {
        if(DisplayMode.menuCurrent() == 1) {
            CustomNavController.shared.menu.setOSTheme()
        }
    }
}

/*

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        // URL SCHEME
        let strUrl = url.absoluteString.lowercased()
        if(strUrl.contains("itntestapp")) {
            if(strUrl.contains("fb")) {
                if(strUrl.contains("usrid") && strUrl.contains("jwt")) {
                    // FB login callback
                    let params = url.params()
                    let _uuid = params["usrid"] as! String
                    let _jwt = params["jwt"] as! String

                    let api = ShareAPI.instance
                    api.writeJWT(_jwt)
                    api.writeUUID(_uuid)
                    NotificationCenter.default.post(name: NOTIFICATION_FB_LOGGED, object: nil)
                } else {
                    NotificationCenter.default.post(name: NOTIFICATION_FB_DONE, object: nil)
                }
            }
        }

        // FB
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

*/
