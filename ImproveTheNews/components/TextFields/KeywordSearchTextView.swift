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
    
    let lupa = UIImageView(image: UIImage(named: DisplayMode.imageName("lupa2")))
    let placeHolderLabel = UILabel()
    let searchTextField = UITextField()
    //let closeIcon = UIImageView(image: UIImage(named: "menu.close")!.withRenderingMode(.alwaysTemplate))

    
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
        bgColorView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        self.addSubview(bgColorView)
        bgColorView.activateConstraints([
            bgColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgColorView.topAnchor.constraint(equalTo: self.topAnchor),
            bgColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bgColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        bgColorView.layer.cornerRadius = 24
        
        bgColorView.addSubview(self.lupa)
        self.lupa.activateConstraints([
            self.lupa.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -9),
            self.lupa.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
            self.lupa.widthAnchor.constraint(equalToConstant: 32),
            self.lupa.heightAnchor.constraint(equalToConstant: 32)
        ])
        //self.lupa.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.75) : UIColor(hex: 0x1D242F)
                
        self.placeHolderLabel.text = "Search topics" // "Headlines, stories & article splits"
        self.placeHolderLabel.font = AILERON(16)
        self.placeHolderLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.placeHolderLabel.alpha = 0.5
        
        bgColorView.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: bgColorView.leadingAnchor, constant: 24),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
        ])
        
        self.searchTextField.font = self.placeHolderLabel.font
        self.searchTextField.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.searchTextField.tintColor = self.searchTextField.textColor
        self.searchTextField.returnKeyType = .done
        self.searchTextField.autocapitalizationType = .none
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.smartDashesType = .no
        self.searchTextField.smartInsertDeleteType = .no
        self.searchTextField.smartQuotesType = .no
        self.searchTextField.spellCheckingType = .no
        self.searchTextField.keyboardType = .asciiCapable
        bgColorView.addSubview(self.searchTextField)
        self.searchTextField.activateConstraints([
            self.searchTextField.leadingAnchor.constraint(equalTo: bgColorView.leadingAnchor, constant: 24),
            self.searchTextField.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -42),
            self.searchTextField.topAnchor.constraint(equalTo: bgColorView.topAnchor),
            self.searchTextField.bottomAnchor.constraint(equalTo: bgColorView.bottomAnchor)
        ])
        self.searchTextField.addTarget(self, action: #selector(onSearchTextChange(_:)), for: .editingChanged)
        self.searchTextField.delegate = self
        //self.searchTextField.backgroundColor = .red
        
//        bgColorView.addSubview(self.closeIcon)
//        self.closeIcon.activateConstraints([
//            self.closeIcon.widthAnchor.constraint(equalToConstant: 25),
//            self.closeIcon.heightAnchor.constraint(equalToConstant: 25),
//            self.closeIcon.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -8),
//            self.closeIcon.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor)
//        ])
//        self.closeIcon.tintColor = UIColor(hex: 0xDA4933)
//        self.closeIcon.hide()
//        
//        let closeButton = UIButton(type: .system)
//        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
//        bgColorView.addSubview(closeButton)
//        closeButton.activateConstraints([
//            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
//            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
//            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
//            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
//        ])
//        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
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
            //self.lupa.image = UIImage(named: "navBar.search.dark")
            //self.closeIcon.hide()
        } else {
            self.placeHolderLabel.hide()
            //self.lupa.image = UIImage(named: "navBar.search.dark")?.withRenderingMode(.alwaysTemplate)
            //self.lupa.tintColor = UIColor(hex: 0xDA4933)
            //self.closeIcon.show()
        }
        
        self.delegate?.KeywordSearchTextView_onTextChange(sender: self, text: sender.text!)
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        HIDE_KEYBOARD(view: self)
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
