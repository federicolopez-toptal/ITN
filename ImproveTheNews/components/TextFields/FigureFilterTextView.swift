//
//  FigureFilterTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/06/2023.
//

import UIKit


protocol FigureFilterTextViewDelegate: AnyObject {
    func FigureFilterTextView_onTextChange(sender: FigureFilterTextView, text: String)
    func FigureFilterTextView_onSearchTap(sender: FigureFilterTextView)
}


class FigureFilterTextView: UIView {
    
    private let charactersLimit: Int = 28
    weak var delegate: FigureFilterTextViewDelegate?
    
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
    
    func buildInto(view: UIView) {
        view.addSubview(self)
        
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191c) : .white
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1.0
        self.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x37383a).cgColor : UIColor(hex: 0xc6c8ca).cgColor
                
        self.placeHolderLabel.text = "Search Public Figures" // "Headlines, stories & article splits"
        self.placeHolderLabel.font = AILERON(16)
        self.placeHolderLabel.textColor = DARK_MODE() ? UIColor(hex: 0x656668) : UIColor(hex: 0x19191C)
        self.placeHolderLabel.alpha = 0.5
        
        self.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.searchTextField.font = self.placeHolderLabel.font
        self.searchTextField.textColor = CSS.shared.displayMode().sec_textColor
        self.searchTextField.tintColor = self.searchTextField.textColor
        self.searchTextField.returnKeyType = .search
        self.searchTextField.autocapitalizationType = .none
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.smartDashesType = .no
        self.searchTextField.smartInsertDeleteType = .no
        self.searchTextField.smartQuotesType = .no
        self.searchTextField.spellCheckingType = .no
        self.searchTextField.keyboardType = .asciiCapable
        self.addSubview(self.searchTextField)
        self.searchTextField.activateConstraints([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 30),
            self.searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.searchTextField.addTarget(self, action: #selector(onSearchTextChange(_:)), for: .editingChanged)
        self.searchTextField.delegate = self
    }
    
    // MARK: - misc
    func text() -> String {
        return self.searchTextField.text!
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 0.5
        self.layer.borderColor = CSS.shared.displayMode().sec_textColor.cgColor
        
        self.placeHolderLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.searchTextField.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.searchTextField.tintColor = self.searchTextField.textColor
    }
}

// MARK: - Event(s)
extension FigureFilterTextView {
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
        
        self.delegate?.FigureFilterTextView_onTextChange(sender: self, text: sender.text!)
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        HIDE_KEYBOARD(view: self)
        self.searchTextField.text = ""
        self.onSearchTextChange(self.searchTextField)
    }
}

// MARK: - UITextFieldDelegate
extension FigureFilterTextView: UITextFieldDelegate {
    // Search button tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HIDE_KEYBOARD(view: self)
        self.delegate?.FigureFilterTextView_onSearchTap(sender: self)
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
