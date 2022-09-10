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

    override func viewDidLoad() {
        super.viewDidLoad()
        if(CustomNavController.shared == nil){ CustomNavController.shared = self }
        
        self.isNavigationBarHidden = true
        self.slidersPanel.buildInto(self.view)
        self.floatingButton.buildInto(self.view, panel: self.slidersPanel)
        self.loadingView.buildInto(self.view)
        
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
        
        for vc in self.viewControllers {
            if(vc is MainFeedViewController) {
                (vc as! MainFeedViewController).refreshDisplayMode()
            }
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
