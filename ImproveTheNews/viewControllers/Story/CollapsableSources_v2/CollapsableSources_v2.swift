//
//  CollapsableSources_v2.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/03/2025.
//

import Foundation
import UIKit


class CollapsableSources_v2 {

    weak var container: UIStackView? = nil

    let closedView = UIView()
    let openedView = UIView()


    init(buildInto container: UIStackView, sources: [SourceForGraph]) {
        if(sources.count==0) { return }
        
        self.container = container // HStack
        container.spacing = 0
        container.backgroundColor = CSS.shared.displayMode().main_bgColor
        container.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        if(sources.count == 1) {
            self.fillWithSingleItem(sources.first!)
        } else {
            self.fillWithItems(sources)
        }
        
    }
    
    private func fillWithItems(_ sources: [SourceForGraph]) {
    // Closed view
        self.closedView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.container?.addSubview(self.closedView)
        self.closedView.activateConstraints([
            self.closedView.leadingAnchor.constraint(equalTo: self.container!.leadingAnchor),
            self.closedView.trailingAnchor.constraint(equalTo: self.container!.trailingAnchor),
            self.closedView.topAnchor.constraint(equalTo: self.container!.topAnchor),
            self.closedView.bottomAnchor.constraint(equalTo: self.container!.bottomAnchor)
        ])
        
        var val_X: CGFloat = 0
        for S in sources {
            let V = SourceView_v2(source: S, showName: false)
            self.closedView.addSubview(V)
            V.activateConstraints([
                V.leadingAnchor.constraint(equalTo: self.closedView.leadingAnchor, constant: val_X),
                V.topAnchor.constraint(equalTo: self.closedView.topAnchor),
            ])
            val_X += 27
        }
        for V in self.closedView.subviews.reversed() {
            self.closedView.bringSubviewToFront(V)
        }
        
        let deployArrowImageView = UIImageView(image: UIImage(named: "deployArrow")?.withRenderingMode(.alwaysTemplate))
        deployArrowImageView.tintColor = CSS.shared.displayMode().main_textColor
        self.closedView.addSubview(deployArrowImageView)
        deployArrowImageView.activateConstraints([
            deployArrowImageView.widthAnchor.constraint(equalToConstant: 18),
            deployArrowImageView.heightAnchor.constraint(equalToConstant: 18),
            deployArrowImageView.centerYAnchor.constraint(equalTo: self.closedView.centerYAnchor),
            deployArrowImageView.leadingAnchor.constraint(equalTo: self.closedView.subviews.first!.trailingAnchor, constant: 8)
        ])
        
        let openButton = UIButton(type: .custom)
        openButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.closedView.addSubview(openButton)
        openButton.activateConstraints([
            openButton.leadingAnchor.constraint(equalTo: self.closedView.leadingAnchor),
            openButton.topAnchor.constraint(equalTo: self.closedView.topAnchor),
            openButton.trailingAnchor.constraint(equalTo: deployArrowImageView.trailingAnchor),
            openButton.bottomAnchor.constraint(equalTo: self.closedView.bottomAnchor)
        ])
        openButton.addTarget(self, action: #selector(self.openOnTap(_:)), for: .touchUpInside)
        //self.closedView.hide()
        
    // Opened view
        self.openedView.backgroundColor = .red //CSS.shared.displayMode().main_bgColor
        self.container?.addSubview(self.openedView)
        self.openedView.activateConstraints([
            self.openedView.leadingAnchor.constraint(equalTo: self.container!.leadingAnchor),
            self.openedView.trailingAnchor.constraint(equalTo: self.container!.trailingAnchor),
            self.openedView.topAnchor.constraint(equalTo: self.container!.topAnchor),
            self.openedView.bottomAnchor.constraint(equalTo: self.container!.bottomAnchor)
        ])
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = CSS.shared.displayMode().main_bgColor
        scrollView.showsHorizontalScrollIndicator = false
        self.openedView.addSubview(scrollView)
        scrollView.activateConstraints([
            scrollView.leadingAnchor.constraint(equalTo: self.openedView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.openedView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.openedView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.openedView.bottomAnchor)
        ])
        
        let contentView = UIView()
        let W = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        W.priority = .defaultLow

        contentView.backgroundColor = scrollView.backgroundColor
        contentView.clipsToBounds = true
        scrollView.addSubview(contentView)
        contentView.activateConstraints([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            W, contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        let HStack = HSTACK(into: contentView)
        HStack.backgroundColor = scrollView.backgroundColor
        HStack.activateConstraints([
            HStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            HStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            HStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            HStack.heightAnchor.constraint(equalToConstant: 31)
        ])
        
        for S in sources {
            let V = SourceView_v2(source: S)
            HStack.addArrangedSubview(V)            
        }
        self.openedView.hide()
    }
    
    @objc func openOnTap(_ sender: UIButton?) {
        self.closedView.hide()
        self.openedView.show()
    }
    
    
    
    // -----------------------------------------------------------------
    // -----------------------------------------------------------------
    // -----------------------------------------------------------------
    private func fillWithSingleItem(_ singleSource: SourceForGraph) {
        let V = SourceView_v2(source: singleSource)
        self.container!.addArrangedSubview(V)
        ADD_SPACER(to: self.container!)
    }

}
