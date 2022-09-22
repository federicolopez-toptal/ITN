//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    static var shared: CustomNavController!

    let loadingView = LoadingView()
    let slidersPanel = SlidersPanel()
    let floatingButton = FloatingButton()
    let darkView = DarkView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if(CustomNavController.shared == nil){ CustomNavController.shared = self }
        
        self.isNavigationBarHidden = true
        self.slidersPanel.buildInto(self.view)
        self.floatingButton.buildInto(self.view, panel: self.slidersPanel)
        self.loadingView.buildInto(self.view)
        self.darkView.buildInto(self.view)
        
        self.addViewController()
    }
    
    private func addViewController() {
        let vc = MainFeedViewController()
        self.setViewControllers([vc], animated: false)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DELAY(1.0) {
//            self.slidersPanel.show(rows: 2, animated: true)
//        }
//    }

    func refreshDisplayMode() {
        self.slidersPanel.refreshDisplayMode()
        self.loadingView.refreshDisplayMode()
        self.darkView.refreshDisplayMode()

        for vc in self.viewControllers {
            if(vc is BaseViewController) {
                (vc as! BaseViewController).refreshDisplayMode()
            }
        }
        
        for v in self.view.subviews {
            if(v is PopupView) {
                (v as! PopupView).refreshDisplayMode()
            }
        }
    }
    
}

// MARK: - misc
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

    func callMenu() {
        let menuVC = MenuViewController()
        self.customPushViewController(menuVC)

        self.slidersPanel.hide()
        self.floatingButton.hide()
    }
    
    func dismissMenu() {
        self.customPopViewController()
    
        self.slidersPanel.show()
        self.floatingButton.show()
    }

}
