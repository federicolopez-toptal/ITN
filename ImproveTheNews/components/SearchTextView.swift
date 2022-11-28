//
//  SearchTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/11/2022.
//

import UIKit

protocol SearchTextViewDelegate: AnyObject {
    func SearchTextView_onTextChange(sender: SearchTextView, text: String)
}


class SearchTextView: UIView {

    private let charactersLimit: Int = 28
    weak var delegate: SearchTextViewDelegate?
    private weak var viewController: UIViewController?
    
    let lupa = UIImageView(image: UIImage(named: "navBar.search.dark"))
    let placeHolderLabel = UILabel()
    let searchTextField = UITextField()
    let closeIcon = UIImageView(image: UIImage(named: "menu.close"))
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
        self.backgroundColor = .clear //.green
        viewController.view.addSubview(self)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D2530) : UIColor(hex: 0xEFEFEF)
        self.addSubview(bgColorView)
        self.bgColorViewTrailingConstraint = bgColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -42)
        
        bgColorView.activateConstraints([
            bgColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgColorView.topAnchor.constraint(equalTo: self.topAnchor),
            bgColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.bgColorViewTrailingConstraint!
        ])
        bgColorView.layer.cornerRadius = 4.0
        
        // ----------------------
        self.addSubview(self.closeIcon)
        self.closeIcon.activateConstraints([
            self.closeIcon.widthAnchor.constraint(equalToConstant: 32),
            self.closeIcon.heightAnchor.constraint(equalToConstant: 32),
            self.closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.closeIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: self.closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: self.closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: self.closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: self.closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)

        bgColorView.addSubview(self.lupa)
        self.lupa.activateConstraints([
            self.lupa.leadingAnchor.constraint(equalTo: bgColorView.leadingAnchor, constant: 11),
            self.lupa.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
            self.lupa.widthAnchor.constraint(equalToConstant: 24),
            self.lupa.heightAnchor.constraint(equalToConstant: 24)
        ])

        self.placeHolderLabel.text = "Headlines, stories & article splits"
        self.placeHolderLabel.font = roboto
        self.placeHolderLabel.textColor = UIColor(hex: 0x93A0B4)
        bgColorView.addSubview(self.placeHolderLabel)
        self.placeHolderLabel.activateConstraints([
            self.placeHolderLabel.leadingAnchor.constraint(equalTo: self.lupa.trailingAnchor, constant: 4),
            self.placeHolderLabel.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
        ])

        self.searchTextField.font = roboto
        self.searchTextField.textColor = UIColor(hex: 0xFF643C)
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
            self.searchTextField.leadingAnchor.constraint(equalTo: self.lupa.trailingAnchor, constant: 4),
            self.searchTextField.centerYAnchor.constraint(equalTo: bgColorView.centerYAnchor),
            self.searchTextField.trailingAnchor.constraint(equalTo: bgColorView.trailingAnchor, constant: -42)
        ])
        self.searchTextField.addTarget(self, action: #selector(onSearchTextChange(_:)), for: .editingChanged)
        self.searchTextField.delegate = self
    }
    
    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton) {
        if(self.searchTextField.text!.isEmpty) {
            self.viewController?.dismiss(animated: true)
        } else {
            self.searchTextField.text = ""
        }
        
        self.onSearchTextChange(self.searchTextField)
    }

}

extension SearchTextView: UITextFieldDelegate {

    // Text changed
    @objc func onSearchTextChange(_ sender: UITextField) {
        var trailing: CGFloat = 0
        
        if(sender.text!.isEmpty) {
            self.placeHolderLabel.show()
            self.lupa.image = UIImage(named: "navBar.search.dark")
            self.closeIcon.image = UIImage(named: "menu.close")
            trailing = -42
        } else {
            self.placeHolderLabel.hide()
            self.lupa.image = UIImage(named: "navBar.search.dark")?.withRenderingMode(.alwaysTemplate)
            self.lupa.tintColor = UIColor(hex: 0xFF643C)
            self.closeIcon.image = UIImage(named: "menu.close")?.withRenderingMode(.alwaysTemplate)
            self.closeIcon.tintColor = UIColor(hex: 0xFF643C)
            trailing = 0
        }
        
        self.bgColorViewTrailingConstraint?.constant = trailing
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        self.delegate?.SearchTextView_onTextChange(sender: self, text: sender.text!)
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
