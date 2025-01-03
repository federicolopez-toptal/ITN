//
//  CollapsableSources.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/01/2025.
//

import Foundation
import UIKit

class CollapsableSources {

    weak var container: UIStackView? = nil
    var isOpen = false

    let arrowImageView = UIImageView(image: UIImage(named: "deployArrow")?.withRenderingMode(.alwaysTemplate))
    let actionButton = UIButton(type: .system)
    var arrowSpacerWidthConstraint: NSLayoutConstraint? = nil
    

    init(buildInto container: UIStackView, sources: [SourceForGraph]) {
        self.container = container
        
        container.spacing = 0
        container.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        for (i, S) in sources.enumerated() {
            var pos_x: CGFloat = -1
            var width: CGFloat = -1
            
            if(i==1 && IPHONE()) {
                let prev = container.arrangedSubviews.first as! CollapsableSingleSourceView
                
                pos_x = prev.fullWidth()
                width = SCREEN_SIZE().width-32-24-pos_x-32
                
//                let tmpView = UIView()
//                tmpView.backgroundColor = .green
//                container.addSubview(tmpView)
//                tmpView.activateConstraints([
//                    tmpView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: pos_x),
//                    tmpView.widthAnchor.constraint(equalToConstant: width),
//                    
//                    tmpView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
//                    tmpView.heightAnchor.constraint(equalToConstant: 20)
//                    
//                ])

            }
            
            let sourceView = CollapsableSingleSourceView()
            sourceView.url = S.url
            sourceView.widthLimit = width
            sourceView.buildInto(container, source: S)
        }
        
        let spacer = UIView()
        container.addArrangedSubview(spacer)
        self.arrowSpacerWidthConstraint = spacer.widthAnchor.constraint(equalToConstant: 16)
        self.arrowSpacerWidthConstraint?.isActive = true
        
        let arrowVStack = VSTACK(into: container)
        ADD_SPACER(to: arrowVStack, height: 6.5)
        
        arrowImageView.tintColor = CSS.shared.displayMode().main_textColor
        //arrowImageView.backgroundColor = .yellow.withAlphaComponent(0.5)
        arrowVStack.addArrangedSubview(arrowImageView)
        arrowImageView.activateConstraints([
            arrowImageView.widthAnchor.constraint(equalToConstant: 18),
            arrowImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        ADD_SPACER(to: arrowVStack, height: 6.5)
        
        ADD_SPACER(to: container)
        
        self.actionButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        container.addSubview(self.actionButton)
        self.actionButton.activateConstraints([
            self.actionButton.centerXAnchor.constraint(equalTo: self.arrowImageView.centerXAnchor),
            self.actionButton.centerYAnchor.constraint(equalTo: self.arrowImageView.centerYAnchor),
            self.actionButton.widthAnchor.constraint(equalToConstant: 31),
            self.actionButton.heightAnchor.constraint(equalToConstant: 31)
        ])
        self.actionButton.addTarget(self, action: #selector(self.actionButtonTap(_:)), for: .touchUpInside)

    }
    
    // MARK: Button actions
    @objc func actionButtonTap(_ sender: UIButton?) {
        for V in self.container!.arrangedSubviews {
            if let _V = V as? CollapsableSingleSourceView {
                if(self.isOpen) {
                    _V.close(animated: true)
                } else {
                    _V.open(animated: true)
                }
            }
        }
        
        self.isOpen = !self.isOpen
        
        if(self.isOpen) {
            self.arrowSpacerWidthConstraint?.constant = 0
            arrowImageView.image = UIImage(named: "closeArrow")?.withRenderingMode(.alwaysTemplate)
        } else {
            self.arrowSpacerWidthConstraint?.constant = 16
            arrowImageView.image = UIImage(named: "deployArrow")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
}
