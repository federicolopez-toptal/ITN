//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    static var shared: CustomNavController! // Singleton
    
    // flags
    var didLayout = false
    
    // UI components
    let menu = MenuView()
    let loading = LoadingView()
    let darkView = DarkView()
    let tabsBar = TabsBar.customInit()
    
    var tour = Tour_v2()
    var tour_old: Tour?



    override func viewDidLoad() {
        super.viewDidLoad()
        if(CustomNavController.shared == nil){ CustomNavController.shared = self }
        self.isNavigationBarHidden = true
        
        self.tabsBar.buildInto(self.view)
        self.loading.buildInto(self.view)
        self.darkView.buildInto(self.view)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(darkViewOnTap(sender:)))
        self.darkView.addGestureRecognizer(tapGesture)

        self.addInitialViewController() // Start!
    }
    
    @objc func darkViewOnTap(sender: UITapGestureRecognizer?) {
        self.dismissMenu()

        for V in self.view.subviews {
            if let popup = V as? PopupView {
                popup.dismissMe()
            }
        }
        
        //self.tour_old?.cancel()
        self.tour.cancel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(!self.didLayout) {
            self.didLayout = true
            self.menu.buildInto(self.view)
            
            self.tour.buildInto(container: self.view)
            self.tour_old = Tour(buildInto: self.view)
        }
    }
    
    func refreshTour() {
        self.tour = Tour_v2()
        self.tour.buildInto(container: self.view)
    }
    
    private func addInitialViewController() {
        let vc = NAV_MAINFEED_VC()
        self.setViewControllers([vc], animated: false)
    }

    func refreshDisplayMode() {
        self.loading.refreshDisplayMode()
        self.darkView.refreshDisplayMode()
        self.menu.refreshDisplayMode()
        self.tabsBar.refreshDisplayMode()

        for vc in self.viewControllers {
            if let _vc = vc as? BaseViewController {
                _vc.setNeedsStatusBarAppearanceUpdate()
                
                DELAY(0.1) {
                    _vc.refreshDisplayMode()
                }
            }
        }
        
        for v in self.view.subviews {
            if(v is PopupView) {
                (v as! PopupView).refreshDisplayMode()
            }
        }
    }
    
}

// MARK: - Tour
extension CustomNavController {
    
    func startTour() {
        self.tour_old = Tour(buildInto: self.view)
        self.tour_old?.start()
    }
    
}

// MARK: - Menu
extension CustomNavController {

    func showMenu() {
        self.darkView.alpha = 0
        self.darkView.show()
        self.menu.menuLeadingConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.darkView.alpha = 1.0
            self.view.layoutIfNeeded()
        }

        self.tour_old?.cancel(dissapearDarkBackground: false)
    }
    
    func dismissMenu(showDarkBackground: Bool = false) {
        self.menu.menuLeadingConstraint?.constant = -self.menu.MENU_WIDTH
        UIView.animate(withDuration: 0.3) {
            if(!showDarkBackground){ self.darkView.alpha = 0 }
            self.view.layoutIfNeeded()
        } completion: { _ in
            if(!showDarkBackground){ self.darkView.hide() }
        }
    
        var showComponents = false
        if let _ = self.viewControllers.first as? MainFeedViewController {
            showComponents = true
        }
        if let _ = self.viewControllers.first as? MainFeed_v2ViewController {
            showComponents = true
        }
        if let _ = self.viewControllers.first as? MainFeed_v3_viewController {
            showComponents = true
        }
        if let _ = self.viewControllers.first as? MainFeediPad_v3_viewController {
            showComponents = true
        }
    }

}

// MARK: - misc
extension CustomNavController {
    
    func info(message msg: String) {
        ALERT(vc: self, title: "", message: msg) {
        }
    }
    
    func infoAlert(message msg: String) {
        ALERT(vc: self, title: "⚠️ Info", message: msg) {
        }
    }
    
    func ask(question msg: String, onCompletion: @escaping (Bool)->()) {
        ALERT_YESNO(vc: self, title: "⚠️ Question", message: msg) { (result) in
            onCompletion(result)
        }
    }
    
}

// MARK: - Content & stuff
extension CustomNavController {
    
    func loadNewsSliders() {
        if let _vc = CustomNavController.shared.viewControllers.first as? NewSlidersViewController {
            if(CustomNavController.shared.viewControllers.count==1) {
                _vc.list.scrollToTop()
            } else {
                CustomNavController.shared.popToRootViewController(animated: true)
            }
        } else {
            let vc = NewSlidersViewController()
            CustomNavController.shared.viewControllers = [vc]
        }
    }
    
    func loadPublicFigures() {
        if let _vc = CustomNavController.shared.viewControllers.first as? PublicFiguresViewController {
            if(CustomNavController.shared.viewControllers.count==1) {
                _vc.scrollView.scrollToZero()
            } else {
                CustomNavController.shared.popToRootViewController(animated: true)
            }
        } else {
            let vc = PublicFiguresViewController()
            CustomNavController.shared.viewControllers = [vc]
        }
    }
    
    func loadControversies() {
        if let _vc = CustomNavController.shared.viewControllers.first as? ControversiesViewController {
            if(CustomNavController.shared.viewControllers.count==1) {
                _vc.scrollView.scrollToZero()
            } else {
                CustomNavController.shared.popToRootViewController(animated: true)
            }
        } else {
            let vc = ControversiesViewController()
            CustomNavController.shared.viewControllers = [vc]
        }
    }
    
    func loadHeadlines() {
         if(IPHONE()) {
            var firstIsMainFeed = false
            if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeed_v3_viewController {
                if(firstVC.topic == "news"){ firstIsMainFeed = true }
            }
            
            if(firstIsMainFeed) {
                let count = CustomNavController.shared.viewControllers.count
            
                if(count==1) {
                    self.gotoHeadlines_B()
                } else {
                    CustomNavController.shared.popToRootViewController(animated: true)
                    DELAY(0.1) {
                        self.gotoHeadlines_B()
                    }
                }
            } else {
                let vc = NAV_MAINFEED_VC()
                CustomNavController.shared.viewControllers = [vc]
            }
        } else {
            var firstIsMainFeed = false
            if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeediPad_v3_viewController {
                if(firstVC.topic == "news"){ firstIsMainFeed = true }
            }
            
            if(firstIsMainFeed) {
                let count = CustomNavController.shared.viewControllers.count
            
                if(count==1) {
                    self.gotoHeadlines_B()
                } else {
                    CustomNavController.shared.popToRootViewController(animated: true)
                    DELAY(0.3) {
                        self.gotoHeadlines_B()
                    }
                }
            } else {
                let vc = NAV_MAINFEED_VC()
                CustomNavController.shared.viewControllers = [vc]
            }
        }
    }
    private func gotoHeadlines_B() {
        if(IPHONE()) {
            if let _vc = CustomNavController.shared.viewControllers.first as? MainFeed_v3_viewController {
                _vc.list.scrollToTop()
            }
        } else {
            if let _vc = CustomNavController.shared.viewControllers.first as? MainFeediPad_v3_viewController {
                _vc.list.scrollToTop()
            }
        }
    }
    
}
