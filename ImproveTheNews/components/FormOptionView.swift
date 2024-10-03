//
//  FormOptionView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/10/2024.
//

import Foundation
import UIKit


protocol FormOptionViewDelegate: AnyObject {
    func FormOptionViewOnSelected(sender: FormOptionView)
}

class FormOptionView: UIView {
    
    weak var delegate: FormOptionViewDelegate?
    
    private let textLabel = UILabel()
    private var value: Int = 0
    private let dot = UIView()
    
    // MARK: Set(s)
    func setValue(_ newValue: Int) {
        self.value = newValue
    }
    func getValue() -> Int {
        return self.value
    }
    
    func setText(_ newText: String) {
        self.textLabel.text = newText
    }
    
    func setState(_ state: Bool) {
        self.dot.isHidden = !state
    }
    
    // MARK: Init(s)
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .clear //.orange.withAlphaComponent(0.2)
        self.activateConstraints([
            self.heightAnchor.constraint(equalToConstant: 24),
            self.widthAnchor.constraint(equalToConstant: 200)
        ])
           
        let circleBackground = UIView()
        circleBackground.layer.cornerRadius = 12
        circleBackground.layer.borderWidth = 2.0
        circleBackground.layer.borderColor = CSS.shared.displayMode().main_textColor.cgColor
        circleBackground.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(circleBackground)
        circleBackground.activateConstraints([
            circleBackground.widthAnchor.constraint(equalToConstant: 24),
            circleBackground.heightAnchor.constraint(equalToConstant: 24),
            circleBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.addSubview(self.textLabel)
        self.textLabel.text = "Lorem Ipsum"
        self.textLabel.font = AILERON_resize(15)
        self.textLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        self.addSubview(self.textLabel)
        self.textLabel.activateConstraints([
            self.textLabel.leadingAnchor.constraint(equalTo: circleBackground.trailingAnchor, constant: 10),
            self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.dot.backgroundColor = CSS.shared.displayMode().main_textColor
        self.dot.layer.cornerRadius = 6
        circleBackground.addSubview(self.dot)
        self.dot.activateConstraints([
            self.dot.widthAnchor.constraint(equalToConstant: 12),
            self.dot.heightAnchor.constraint(equalToConstant: 12),
            self.dot.centerXAnchor.constraint(equalTo: circleBackground.centerXAnchor),
            self.dot.centerYAnchor.constraint(equalTo: circleBackground.centerYAnchor)
        ])
        
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.topAnchor.constraint(equalTo: self.topAnchor),
            buttonArea.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        buttonArea.addTarget(self, action: #selector(self.buttonAreaOnTap(_:)), for: .touchUpInside)
        
        self.setState(false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAreaOnTap(_ sender: UIButton) {
        self.delegate?.FormOptionViewOnSelected(sender: self)
    }
}
