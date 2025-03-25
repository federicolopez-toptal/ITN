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

    private var showInfoButton: Bool = false

    init(buildInto container: UIStackView, sources: [SourceForGraph], showInfoButton: Bool = false) {
        if(sources.count==0) { return }
        self.showInfoButton = showInfoButton
        
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
        
        var count = 0
        var val_X: CGFloat = 0
        for S in sources {
            let V = SourceView_v2(source: S, showName: false)
            self.closedView.addSubview(V)
            V.activateConstraints([
                V.leadingAnchor.constraint(equalTo: self.closedView.leadingAnchor, constant: val_X),
                V.topAnchor.constraint(equalTo: self.closedView.topAnchor),
            ])
            
            val_X += 27
            count += 1
            if(count==3) {
                break
            }
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
        
        if(self.showInfoButton) {
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: DisplayMode.imageName("storyInfo"))
            self.closedView.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 8),
                iconImageView.centerYAnchor.constraint(equalTo: self.closedView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 72/3),
                iconImageView.heightAnchor.constraint(equalToConstant: 72/3)
            ])
                
            let infoButton = UIButton(type: .custom)
            infoButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            self.closedView.addSubview(infoButton)
            infoButton.activateConstraints([
                infoButton.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -5),
                infoButton.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -5),
                infoButton.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
                infoButton.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5)
            ])
            infoButton.addTarget(self, action: #selector(infoButtonOnTap(_:)), for: .touchUpInside)
        }
        
    // Opened view --------------------------------------------------------------------------------
        self.openedView.backgroundColor = CSS.shared.displayMode().main_bgColor
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
        
        //ADD_SPACER(to: HStack, width: 8)
                
        // CLOSE
        let closeButton = UIButton(type: .custom)
        closeButton.backgroundColor = .clear //.blue.withAlphaComponent(0.25)
        HStack.addArrangedSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        closeButton.addTarget(self, action: #selector(self.closeOnTap(_:)), for: .touchUpInside)
        
        let closeArrowImageView = UIImageView(image: UIImage(named: "closeArrow")?.withRenderingMode(.alwaysTemplate))
        closeArrowImageView.tintColor = CSS.shared.displayMode().main_textColor
        closeButton.addSubview(closeArrowImageView)
        closeArrowImageView.activateConstraints([
            closeArrowImageView.widthAnchor.constraint(equalToConstant: 18),
            closeArrowImageView.heightAnchor.constraint(equalToConstant: 18),
            closeArrowImageView.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            closeArrowImageView.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor)
        ])
        closeArrowImageView.isUserInteractionEnabled = false
        
        self.openedView.hide()
    }
    
    @objc func openOnTap(_ sender: UIButton?) {
        self.closedView.hide()
        
        for V in self.openedView.subviews {
            if let _scrollView = V as? UIScrollView {
                _scrollView.scrollToZero(animated: false)
            }
        }
        
        self.openedView.show()
    }
    
    @objc func closeOnTap(_ sender: UIButton?) {
        self.openedView.hide()
        self.closedView.show()
    }
    
    @objc func infoButtonOnTap(_ sender: UIButton?) {
        let descr = """
        We source our facts from a wide range of news outlets across the political and establishment spectrum, as well as supplementary primary sources (e.g. academic publications, social media posts by public figures, think tanks, NGOs, databases, etc.) where possible. We classify sources as left/right and pro-establishment/establishment-critical based on an MIT [0] on media bias conducted by Max Tegmark and Samantha D’Alonzo.
        """
        
        let popup = StoryInfoPopupView(title: "Sources", description: descr, linkedTexts: ["study"],
                    links: ["https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0271947"], height: 310)
                
        popup.pushFromBottom()
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
