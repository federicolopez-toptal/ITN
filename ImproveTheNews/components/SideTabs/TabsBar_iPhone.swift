//
//  TabsBar_iPhone.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/06/2024.
//

import Foundation
import UIKit


class TabsBar_iPhone: TabsBar {
    
    static let HEIGHT: CGFloat = 80
    private let itemsCount: CGFloat = 4
    private var currentTab: Int = 1
    var tabsTopConstraint: NSLayoutConstraint?
    
    override func buildInto(_ containerView: UIView) {
//        self.backgroundColor = .systemPink //.withAlphaComponent(0.25)
        self.backgroundColor = CSS.shared.displayMode().main_bgColor

        containerView.addSubview(self)
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: IPHONE_bottomOffset() * -1)
        ])
        
        self.addtabs()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.subviews.first!.backgroundColor = self.backgroundColor
        
        for i in 1...Int(self.itemsCount) {
            let iconLabel = self.viewWithTag(30 + i) as! UILabel
            iconLabel.textColor = CSS.shared.displayMode().main_textColor
        }
        
        self.selectTab(self.currentTab)
    }
    
    func addtabs() {
        let itemDim: CGFloat = 32
        let _W = SCREEN_SIZE().width - (26 * 2.5)
        let itemSep: CGFloat = (_W - (itemDim * self.itemsCount)) / 3
        
        
        let hContainer = UIView()
//        hContainer.backgroundColor = .green
        hContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(hContainer)
        hContainer.activateConstraints([
            hContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hContainer.heightAnchor.constraint(equalToConstant: itemDim+16),
            hContainer.widthAnchor.constraint(equalToConstant: _W)
        ])
        self.tabsTopConstraint = hContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        self.tabsTopConstraint?.isActive = true
        
        var offset: CGFloat = 0 //itemSep
        for i in 1...Int(self.itemsCount) {
            let iconName = self.iconName(i, false)
            
            let iconImageView = UIImageView(image: UIImage(named: iconName))
            //iconImageView.backgroundColor = .black.withAlphaComponent(0.1)
            hContainer.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.topAnchor.constraint(equalTo: hContainer.topAnchor),
                iconImageView.leadingAnchor.constraint(equalTo: hContainer.leadingAnchor, constant: offset),
                iconImageView.widthAnchor.constraint(equalToConstant: itemDim),
                iconImageView.heightAnchor.constraint(equalToConstant: itemDim)
            ])
            iconImageView.tag = 20 + i
            
            let iconLabel = UILabel()
            iconLabel.textAlignment = .center
            iconLabel.text = self.titleForItem(at: i)
            iconLabel.font = AILERON(10)
            iconLabel.textColor = CSS.shared.displayMode().main_textColor
            hContainer.addSubview(iconLabel)
            iconLabel.activateConstraints([
                iconLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 0),
                iconLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor)
            ])
            iconLabel.tag = 30 + i
            
            let button = UIButton(type: .custom)
            //button.backgroundColor = .red.withAlphaComponent(0.25)
            button.tag = i
            
            hContainer.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
                button.topAnchor.constraint(equalTo: iconImageView.topAnchor),
                button.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
                button.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)
            
            // ----------------------------
            offset += itemDim + itemSep
        }
        
        self.selectTab(1)
    }
    
    func iPhone_yOffset_fix() {
        if let _bottom = SAFE_AREA()?.bottom {
            if(_bottom == 0) {
                self.tabsTopConstraint?.constant = (TabsBar_iPhone.HEIGHT-(32+16))/2
            } else {
                self.tabsTopConstraint?.constant = 7
            }
        }
    }
    
    @objc func tabButtonOnTap(_ sender: UIButton?) {
        let index = sender!.tag
        self.selectTab(index, loadContent: true)
    }
     
    override func selectTab(_ index: Int, loadContent: Bool = false) {
        for i in 1...Int(self.itemsCount) {
            let iconImageView = self.viewWithTag(20 + i) as! UIImageView
            if(i==index) {
                iconImageView.image = UIImage(named: self.iconName(i, true))
            } else {
                iconImageView.image = UIImage(named: self.iconName(i, false))
            }
        }
        
        self.currentTab = index
        
        if(loadContent) {
            switch(index) {
                case 1:
                    CustomNavController.shared.loadHeadlines()
                case 2:
                    CustomNavController.shared.loadControversies()
                case 3:
                    CustomNavController.shared.loadPublicFigures()
                case 4:
                    CustomNavController.shared.loadNewsSliders()
            
                default:
                    NOTHING()
            }
        }
    }
    
    func iconName(_ index: Int, _ state: Bool) -> String {
        var result = "iPhone.tab.0\(index)"
        if(state){ result += "_ON" }
        else {
            result += DARK_MODE() ? ".dark" : ".bright"
        }
          
        return result
    }
    
    func titleForItem(at index: Int) -> String {
        switch(index) {
            case 1:
                return "Headlines"
            case 2:
                return "Controversies"
            case 3:
                return "Public Figures"
            case 4:
                return "New Slider"
                
            default:
                return ""
        }
    }
    
    
}

// ----------------------------------------------------------
func IPHONE_bottomOffset(multiplier: CGFloat = -1) -> CGFloat {
    var offset: CGFloat = 0
    if(IPHONE()) {
        offset = TabsBar_iPhone.HEIGHT
        offset *= multiplier
    }
    return offset
}
