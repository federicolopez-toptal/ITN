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
    
    let lupa = UIImageView(image: UIImage(named: "navBar.search.dark"))
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
    
    // MARK: - misc
    func buildInto(viewController: UIViewController) {
        
        let roboto = ROBOTO(14)
        
        self.viewController = viewController
        self.backgroundColor = .clear
        viewController.view.addSubview(self)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x2B3747).cgColor : UIColor(hex: 0xB4BDCA).cgColor
        
        self.placeHolderLabel.text = "Example text"
        self.placeHolderLabel.textColor = .yellow
        self.placeHolderLabel.font = roboto
        self.placeHolderLabel.textColor = UIColor(hex: 0x93A0B4)
        self.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        self.mainTextField.font = roboto
        self.mainTextField.textColor = UIColor(hex: 0xFF643C)
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
        self.mainTextField.addTarget(self, action: #selector(onFilterTextChange(_:)), for: .editingChanged)
        self.mainTextField.delegate = self
        
        self.addSubview(self.lupa)
        self.lupa.activateConstraints([
            self.lupa.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            self.lupa.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.lupa.widthAnchor.constraint(equalToConstant: 24),
            self.lupa.heightAnchor.constraint(equalToConstant: 24)
        ])
        
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
            self.lupa.show()
            self.closeIcon.hide()
            self.closeButton.hide()
        } else {
            self.placeHolderLabel.hide()
            self.lupa.hide()
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
