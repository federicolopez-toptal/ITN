//
//  SignInUpViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/01/2023.
//

import UIKit


class SignInUpViewController: BaseViewController {

    let navBar = NavBarView()
    var signIn = SignInView()
    var signUp = SignUpView()
    
    
    
    
    // MARK: - End
    deinit {
        self.signIn.removeKeyboardObservers()
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("User account")

            self.buildContent()
            CustomNavController.shared.hidePanelAndButtonWithAnimation()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.signIn.buildInto(view: self.view)
        self.signIn.delegate = self
        self.signUp.buildInto(view: self.view)
        self.signUp.delegate = self
        self.signUp.hide()
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.navBar.refreshDisplayMode()
        self.signIn.refreshDisplayMode()
    }

}

extension SignInUpViewController: SignInViewDelegate, SignUpViewDelegate {
    
    // Sign in
    func SignInViewOnTabTap() {
        self.signIn.hide()
        self.signUp.show()
    }
    
    func SignInViewShowLoading(state: Bool) {
        if(state) {
            self.showLoading()
        } else {
            self.hideLoading()
        }
        
    }
    
    func SignInOnSocialButtonTap(index: Int) {
        self.onSocialButtonTap(index)
    }
    
    // Sign up
    func SignUpViewOnTabTap() {
        self.signIn.show()
        self.signUp.hide()
    }
    
    func SignUpViewShowLoading(state: Bool) {
        if(state) {
            self.showLoading()
        } else {
            self.hideLoading()
        }
        
    }
    
    func SignUpOnSocialButtonTap(index: Int) {
        self.onSocialButtonTap(index)
    }
    
}

extension SignInUpViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: - Social stuff
extension SignInUpViewController {
    
    func onSocialButtonTap(_ index: Int) {
        switch(index) {
            case 1:
                self.twitterAuth()
            
            case 2:
                self.linkedInAuth()
            
            case 3:
                self.facebookAuth()
            
            default:
                NOTHING()
        }
    }
    
    func twitterAuth() {
        Twitter_SDK.shared.login(vc: self) { (success) in
            if(success) {
                NOTIFY(Notification_reloadMainFeedOnShow)
                WRITE(LocalKeys.user.AUTHENTICATED, value: "YES")
                
                MAIN_THREAD { // UI
                    CustomNavController.shared.menu.updateLogout()
                    CustomNavController.shared.popViewController(animated: true) // go back to main feed
                }
            }
        }
    }
    
    func linkedInAuth() {
        LinkedIn_SDK.shared.login(vc: self) { (success) in
            if(success) {
                NOTIFY(Notification_reloadMainFeedOnShow)
                WRITE(LocalKeys.user.AUTHENTICATED, value: "YES")
                
                MAIN_THREAD { // UI
                    CustomNavController.shared.menu.updateLogout()
                    CustomNavController.shared.popViewController(animated: true) // go back to main feed
                }
            }
        }
    }
    
    func facebookAuth() {
        Facebook_SDK.shared.login(vc: self) { (success) in
            if(success) {
                NOTIFY(Notification_reloadMainFeedOnShow)
                WRITE(LocalKeys.user.AUTHENTICATED, value: "YES")
                
                MAIN_THREAD { // UI
                    CustomNavController.shared.menu.updateLogout()
                    CustomNavController.shared.popViewController(animated: true) // go back to main feed
                }
            }
        }
    }
    
}
