//
//  AccountViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/05/2023.
//

import UIKit

class AccountViewController: BaseViewController {

    let navBar = NavBarView()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            for (i, vc) in CustomNavController.shared.viewControllers.enumerated() {
                if(vc is SignInUpViewController) {
                    CustomNavController.shared.viewControllers.remove(at: i)
                    break
                }
            }
            
            self.loadUserData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("My account")

            self.buildContent()
            CustomNavController.shared.hidePanelAndButtonWithAnimation()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.navBar.refreshDisplayMode()
    }
    
    func loadUserData() {
        self.showLoading()
        API.shared.getUserInfo { (success, serverMsg, user) in
            self.hideLoading()
            print(user?.firstName, user?.lastName, user?.userName, user?.email)
        }
    }

}

extension AccountViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
