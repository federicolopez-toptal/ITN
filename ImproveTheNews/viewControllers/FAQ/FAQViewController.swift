//
//  FAQViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import UIKit

class FAQViewController: BaseViewController {

    let navBar = NavBarView()
    let titleLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    var heightConstraints = [NSLayoutConstraint]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("FAQ's")
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow

        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .green
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])

        self.titleLabel.font = MERRIWEATHER_BOLD(24)
        self.titleLabel.text = ""
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13)
        ])

        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.systemPink
        self.VStack.spacing = 10
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            self.VStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0),
            //self.VStack.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 13),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -26),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
    
        self.refreshDisplayMode()
    }
    
    func addContent() {
        
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
        self.heightConstraints = [NSLayoutConstraint]()
        
        for i in 1...15 {
            self.addSection(title: self.titles(i), content: self.contents(i),
                linkTexts: self.linkedTexts(i), urls: self.urls(i), index: i)
        }
        
    }
    
    func addSection(title tText: String, content: String,
        linkTexts: [String], urls: [String], index: Int) {
        
        let sectionView = UIView()
        sectionView.tag = 0
        sectionView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202D).withAlphaComponent(0.4) : UIColor(hex: 0xF4F6F8)
        self.VStack.addArrangedSubview(sectionView)
        
        let heightConstraint = sectionView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        self.heightConstraints.append(heightConstraint)
        
        let vLine = UIView()
        vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x93A0B4)
        sectionView.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            vLine.topAnchor.constraint(equalTo: sectionView.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 2)
        ])
        
        let titleHStack = HSTACK(into: sectionView)
        titleHStack.backgroundColor = .clear //.orange
        titleHStack.activateConstraints([
            titleHStack.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            titleHStack.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            titleHStack.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 24)
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = MERRIWEATHER_BOLD(20)
        titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        titleLabel.numberOfLines = 0
        titleLabel.text = tText
        titleLabel.backgroundColor = .clear //.yellow
        titleHStack.addArrangedSubview(titleLabel)
        
        ADD_SPACER(to: titleHStack, backgroundColor: .clear, width: 50)
        
        let icon = UIImageView()
        icon.backgroundColor = .clear //.green
        titleHStack.addSubview(icon)
        icon.activateConstraints([
            icon.widthAnchor.constraint(equalToConstant: 34),
            icon.heightAnchor.constraint(equalToConstant: 34),
            icon.trailingAnchor.constraint(equalTo: titleHStack.trailingAnchor),
            icon.topAnchor.constraint(equalTo: titleHStack.topAnchor, constant: -4)
        ])
                
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        sectionView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 50),
            buttonArea.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            buttonArea.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
        buttonArea.tag = self.VStack.arrangedSubviews.count
        buttonArea.addTarget(self, action: #selector(self.onSectionTap(_:)), for: .touchUpInside)
        
        let contentLabel = HyperlinkLabel.parrafo2(text: content, linkTexts: linkTexts,
            urls: urls, onTap: self.onLinkTap(_:))
        sectionView.addSubview(contentLabel)
        contentLabel.activateConstraints([
            contentLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        ])
        
        let imageInfo = self.images(index)
        let image: UIImage? = imageInfo?.0
//        if(index==5){ image = UIImage(named: "galileo") }
//        else if(index==6){ image = UIImage(named: "einstein") }
        
        if let _image = image {
            var W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 15 - 15
            if(IPAD()) {
                if(SCREEN_SIZE().height < W){
                    W = SCREEN_SIZE().height - 13 - 13 - 15 - 15
                }
            }
            
            let _w = imageInfo!.1.width
            let _h = imageInfo!.1.height
            let H: CGFloat = (W * _h)/_w
//            var H: CGFloat = 0
//            if(index == 5) {
//                H = (W * 175)/468
//            } else if(index == 6) {
//                H = (W * 216)/1280
//            }
            
            let imgView = UIImageView(image: _image)
            sectionView.addSubview(imgView)
            imgView.activateConstraints([
                imgView.widthAnchor.constraint(equalToConstant: W),
                imgView.heightAnchor.constraint(equalToConstant: H),
                imgView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                imgView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15)
            ])
        }
        
        self.updateSectionHeight(index: self.VStack.arrangedSubviews.count, open: false)
    }
    func updateSectionHeight(index: Int, open: Bool, animate: Bool = false) {
        var W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 15 - 15 - 50
        if(IPAD()) {
            if(SCREEN_SIZE().height < W){
                W = SCREEN_SIZE().height - 13 - 13 - 15 - 15
            }
        }
        
        let sectionView = self.VStack.arrangedSubviews[index-1]
        let vLine = sectionView.subviews[0]
        let hStack = sectionView.subviews[1] as! UIStackView
            let titleLabel = hStack.arrangedSubviews[0] as! UILabel
            let icon = hStack.subviews[2] as! UIImageView
        let contentLabel = sectionView.subviews[3] as! HyperlinkLabel
        
        var imageView: UIImageView?
        if(index==5 || index==6) {
            imageView = sectionView.subviews[4] as? UIImageView
        }
        
        var height: CGFloat = 0
        if(open) {
            sectionView.tag = 1
            height = 24 + titleLabel.calculateHeightFor(width: W) + 24 + contentLabel.calculateHeightFor(width: W+50) + 24
            contentLabel.show()
            vLine.backgroundColor = UIColor(hex: 0xFF643C)
            titleLabel.textColor = UIColor(hex: 0xFF643C)
            
            var imageName = "minusLight"
            if(DARK_MODE()){ imageName = "minusDark" }
            icon.image = UIImage(named: imageName)
            
            imageView?.show()
            var H: CGFloat = 0
            if let _imageInfo = self.images(index) {
                let _w = _imageInfo.1.width
                let _h = _imageInfo.1.height
                H = ((W+50) * _h)/_w
            }
//            if(index==5 || index==6) {
//                if(index == 5) {
//                    H = ((W+50) * 175)/468
//                } else if(index == 6) {
//                    H = ((W+50) * 216)/1280
//                }
                height += H + 15
//            }
            
            
        } else {
            sectionView.tag = 0
            height = 24 + titleLabel.calculateHeightFor(width: W) + 24
            contentLabel.hide()
            vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x93A0B4)
            titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            icon.image = UIImage(named: "plus")
            imageView?.hide()
        }
        
        self.heightConstraints[index-1].constant = height
    }
    
    
    @objc func onSectionTap(_ sender: UIButton?) {
        let tag = sender!.tag
        let sectionView = sender!.superview!
        
        if(sectionView.tag == 0) { // Open section!
            self.updateSectionHeight(index: tag, open: true, animate: true)
            
        } else { // Close section!
            self.updateSectionHeight(index: tag, open: false, animate: true)
        }
    }
    
    

    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        self.navBar.refreshDisplayMode()
        
        self.addContent()
    }

}

// MARK: - Event(s)
extension FAQViewController {

    func onLinkTap(_ url: URL) {
        if(url.absoluteString.contains("local://")) {
            if(url.absoluteString.contains("feedbackForm")) {
                let vc = FeedbackFormViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            } else if(url.absoluteString.contains("privacyPolicy")) {
                let vc = PrivacyPolicyViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        } else {
            OPEN_URL(url.absoluteString)
        }
    }
    
}

extension FAQViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}