//
//  PrivacyPolicyViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import UIKit

class PrivacyPolicyViewController: BaseViewController {

    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    
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
            self.navBar.setTitle("Privacy Policy")
            
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

        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.yellow
        self.VStack.spacing = 13
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -26),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
    
        self.refreshDisplayMode()
        self.addContent()
    }
    
    func addContent() {
        REMOVE_ALL_SUBVIEWS(from: VStack)
    
        //self.addTitle("Privacy Policy")
        //ADD_SPACER(to: self.VStack, height: 1)
        for i in 1...12 {
            self.addSubTitle( self.subTitles(i) )
            if(i==8) {
                self.addTitle("How we protect your data")
            }
            self.addParagraph( self.paragraphs(i), linkTexts: self.linkTexts(i), urls: self.urls(i) )
        }
    }
    
    func addTitle(_ text: String) {
        let label = UILabel()
        label.tag = 10
        label.text = text
        label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        label.numberOfLines = 0
        label.font = MERRIWEATHER_BOLD(18)
        self.VStack.addArrangedSubview(label)
    }
    
    func addSubTitle(_ text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.tag = 11
        label.numberOfLines = 0
        label.font = MERRIWEATHER_BOLD(16)
        label.textColor = UIColor(hex: 0xFF643C)
        self.VStack.addArrangedSubview(label)
    }
    
    func addParagraph(_ text: String, linkTexts: [String], urls: [String]) {
        let label = HyperlinkLabel.parrafo2(text: text, linkTexts: linkTexts, urls: urls, onTap: self.onLinkTap(_:))
        self.VStack.addArrangedSubview(label)
    }
    
    
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        self.navBar.refreshDisplayMode()

        self.addContent()
    }
    
    func onLinkTap(_ url: URL) {
        if(url.absoluteString=="local://feedbackForm") {
            let vc = FeedbackFormViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }

}

extension PrivacyPolicyViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
