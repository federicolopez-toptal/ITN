//
//  OnOffView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 07/11/2022.
//

import UIKit

protocol OnOffViewDelegate: AnyObject {
    func OnOffView_onValueChanged(sender: OnOffView, newValue: Bool)
}



class OnOffView: UIView {

    private let WIDTH: CGFloat = 48
    private let HEIGHT: CGFloat = 24
    private let BORDER: CGFloat = 2
    
    let thumb = UIView()
    weak var delegate: OnOffViewDelegate?
    var thumbLeadingConstraint: NSLayoutConstraint?
    
    let checkMark = UIImageView()
    let dashMark = UIImageView()
    
    private var _thumbOffColor = UIColor.red
    var thumbOffColor: UIColor {
        get {
            return self._thumbOffColor
        }
        set {
            self._thumbOffColor = newValue
            self.refreshDisplayMode()
        }
    }
    
    private var _thumbOnColor = UIColor.green
    var thumbOnColor: UIColor {
        get {
            return self._thumbOnColor
        }
        set {
            self._thumbOnColor = newValue
            self.refreshDisplayMode()
        }
    }
    
    var _status = false
    var status: Bool {
        get {
            return self._status
        }
        set {
            self._status = newValue
            self.refreshDisplayMode()
            
            if(self._status) {
                self.checkMark.show()
                self.dashMark.hide()
            } else {
                self.checkMark.hide()
                self.dashMark.show()
            }
        }
    }
    
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = self.HEIGHT/2
        self.clipsToBounds = true
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: self.WIDTH),
            self.heightAnchor.constraint(equalToConstant: self.HEIGHT)
        ])
        
        let dim: CGFloat = self.HEIGHT-(self.BORDER*2)
        
        self.addSubview(thumb)
        self.thumb.backgroundColor = self.thumbOffColor
        self.thumb.layer.cornerRadius = dim/2
        self.thumbLeadingConstraint = self.thumb.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.BORDER)
        self.thumb.activateConstraints([
            self.thumb.widthAnchor.constraint(equalToConstant: dim),
            self.thumb.heightAnchor.constraint(equalToConstant: dim),
            self.thumb.topAnchor.constraint(equalTo: self.topAnchor, constant: self.BORDER),
            self.thumbLeadingConstraint!
        ])
        
        checkMark.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        checkMark.tintColor = DARK_MODE() ? UIColor(hex: 0x969697) : .white
        //checkMark.backgroundColor = .white
        self.addSubview(checkMark)
        checkMark.activateConstraints([
            checkMark.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkMark.widthAnchor.constraint(equalToConstant: 18),
            checkMark.heightAnchor.constraint(equalToConstant: 18),
            checkMark.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
        ])
        
        let cfg = UIImage.SymbolConfiguration(weight: .bold)
        dashMark.image = UIImage(systemName: "minus", withConfiguration: cfg)?.withRenderingMode(.alwaysTemplate)
        dashMark.tintColor = .white //DARK_MODE() ? UIColor(hex: 0x68686A) : .white
        self.addSubview(dashMark)
        dashMark.activateConstraints([
            dashMark.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dashMark.widthAnchor.constraint(equalToConstant: 14),
            dashMark.heightAnchor.constraint(equalToConstant: 18),
            dashMark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7)
        ])
        
        
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.3)
        self.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(buttonOnTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Event(s)
    @objc func buttonOnTap(_ sender: UIButton) {
        self._status = !self._status
        
        let colorTo = self._status ? self.thumbOnColor : self.thumbOffColor
        let dim: CGFloat = self.HEIGHT-(self.BORDER*2)
        let leadingTo: CGFloat = self._status ? (self.WIDTH-self.BORDER-dim) : 2
        
        self.thumb.backgroundColor = colorTo
        if(self._status) {
            self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x823129) : UIColor(hex: 0xE6A49D)
            self.checkMark.show()
            self.dashMark.hide()
        } else {
            self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x68686A) : UIColor(hex: 0xA1A2A3)
            self.checkMark.hide()
            self.dashMark.show()
        }
        
        self.thumbLeadingConstraint?.constant = leadingTo
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.thumb.layoutIfNeeded()
        }
        
        self.delegate?.OnOffView_onValueChanged(sender: self, newValue: self.status)
    }
    
    // MARK: - misc
    func refreshDisplayMode() {
        self.thumb.backgroundColor = self._status ? self.thumbOnColor : self.thumbOffColor
        let dim: CGFloat = self.HEIGHT-(self.BORDER*2)
        self.thumbLeadingConstraint?.constant = self._status ? (self.WIDTH-self.BORDER-dim) : 2
    }
}
