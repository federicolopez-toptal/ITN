//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    static var shared: CustomNavController! // singleton
    
    // flags
    var didLayout = false
    var showTour = false
    
    // UI components
    let menu = MenuView()
    let loading = LoadingView()
    let slidersPanel = SlidersPanel()
    let floatingButton = FloatingButton()
    let darkView = DarkView()



    override func viewDidLoad() {
        super.viewDidLoad()
        if(CustomNavController.shared == nil){ CustomNavController.shared = self }
        self.isNavigationBarHidden = true
        
        self.slidersPanel.buildInto(self.view)
        self.floatingButton.buildInto(self.view, panel: self.slidersPanel)
        self.slidersPanel.floatingButton = self.floatingButton
        
        self.loading.buildInto(self.view)
        self.darkView.buildInto(self.view)
        
        self.addInitialViewController() // Start!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(!self.didLayout) {
            self.didLayout = true
            self.menu.buildInto(self.view)
        }
    }
    
    private func addInitialViewController() {
        if(IPHONE()) {
            let vc = MainFeedViewController()
            self.setViewControllers([vc], animated: false)
        } else {
            let vc = MainFeed_v2ViewController()
            self.setViewControllers([vc], animated: false)
        }
    }

    func refreshDisplayMode() {
        self.slidersPanel.refreshDisplayMode()
        self.loading.refreshDisplayMode()
        self.darkView.refreshDisplayMode()
        self.menu.refreshDisplayMode()

        for vc in self.viewControllers {
            if(vc is BaseViewController) {
                DELAY(0.1) { // delay, to avoid layout weird behavior
                    (vc as! BaseViewController).refreshDisplayMode()
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

// MARK: - Sliders panel + Floating button
extension CustomNavController {

    func hidePanelAndButtonWithAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.slidersPanel.alpha = 0
            self.floatingButton.alpha = 0
        } completion: { _ in
            self.slidersPanel.hide()
            self.floatingButton.hide()
        }

    }
    
    func showPanelAndButtonWithAnimation() {
        self.slidersPanel.alpha = 0
        self.slidersPanel.show()
        self.floatingButton.alpha = 0
        self.floatingButton.show()
    
        UIView.animate(withDuration: 0.5) {
            self.slidersPanel.alpha = 1
            self.floatingButton.alpha = 1
        } completion: { _ in
        }
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

        self.slidersPanel.hide()
        self.floatingButton.hide()
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
        
        if(showComponents) {
            self.slidersPanel.show()
            self.floatingButton.show()
        }
    }

}

// MARK: - misc
extension CustomNavController {
    
    func infoAlert(message msg: String) {
        ALERT(vc: self, title: "⚠️ Info", message: msg)
    }
    
}
