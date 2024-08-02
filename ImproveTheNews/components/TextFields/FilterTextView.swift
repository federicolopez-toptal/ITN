//
//  FilterTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/11/2022.
//

import UIKit

protocol FilterTextViewDelegate: AnyObject {
    func FilterTextView_onTextChange(sender: FilterTextView, text: String)
}


class FilterTextView: UIView {

    private let charactersLimit: Int = 20
    weak var delegate: FilterTextViewDelegate?
    private weak var viewController: UIViewController?
    
    //let lupa = UIImageView(image: UIImage(named: "navBar.search.dark")?.withRenderingMode(.alwaysTemplate))
    let lupa = UIImageView(image: UIImage(named: DisplayMode.imageName("lupa")))
    let placeHolderLabel = UILabel()
    let mainTextField = UITextField()
    let closeIcon = UIImageView(image: UIImage(named: "menu.close")?.withRenderingMode(.alwaysTemplate))
    let closeButton = UIButton(type: .system)
    var bgColorViewTrailingConstraint: NSLayoutConstraint?
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - misc
    func text() -> String {
        return self.mainTextField.text!
    }
    
    func buildInto(viewController: UIViewController) {
        
        let roboto = ROBOTO(14)
        
        self.viewController = viewController
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1e1e21) : UIColor(hex: 0xe9e9e9)
        self.layer.cornerRadius = 64/2
        viewController.view.addSubview(self)
        
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x28282D).cgColor : UIColor(hex: 0xB4BDCA).cgColor
        
        self.placeHolderLabel.text = "Search All"
        self.placeHolderLabel.font = AILERON(16)
        self.placeHolderLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.5) : UIColor(hex: 0x0a0a0d).withAlphaComponent(0.5)
        self.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        self.mainTextField.font = AILERON(16)
        self.mainTextField.textColor = DARK_MODE() ? UIColor(hex: 0xb8babd) : UIColor(hex: 0x0a0a0d)
        self.mainTextField.tintColor = self.mainTextField.textColor
        self.mainTextField.returnKeyType = .done
        self.mainTextField.autocapitalizationType = .none
        self.mainTextField.autocorrectionType = .no
        self.mainTextField.smartDashesType = .no
        self.mainTextField.smartInsertDeleteType = .no
        self.mainTextField.smartQuotesType = .no
        self.mainTextField.spellCheckingType = .no
        self.mainTextField.keyboardType = .asciiCapable
        self.addSubview(self.mainTextField)
        self.mainTextField.activateConstraints([
            self.mainTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            self.mainTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.mainTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27)
        ])
        self.mainTextField.addTarget(self, action: #selector(onFilterTextChange(_:)), for: .editingChanged)
        self.mainTextField.delegate = self
        
        self.addSubview(self.lupa)
        self.lupa.activateConstraints([
            self.lupa.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            self.lupa.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.lupa.widthAnchor.constraint(equalToConstant: 40),
            self.lupa.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.lupa.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.5) : UIColor(hex: 0xBBBDC0)
        
        self.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 32),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 32),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27-40),
            self.closeIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.closeIcon.hide()
        closeIcon.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.5) : UIColor(hex: 0x1D242F).withAlphaComponent(0.5)

        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5),
        ])
        self.closeButton.hide()
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.mainTextField.text = ""
        self.onFilterTextChange(self.mainTextField)
    }

}




extension FilterTextView: UITextFieldDelegate {

    // Text changed
    @objc func onFilterTextChange(_ sender: UITextField) {
        
        if(sender.text!.isEmpty) {
            self.placeHolderLabel.show()
            //self.lupa.show()
            self.closeIcon.hide()
            self.closeButton.hide()
        } else {
            self.placeHolderLabel.hide()
            //self.lupa.hide()
            self.closeIcon.show()
            self.closeButton.show()
        }
                
        self.delegate?.FilterTextView_onTextChange(sender: self, text: sender.text!)
    }
    
    // Search button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HIDE_KEYBOARD(view: self)
        return true
    }
    
    // characters limit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= charactersLimit
    }

}
