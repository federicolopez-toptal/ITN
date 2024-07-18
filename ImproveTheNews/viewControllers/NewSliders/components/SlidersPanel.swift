//
//  SlidersPanel.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/07/2024.
//

import UIKit


// ---------------------------------------------
protocol SlidersPanelDelegate: AnyObject {
    func slidersPanelOnRefresh(sender: SlidersPanel)
}

// ---------------------------------------------
class SlidersPanel: UIView {
    weak var delegate: SlidersPanelDelegate?
    
    let floatingButton = FloatingButton()
    var heightConstraint: NSLayoutConstraint?
    var currentRows: Int = 0
    
    let margin: CGFloat = 28
    let rowHeight: CGFloat = 90
    let rowSep: CGFloat = 5
    var rowsVStack = UIStackView()
    
    let titles = ["Political stance", "Establishment stance", "Writing style", "Depth", "Shelf-life", "Recency"]
    let legends = [("Left", "Right"), ("Critical", "Pro"), ("Provocative", "Nuanced"), ("Breezy", "Detailed"), ("Short", "Long"), ("Evergreen", "Latest")]
    
    var split: Int = 0
    
    let moreButton = UIButton()
    let refreshButton = UIButton()
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    var contentViewHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ containerView: UIView, bottomRefView: UIView) {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : .white
        
        containerView.addSubview(self)
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        
        self.layer.cornerRadius = 8
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if(IPHONE()) {
            self.activateConstraints([
                self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                self.heightConstraint!,
                self.bottomAnchor.constraint(equalTo: bottomRefView.bottomAnchor)
            ])
        } else {
            self.activateConstraints([
                self.widthAnchor.constraint(equalToConstant: 400),
                self.heightConstraint!,
                self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
        self.addSubview(self.scrollView)
        self.scrollView.backgroundColor = self.backgroundColor
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.margin-10),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.margin+25),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.margin),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.margin-40-14)
        ])
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = self.backgroundColor
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        self.contentViewHeightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 100)
        self.contentViewHeightConstraint?.priority = .defaultLow
        self.contentViewHeightConstraint?.isActive = true
        
        
        
        
        
        self.floatingButton.delegate = self
        self.floatingButton.buildInto(containerView)
        self.floatingButton.activateConstraints([
            self.floatingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.floatingButton.bottomAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        self.addContent()
        self.addMoreButton()
        self.refreshDisplayMode()
        
        self.showRows(2)

        // split value
        if let _split = READ(LocalKeys.sliders.split) {
            self.split = Int(_split)!
            self.checkSplitComponents()
        }
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : .white
        self.scrollView.backgroundColor = self.backgroundColor
        self.contentView.backgroundColor = self.backgroundColor
        self.rowsVStack.backgroundColor = self.backgroundColor
        
        for (j, rowView) in self.rowsVStack.arrangedSubviews.enumerated() {
            rowView.backgroundColor = self.backgroundColor
            
            for (i, v) in rowView.subviews.enumerated() {
                if let label = v as? UILabel {
                    if(i==0) { // title label
                        label.textColor = CSS.shared.displayMode().main_textColor
                    }
                    
                    if((j==0 || j==1)) {
                        if(i==1) { // split label
                            label.textColor = CSS.shared.displayMode().main_textColor
                        } else if(i==6 || i==7) { // left/right (+split)
                            label.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
                        }
                    } else {
                        if(i==1 || i==2) { // left/right label
                            label.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
                        }
                    }
                } else if let slider = v as? UISlider {
                    slider.minimumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                    slider.maximumTrackTintColor = slider.minimumTrackTintColor
                }
            }
        }
    }
    
    func showRows(_ count: Int, animate: Bool = false) {
        self.currentRows = count
        let extra: CGFloat = (self.margin * 3) + 40
        
        var topValue = 0
        var H: CGFloat = 0
        var DIR: ArrowDirection = .up
        var moreButtonTitle = ""
        
        H = (self.rowHeight * CGFloat(count)) + (rowSep * CGFloat(count-1)) + extra
        if(count==0) {
            DIR = .up
            self.moreButton.hide()
            self.refreshButton.hide()
        } else if(count==2) {
            topValue = 2
            DIR = .down
            moreButtonTitle = "More preferences"
        } else if(count==6) {
            topValue = 6
            DIR = .down
            moreButtonTitle = "Less preferences"
            
            if(IPHONE()) {
                H = (self.rowHeight * 4) + (rowSep * 4) + extra - 6
            }
        }
        if(count==0){ H=0 }
        
        self.moreButton.setTitle(moreButtonTitle, for: .normal)
        if(animate) {
            self.heightConstraint?.constant = H
            UIView.animate(withDuration: 0.3) {
                self.superview!.layoutIfNeeded()
            } completion: { _ in
                self.floatingButton.pointTo(direction: DIR)
                self.setRowsVisible(topValue)
                
                if(count>0) {
                    self.moreButton.show()
                    self.refreshButton.show()
                }
            }
        } else {
            self.heightConstraint?.constant = H
            self.floatingButton.pointTo(direction: DIR)
            self.setRowsVisible(topValue)
            
            if(count>0) {
                self.moreButton.show()
                self.refreshButton.show()
            }
        }
        
        self.contentViewHeightConstraint?.constant = 200
        
        //self.scrollView.contentSize = CGSize(width: SCREEN_SIZE().width-(self.margin*2), height: H)
    }
    
    func setRowsVisible(_ count: Int) {
        for (i, v) in self.rowsVStack.arrangedSubviews.enumerated() {
            if(i<count) {
                v.show()
            } else {
                v.hide()
            }
        }
    }
    
    func reloadSliderValues() {
    
        for i in 0...5 {
            var sliderValue = LocalKeys.sliders.defaultValues[i]
            if let _value = READ(LocalKeys.sliders.allKeys[i]) {
                sliderValue = Int(_value)!
            }
            
            let slider = self.viewWithTag(20 + i) as! UISlider
            slider.setValue(Float(sliderValue), animated: true)
        }
    
        
    }
}

extension SlidersPanel: FloatingButtonDelegate {
    
    func floatingButtonOnTap(sender: FloatingButton) {
        if(self.currentRows == 2) {
            self.showRows(0, animate: true)
        } else if(self.currentRows == 0) {
            self.showRows(2, animate: true)
        } else if(self.currentRows == 6) {
            self.showRows(0, animate: true)
        }
    }
    
}
