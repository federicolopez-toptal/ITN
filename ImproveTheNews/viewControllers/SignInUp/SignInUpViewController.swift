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
    //    let emailText = FilterTextView()
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back])

            self.buildContent()
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
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
    
    // MARK: - DeInit
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CustomNavController.shared.slidersPanel.show()
        CustomNavController.shared.floatingButton.show()
    }

}

extension SignInUpViewController: SignInViewDelegate, SignUpViewDelegate {
    
    func SignInViewOnTabTap() {
        self.signIn.hide()
        self.signUp.show()
    }
    
    func SignUpViewOnTabTap() {
        self.signIn.show()
        self.signUp.hide()
    }
    
}
