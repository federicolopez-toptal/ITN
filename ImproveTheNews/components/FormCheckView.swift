//
//  FormCheckView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/01/2024.
//

import Foundation
import UIKit

class FormCheckView: UIView {

    private var heightConstraint: NSLayoutConstraint?

    private var _status = false
    var status: Bool {
        get {
            return self._status
        }
        set {
            self._status = newValue
            self.refreshComponent()
        }
    }

    private let mainLabel = UILabel()
    var text: String {
        get {
            return self.mainLabel.text!
        }
        set {
            self.mainLabel.text = newValue
        }
    }
    
    private var checkMark = UIImageView()


    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
           
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 24)
        self.heightConstraint?.isActive = true

        let square = UIView()
        square.layer.cornerRadius = 4.0
        square.layer.borderWidth = 1.0
        square.layer.borderColor = UIColor(hex: 0x2D2D31).cgColor
        square.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(square)
        square.activateConstraints([
            square.widthAnchor.constraint(equalToConstant: 24),
            square.heightAnchor.constraint(equalToConstant: 24),
            square.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            square.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.checkMark.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        self.checkMark.tintColor = UIColor(hex: 0x60C4D6)
        self.addSubview(self.checkMark)
        self.checkMark.activateConstraints([
            self.checkMark.widthAnchor.constraint(equalToConstant: 24),
            self.checkMark.heightAnchor.constraint(equalToConstant: 24),
            self.checkMark.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: 3),
            self.checkMark.topAnchor.constraint(equalTo: square.topAnchor, constant: -3)
        ])
        
        self.mainLabel.font = AILERON_resize(16)
        //self.mainLabel.numberOfLines = 2
        self.mainLabel.textColor = UIColor(hex: 0xBBBDC0)
        self.mainLabel.text = "Check component text"
        self.addSubview(self.mainLabel)
        self.mainLabel.activateConstraints([
            self.mainLabel.leadingAnchor.constraint(equalTo: square.trailingAnchor, constant: 10),
            self.mainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.topAnchor.constraint(equalTo: self.topAnchor),
            buttonArea.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: self.mainLabel.trailingAnchor, constant: 10)
        ])
        buttonArea.addTarget(self, action: #selector(buttonAreaOnTap(_:)), for: .touchUpInside)

        self.refreshComponent()
        self.refreshDisplayMode()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    @objc func buttonAreaOnTap(_ sender: UIButton) {
        self.status = !self.status
    }
    
    private func refreshComponent() {
        self.checkMark.isHidden = !self._status
    }
    
}
