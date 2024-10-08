//
//  ResetPassViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/05/2023.
//

import UIKit

class ResetPassViewController: BaseViewController {

    let navBar = NavBarView()

    let scrollView = UIScrollView()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    let contentView = UIView()
    var VStack: UIStackView!

    let emailText = FormTextView()
    let mainActionButton = UIButton(type: .custom)


    // MARK: - End
    deinit {
        self.hideLoading()
        self.removeKeyboardObservers()
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
            self.navBar.addBottomLine()
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollViewBottomConstraint
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        H.priority = .defaultLow

        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .green
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.yellow
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            //self.VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        self.buildForm()
        self.addKeyboardObservers()
        self.refreshDisplayMode()
    }
    
    private func buildForm() {
        var extraHMargin: CGFloat = 0
        if(IPAD()){ extraHMargin += 150 }
    
        ADD_SPACER(to: self.VStack, height: IPHONE() ? 32 : 60)
    
        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16+extraHMargin)
        let VStack_form = VSTACK(into: HStack_form)
        //VStack_form.backgroundColor = .green
        ADD_SPACER(to: HStack_form, width: 20+extraHMargin)

        let titleLabel = UILabel()
        titleLabel.text = "Forgot Password"
        titleLabel.font = DM_SERIF_DISPLAY_resize(23)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        let blablaLabel = UILabel()
        blablaLabel.numberOfLines = 0
        blablaLabel.text = "Enter your email address below to reset your password."
        blablaLabel.font = AILERON_resize(16)
        blablaLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(blablaLabel)
        ADD_SPACER(to: VStack_form, height: 32)
        
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = AILERON_resize(16)
        emailLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        VStack_form.addArrangedSubview(emailLabel)
        ADD_SPACER(to: VStack_form, height: 16)
        
        self.emailText.buildInto(vstack: VStack_form)
        self.emailText.customize(keyboardType: .emailAddress, returnType: .done,
            charactersLimit: 50, placeHolderText: "Your Email", textColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C) )
        self.emailText.delegate = self
        ADD_SPACER(to: VStack_form, height: 24)
        
        self.mainActionButton.backgroundColor = UIColor(hex: 0x60C4D6)
        self.mainActionButton.layer.cornerRadius = 4.0
        VStack_form.addArrangedSubview(self.mainActionButton)
        mainActionButton.activateConstraints([
            self.mainActionButton.heightAnchor.constraint(equalToConstant: 52)
        ])
        self.mainActionButton.addTarget(self, action: #selector(mainActionButtonTap(_:)), for: .touchUpInside)
        ADD_SPACER(to: VStack_form, height: 32)
        
        let mainActionLabel = UILabel()
        mainActionLabel.text = "Reset password"
        mainActionLabel.textColor = UIColor(hex: 0x19191C)
        mainActionLabel.font = AILERON_SEMIBOLD(16)
        VStack_form.addSubview(mainActionLabel)
        mainActionLabel.activateConstraints([
            mainActionLabel.centerXAnchor.constraint(equalTo: self.mainActionButton.centerXAnchor),
            mainActionLabel.centerYAnchor.constraint(equalTo: self.mainActionButton.centerYAnchor)
        ])
        
        let questionLabel = UILabel()
        questionLabel.font = AILERON_resize(16)
        questionLabel.textAlignment = .center
        questionLabel.text = "Click here to sign up!"
        questionLabel.textColor = UIColor(hex: 0xDA4933)
        questionLabel.addUnderline()
        VStack_form.addArrangedSubview(questionLabel)
        ADD_SPACER(to: VStack_form, height: 32)
        
        let questionButton = UIButton(type: .custom)
        questionButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        VStack_form.addSubview(questionButton)
        questionButton.activateConstraints([
            questionButton.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            questionButton.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            questionButton.topAnchor.constraint(equalTo: questionLabel.topAnchor),
            questionButton.bottomAnchor.constraint(equalTo: questionLabel.bottomAnchor)
        ])
        questionButton.addTarget(self, action: #selector(questionButtonOnTap(_:)), for: .touchUpInside)
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.navBar.refreshDisplayMode()
        
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        
//        self.contentView.layer.borderWidth = 6
//        self.contentView.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x28282D).cgColor : UIColor(hex: 0xE2E3E3).cgColor
    }

}


extension ResetPassViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: - Keyboard stuff
extension ResetPassViewController {

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent(n:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardEvent(n: Notification) {
        let H = getKeyboardHeight(fromNotification: n)
        
        if(n.name==UIResponder.keyboardWillShowNotification){
            self.scrollViewBottomConstraint.constant = 0 - H
        } else if(n.name==UIResponder.keyboardWillHideNotification) {
            self.scrollViewBottomConstraint.constant = 0
        }
        
        self.view.layoutIfNeeded()
    }
    
    func getKeyboardHeight(fromNotification notification: Notification) -> CGFloat {
        if let H = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            return H
        } else {
            return 300
        }
    }

}

// MARK: - Events
extension ResetPassViewController {
    
    @objc func questionButtonOnTap(_ sender: UIButton) {
        for vc in CustomNavController.shared.viewControllers {
            if let _vc = vc as? SignInUpViewController {
                _vc.signIn.tabButtonOnTap(nil)
                break
            }
        }
        
        CustomNavController.shared.popViewController(animated: true)
    }
    
    @objc func mainActionButtonTap(_ sender: UIButton) {
        if(self.emailText.text().isEmpty) {
            CustomNavController.shared.infoAlert(message: "Please, enter your email")
        } else if(!VALIDATE_EMAIL(self.emailText.text())) {
            CustomNavController.shared.infoAlert(message: "Please, enter a valid email")
        } else {
            self.showLoading()
            
            let email = self.emailText.text()
            API.shared.resetPassword(email: email) { (success, serverMsg) in
                if(success) {
                    let msg = "You'll receive an email with instructions to change your password. Just in case, check your spam folder"
                    CustomNavController.shared.infoAlert(message: msg)
                } else {
                    CustomNavController.shared.infoAlert(message: serverMsg)
                }
                
                DELAY(2.0) {
                    self.hideLoading()
                }
            }
        }
    }
    
}

// MARK: - FormTextView
extension ResetPassViewController: FormTextViewDelegate {
    
    func FormTextView_onTextChange(sender: FormTextView, text: String) {
    }
    
    func FormTextView_onReturnTap(sender: FormTextView) {
        if(sender == self.emailText) {
            HIDE_KEYBOARD(view: self.view)
        }
    }
    
}
