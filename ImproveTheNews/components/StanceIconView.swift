//
//  StanceIconView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 14/09/2022.
//

import UIKit


protocol StanceIconViewDelegate: AnyObject {
    func onStanceIconTap(sender: StanceIconView)
}

class StanceIconView: UIView {

    private let DIM: CGFloat = 28
    weak var delegate: StanceIconViewDelegate?

    let slider1 = UIView()
    let slider2 = UIView()
    var thumb1LeadingConstraint: NSLayoutConstraint?
    var thumb2LeadingConstraint: NSLayoutConstraint?
    
    private var value1: Int = 1
    private var value2: Int = 1
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.layer.cornerRadius = (DIM/2)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: DIM),
            self.heightAnchor.constraint(equalToConstant: DIM)
        ])
        
        slider1.backgroundColor = UIColor(hex: 0x93A0B4)
        self.addSubview(slider1)
        slider1.activateConstraints([
            slider1.widthAnchor.constraint(equalToConstant: 15),
            slider1.heightAnchor.constraint(equalToConstant: 1),
            slider1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            slider1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5)
        ])
        
        let thumb1 = UIView()
        thumb1.layer.cornerRadius = 3.5
        thumb1.backgroundColor = .orange
        slider1.addSubview(thumb1)
        thumb1.activateConstraints([
            thumb1.widthAnchor.constraint(equalToConstant: 7),
            thumb1.heightAnchor.constraint(equalToConstant: 7),
            thumb1.centerYAnchor.constraint(equalTo: slider1.centerYAnchor)
        ])
        self.thumb1LeadingConstraint = thumb1.leadingAnchor.constraint(equalTo: slider1.leadingAnchor)
        self.thumb1LeadingConstraint?.isActive = true
        
        // ----------------
        slider2.backgroundColor = UIColor(hex: 0x93A0B4)
        self.addSubview(slider2)
        slider2.activateConstraints([
            slider2.widthAnchor.constraint(equalToConstant: 15),
            slider2.heightAnchor.constraint(equalToConstant: 1),
            slider2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            slider2.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5)
        ])
        
        let thumb2 = UIView()
        thumb2.layer.cornerRadius = 3.5
        thumb2.backgroundColor = .orange
        slider2.addSubview(thumb2)
        thumb2.activateConstraints([
            thumb2.widthAnchor.constraint(equalToConstant: 7),
            thumb2.heightAnchor.constraint(equalToConstant: 7),
            thumb2.centerYAnchor.constraint(equalTo: slider2.centerYAnchor)
        ])
        self.thumb2LeadingConstraint = thumb2.leadingAnchor.constraint(equalTo: slider2.leadingAnchor)
        self.thumb2LeadingConstraint?.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(sender:)))
        self.addGestureRecognizer(tapGesture)
        
        self.setValues(1, 1)
        self.refreshDisplayMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xEAEBEC)
        
        let thumb1 = self.slider1.subviews.first!
        thumb1.backgroundColor = DARK_MODE() ? .white : UIColor(hex: 0xFF643C)
        let thumb2 = self.slider2.subviews.first!
        thumb2.backgroundColor = thumb1.backgroundColor
    }
    
    func setValues(_ value1: Int, _ value2: Int) {
        let mValue1 = value1.clamp(lower: 1, upper: 5)
        let mValue2 = value2.clamp(lower: 1, upper: 5)
        let positions: [CGFloat] = [0, 2, 4, 6, 8]
        
        self.value1 = mValue1
        self.value2 = mValue2
        
        self.thumb1LeadingConstraint?.constant = positions[mValue1-1]
        self.thumb2LeadingConstraint?.constant = positions[mValue2-1]
        
        self.alpha = 1.0
        if(PREFS_SHOW_STANCE_ICONS() == false) {
            self.alpha = 0
        }
        
        self.refreshDisplayMode()
    }
    
    func getValues() -> (Int, Int) {
        return (self.value1, self.value2)
    }
    
    //MARK: Event(s)
    @objc func viewOnTap(sender: UITapGestureRecognizer) {
        print("PREFS_SHOW_STANCE_POPUPS", PREFS_SHOW_STANCE_POPUPS())
        if(PREFS_SHOW_STANCE_POPUPS()) {
            self.delegate?.onStanceIconTap(sender: self)
        }
    }

}
