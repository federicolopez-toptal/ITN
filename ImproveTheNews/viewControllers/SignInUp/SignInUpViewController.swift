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
    
}

extension SignInUpViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
