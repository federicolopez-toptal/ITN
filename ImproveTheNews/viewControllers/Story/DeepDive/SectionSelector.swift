//
//  SectionSelector.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/09/2022.
//

import UIKit

protocol SectionSelectorViewDelegate: AnyObject {
    func onSectionSelected(_ index: Int)
}

class SectionSelector: UIView {

    static let HEIGHT: CGFloat = 40.0

    var sections: [String] = []
    var selectedSectionIndex: Int = -1

    let scrollView = UIScrollView()
    let contentView = UIView()

    weak var delegate: SectionSelectorViewDelegate?



    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT)
        ])
        
        // scrollView
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT)
        ])
        
        // contentView
        let W = self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        W.priority = .defaultLow

        self.contentView.backgroundColor = .clear
        self.contentView.clipsToBounds = true
        self.scrollView.addSubview(self.contentView)
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            W, self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        ])
                
        self.refreshDisplayMode()
    }

    func setSections(_ paramSections: [String]) {
        var sections = paramSections
        sections.insert("Overview", at: 0)

        MAIN_THREAD {
            self.sections = sections
            REMOVE_ALL_SUBVIEWS(from: self.contentView)

            let HStack = HSTACK(into: self.contentView)
            HStack.backgroundColor = CSS.shared.displayMode().main_bgColor
            HStack.activateConstraints([
                HStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                HStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                HStack.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT),
                HStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
            
            for (i, T) in sections.enumerated() {                
                let sectionView = UIView()
                sectionView.backgroundColor = .green
                sectionView.layer.cornerRadius = SectionSelector.HEIGHT/2
                HStack.addArrangedSubview(sectionView)
                sectionView.activateConstraints([
                    sectionView.topAnchor.constraint(equalTo: HStack.topAnchor),
                    sectionView.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT),
                ])
            
                let label = UILabel()
                label.font = AILERON_SEMIBOLD(14)
                label.backgroundColor = .clear
                label.text = T
                sectionView.addSubview(label)
                label.activateConstraints([
                    label.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 24),
                    label.topAnchor.constraint(equalTo: HStack.topAnchor),
                    label.heightAnchor.constraint(equalToConstant: SectionSelector.HEIGHT),
                ])
                
                let _W = label.calculateWidthFor(height: SectionSelector.HEIGHT)
                sectionView.widthAnchor.constraint(equalToConstant: _W+24+24).isActive = true
                    
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                sectionView.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
                    button.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
                    button.topAnchor.constraint(equalTo: sectionView.topAnchor)
                ])
                button.tag = 30 + i
                button.addTarget(self, action: #selector(self.onSectionTap(_:)), for: .touchUpInside)
                
                ADD_SPACER(to: HStack, width: 8)
            }
            
            self.selectSection(index: 0)
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func selectSection(index: Int) {
        self.selectedSectionIndex = index
        let HStack = self.contentView.subviews.first as! UIStackView
        
        var i = 0
        for view in HStack.arrangedSubviews {
            if(view.tag != -1) {
                // each sectionView
                let label = view.subviews.first as! UILabel
                
                label.textColor = CSS.shared.displayMode().main_textColor
                
                
                if(i == index) {
                    view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x424345) : UIColor(hex: 0xD6D6D6)
                    view.layer.borderWidth = 0
                } else {
                    view.backgroundColor = CSS.shared.displayMode().main_bgColor
                    view.layer.borderWidth = 1
                    view.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x424345).cgColor : UIColor(hex: 0xD6D6D6).cgColor
                }
                
                i += 1
            }
        }
    }
    
    func scrollToZero() {
        self.selectSection(index: 0)
    
        self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint.zero,
            size: CGSize(width: 10, height: 10)),
            animated: true)
    }
    
    func scrollToItem(index: Int) {
        let HStack = self.contentView.subviews.first as! UIStackView
        var targetView: UIView? = nil

        var i = -1
        for V in HStack.arrangedSubviews {
            if(V.subviews.count>0) {
                i += 1
                if(i==index) {
                    targetView = V
                    break
                }
            }
        }

        if let _targetView = targetView {
            let val_X: CGFloat = _targetView.frame.origin.x
            self.scrollView.setContentOffset(CGPoint(x: val_X, y: 0), animated: true)
        }

//        var i = index - 1
//        if(i<0){ i=0 }
//        if(i>=HStack.arrangedSubviews.count){ i=HStack.arrangedSubviews.count-1 }
        
//        let targetView = HStack.arrangedSubviews[index]
//        print(targetView.subviews)
    
        
    }
    
    

}

extension SectionSelector {
    
    // MARK: - Event(s)
    @objc func onSectionTap(_ sender: UIButton) {
        let tag = sender.tag - 30
        
        self.selectSection(index: tag)
        self.delegate?.onSectionSelected(tag)
    }
    
    // MARK: - Display mode
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor        
        
//        for C in self.displayModeComponents {
//            if(C is UIView) {
//                let view = (C as! UIView)
//                if(view.tag == 1) { // lines
//                    view.backgroundColor = self.backgroundColor
//                    ADD_HDASHES(to: view)                    
//                }
//            }
//        }
//        
//        if(self.selectedTopicIndex != -1) {
//            self.selectTopic(index: self.selectedTopicIndex)
//        }
    }
    
}
