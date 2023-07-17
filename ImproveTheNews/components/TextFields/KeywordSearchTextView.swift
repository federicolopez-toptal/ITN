//
//  KeywordSearchTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit


protocol KeywordSearchTextViewDelegate: AnyObject {
    func KeywordSearchTextView_onTextChange(sender: KeywordSearchTextView, text: String)
    func KeywordSearchTextView_onSearchTap(sender: KeywordSearchTextView)
}


class KeywordSearchTextView: UIView {
    
    private let charactersLimit: Int = 28
    weak var delegate: KeywordSearchTextViewDelegate?
    
    let lupa = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.search")))
    let placeHolderLabel = UILabel()
    let searchTextField = UITextField()
    let closeIcon = UIImageView(image: UIImage(named: "menu.close")!.withRenderingMode(.alwaysTemplate))
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(viewController: UIViewController) {
        self.backgroundColor = .clear //.green
        viewController.view.addSubview(self)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x323943) : UIColor(hex: 0xF2F2F2)
        self.addSubview(bgColorView)
        bgColorView.activateConstraints([
            bgColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgColorView.topAnchor.constraint(equalTo: self.topAnchor),
            bgColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bgColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        bgColorView.layer.cornerRadius = 4.0
        
        bgColorView.addSubview(self.lupa)
        self.lupa.activateConstraints([
            self.lupa.leadingAnchor.constraint(equalTo: bgColorView.leadingAnchor, constant: 11),
            self.lupa.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
            self.lupa.widthAnchor.constraint(equalToConstant: 24),
            self.lupa.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let roboto = ROBOTO(14)
        
        self.placeHolderLabel.text = "Search topics" // "Headlines, stories & article splits"
        self.placeHolderLabel.font = roboto
        self.placeHolderLabel.textColor = UIColor(hex: 0x93A0B4)
        bgColorView.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.lupa.trailingAnchor, constant: 4),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
        ])
        
        self.searchTextField.font = roboto
        self.searchTextField.textColor = UIColor(hex: 0xFF643C)
        self.searchTextField.returnKeyType = .search
        self.searchTextField.autocapitalizationType = .none
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.smartDashesType = .no
        self.searchTextField.smartInsertDeleteType = .no
        self.searchTextField.smartQuotesType = .no
        self.searchTextField.spellCheckingType = .no
        self.searchTextField.keyboardType = .asciiCapable
        bgColorView.addSubview(self.searchTextField)
        self.searchTextField.activateConstraints([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.lupa.trailingAnchor, constant: 4),
            self.searchTextField.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
            self.searchTextField.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -42)
        ])
        self.searchTextField.addTarget(self, action: #selector(onSearchTextChange(_:)), for: .editingChanged)
        self.searchTextField.delegate = self
        
        bgColorView.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 25),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 25),
            self.closeIcon.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -8),
            self.closeIcon.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor)
        ])
        self.closeIcon.tintColor = UIColor(hex: 0xFF643C)
        self.closeIcon.hide()
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        bgColorView.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - misc
    func text() -> String {
        return self.searchTextField.text!
    }
}

// MARK: - Event(s)
extension KeywordSearchTextView {
    @objc func onSearchTextChange(_ sender: UITextField) {
    
        if(sender.text!.isEmpty) {
            self.placeHolderLabel.show()
            self.lupa.image = UIImage(named: "navBar.search.dark")
            self.closeIcon.hide()
        } else {
            self.placeHolderLabel.hide()
            self.lupa.image = UIImage(named: "navBar.search.dark")?.withRenderingMode(.alwaysTemplate)
            self.lupa.tintColor = UIColor(hex: 0xFF643C)
            self.closeIcon.show()
        }
        
        self.delegate?.KeywordSearchTextView_onTextChange(sender: self, text: sender.text!)
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.searchTextField.text = ""
        self.onSearchTextChange(self.searchTextField)
    }
}

// MARK: - UITextFieldDelegate
extension KeywordSearchTextView: UITextFieldDelegate {
    // Search button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HIDE_KEYBOARD(view: self)
        self.delegate?.KeywordSearchTextView_onSearchTap(sender: self)
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
