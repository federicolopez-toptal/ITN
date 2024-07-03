//
//  TabsBar_iPad.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/06/2024.
//

import Foundation
import UIKit


class TabsBar_iPad: TabsBar {
    
    static let WIDTH: CGFloat = 92
    private let itemsCount: CGFloat = 4
    private var currentTab: Int = 1
    
    override func buildInto(_ containerView: UIView) {
//        self.backgroundColor = .systemPink //.withAlphaComponent(0.25)
        self.backgroundColor = CSS.shared.displayMode().main_bgColor

        containerView.addSubview(self)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            self.widthAnchor.constraint(equalToConstant: TabsBar_iPad.WIDTH)
        ])
        
        self.addtabs()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.subviews.first!.backgroundColor = self.backgroundColor
        self.selectTab(self.currentTab)
    }
    
    func addtabs() {
        let itemDim: CGFloat = 64
        let itemSep: CGFloat = 16
        
        let _H = (itemDim * self.itemsCount) + (itemSep * (self.itemsCount+1))
        
        let vContainer = UIView()
//        vContainer.backgroundColor = .systemPink
        vContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(vContainer)
        vContainer.activateConstraints([
            vContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            vContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
            vContainer.heightAnchor.constraint(equalToConstant: _H),
        ])
        
        var offset: CGFloat = itemSep
        for i in 1...Int(self.itemsCount) {
            let iconName = self.iconName(i, false)
            let iconImageView = UIImageView(image: UIImage(named: iconName))
            vContainer.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.topAnchor.constraint(equalTo: vContainer.topAnchor, constant: offset),
                iconImageView.centerXAnchor.constraint(equalTo: vContainer.centerXAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: itemDim),
                iconImageView.heightAnchor.constraint(equalToConstant: itemDim)
            ])
            iconImageView.tag = 20 + i
            
            let button = UIButton(type: .custom)
            //button.backgroundColor = .red.withAlphaComponent(0.25)
            button.tag = i
            
            vContainer.addSubview(button)
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
                
                default:
                    NOTHING()
            }
        }
    }
    
    func iconName(_ index: Int, _ state: Bool) -> String {
        var result = "iPad.tab.0\(index)"
        if(state){ result += "_ON" }
        else {
            result += DARK_MODE() ? ".dark" : ".bright"
        }
          
        return result
    }
    
}

// ----------------------------------------------------------
func SCREEN_SIZE_iPadSideTab() -> CGSize {
    var result = UIScreen.main.bounds.size
    if(IPAD()){ result.width -= TabsBar_iPad.WIDTH }
    
    return result
}

func IPAD_sideOffset(multiplier: CGFloat = 1) -> CGFloat {
    var offset: CGFloat = 0
    if(IPAD()){ offset = TabsBar_iPad.WIDTH * multiplier }
    return offset
}
