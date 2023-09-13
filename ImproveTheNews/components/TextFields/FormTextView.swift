//
//  FormTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/02/2023.
//

import UIKit

protocol FormTextViewDelegate: AnyObject {
    func FormTextView_onTextChange(sender: FormTextView, text: String)
    func FormTextView_onReturnTap(sender: FormTextView)
}


class FormTextView: UIView {

    var charactersLimit: Int = 20
    weak var delegate: FormTextViewDelegate?
//    private weak var viewController: UIViewController?

    let placeHolderLabel = UILabel()
    let mainTextField = UITextField()
    let closeIcon = UIImageView(image: UIImage(named: "menu.close"))
    let closeButton = UIButton(type: .system)
    var bgColorViewTrailingConstraint: NSLayoutConstraint?

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildInto(vstack: UIStackView) {
        vstack.addArrangedSubview(self)
        self.activateConstraints([
            self.heightAnchor.constraint(equalToConstant: 44)
        ])

        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E1E1E) : .white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = DARK_MODE() ? UIColor(hex: 0xBBBBBB).withAlphaComponent(0.5).cgColor : UIColor(hex: 0xBBBBBB).cgColor

        self.placeHolderLabel.text = "Example text"
        self.placeHolderLabel.textColor = .yellow
        self.placeHolderLabel.font = ROBOTO(14)
        self.placeHolderLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBBBB).withAlphaComponent(0.5) : UIColor(hex: 0xBBBBBB)
        self.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        self.mainTextField.font = ROBOTO(14)
        self.mainTextField.textColor = .white
        self.mainTextField.tintColor = .white
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
            self.mainTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.mainTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.mainTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
        self.mainTextField.addTarget(self, action: #selector(onFormTextChange(_:)), for: .editingChanged)
        self.mainTextField.delegate = self

        self.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 32),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 32),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            self.closeIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.closeIcon.hide()

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
    
    
}

// MARK: misc
extension FormTextView {

    func text() -> String {
        return self.mainTextField.text!
    }
    
    func setText(_ T: String) {
        self.mainTextField.text = T
        self.onFormTextChange(self.mainTextField)
    }

    func focus() {
        self.mainTextField.becomeFirstResponder()
    }

    func customize(keyboardType: UIKeyboardType, returnType: UIReturnKeyType,
        charactersLimit: Int, placeHolderText: String, textColor: UIColor) {
        self.mainTextField.keyboardType = keyboardType
        self.mainTextField.returnKeyType = returnType
        self.charactersLimit = charactersLimit
        self.placeHolderLabel.text = placeHolderText
        self.mainTextField.textColor = textColor
        self.mainTextField.tintColor = textColor
    }
    
    func setPasswordMode(_ state: Bool) {
        self.mainTextField.isSecureTextEntry = state
    }
    
    func setEnabled(_ state: Bool) {
        self.mainTextField.isEnabled = state
    }

}


extension FormTextView {

    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.mainTextField.text = ""
        self.onFormTextChange(self.mainTextField)
    }
    
}


// MARK: - UITextFieldDelegate
extension FormTextView: UITextFieldDelegate {

    // Text changed
    @objc func onFormTextChange(_ sender: UITextField) {
        
        if(sender.text!.isEmpty) {
            self.placeHolderLabel.show()
            //self.closeIcon.hide()
            //self.closeButton.hide()
        } else {
            self.placeHolderLabel.hide()
            //self.closeIcon.show()
            //self.closeButton.show()
        }
                
        self.delegate?.FormTextView_onTextChange(sender: self, text: sender.text!)
    }
//    
//    // Search button tap
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        HIDE_KEYBOARD(view: self)
//        return true
//    }
//    
    // characters limit
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= charactersLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.FormTextView_onReturnTap(sender: self)
        return true
    }

}
