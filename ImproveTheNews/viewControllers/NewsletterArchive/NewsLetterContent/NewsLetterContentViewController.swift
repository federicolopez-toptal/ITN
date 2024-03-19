//
//  NewsLetterContentViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/03/2024.
//

import UIKit

class NewsLetterContentViewController: BaseViewController {

    var refData: NewsLetterStory! = nil

    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    let M: CGFloat = CSS.shared.iPhoneSide_padding
    

    // MARK: - Init/Start
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.customBack, .title, .headlines])
            self.navBar.setTitle("Newsletter")
            
            self.buildContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
    // -------------------------------------------------
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.onCustomBackButtonTap),
            name: Notification_customBackButtonTap, object: nil)
            
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        //self.scrollView.delegate = self
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .green
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -13),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        self.addTopData()
        
        //self.scrollView.hide()
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        
        self.VStack.backgroundColor = self.view.backgroundColor
    }
    
    // -------------------------------------------------
    @objc func onCustomBackButtonTap(_ notification: Notification) {
        CustomNavController.shared.popViewController(animated: true)
    
//        let currentOffsetY = self.scrollView.contentOffset.y
//        if(currentOffsetY <= 30) {
//            CustomNavController.shared.popViewController(animated: true)
//        } else {
//            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }
    }

}

// MARK: - misc + Utils
extension NewsLetterContentViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: Data
extension NewsLetterContentViewController {
    
    private func loadContent() {
        self.showLoading()
        NewsLetterData.shared.loadNewsletter(self.refData) { (error) in
            if let _error = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading the newsletter,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    self.scrollView.show()
                    
                    self.addContent()
                }
            }
        }
    }
    
}

// MARK: UI
extension NewsLetterContentViewController {
    
    func addTopData() {
        let sectionHStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: sectionHStack, width: M)
        //sectionHStack.backgroundColor = .orange
        
            let sectionVStack = VSTACK(into: sectionHStack)
            //sectionVStack.backgroundColor = .red
                
                ADD_SPACER(to: sectionVStack, height: M/2)
        
                // Date
                let dateLabel = UILabel()
                dateLabel.text = self.refData.date
                dateLabel.font = AILERON(15)
                dateLabel.textColor = CSS.shared.displayMode().sec_textColor
                sectionVStack.addArrangedSubview(dateLabel)
                //ADD_SPACER(to: sectionVStack, height: 5)
                
                // NL Title
                let NLTitleLabel = UILabel()
                NLTitleLabel.font = DM_SERIF_DISPLAY(20)
                if(self.refData.type==1) {
                    NLTitleLabel.text = "Daily Newsletter"
                } else {
                    NLTitleLabel.text = "Weekly Newsletter"
                }
                NLTitleLabel.textColor = CSS.shared.displayMode().main_textColor
                sectionVStack.addArrangedSubview(NLTitleLabel)
                ADD_SPACER(to: sectionVStack, height: M)
        
                if(self.refData.type == 1) {
                    // main Title
                    let mainTitleLabel = UILabel()
                    mainTitleLabel.font = DM_SERIF_DISPLAY(22)
                    mainTitleLabel.numberOfLines = 0
                    mainTitleLabel.text = self.refData.title
                    mainTitleLabel.setLineSpacing(lineSpacing: -5)
                    mainTitleLabel.textColor = CSS.shared.displayMode().main_textColor
                    sectionVStack.addArrangedSubview(mainTitleLabel)
                    ADD_SPACER(to: sectionVStack, height: M)
                }
        
        ADD_SPACER(to: sectionHStack, width: M)
        
        let imageHStack = HSTACK(into: self.VStack)
        ADD_SPACER(to: sectionHStack, width: 0)
            // Image
            let imageView = CustomImageView()
            let H: CGFloat = (213 * SCREEN_SIZE().width)/370
            
            imageHStack.addArrangedSubview(imageView)
            imageView.activateConstraints([
                imageView.heightAnchor.constraint(equalToConstant: H)
            ])
            imageView.showCorners(true)
            imageView.load(url: self.refData.image_url)
        
        ADD_SPACER(to: sectionHStack, width: 0)
    }
    
    func addContent() {
    }
    
    
    
    
    
    
    func addVSep(to ST: UIStackView, height H: CGFloat) {
        ADD_SPACER(to: ST, height: H)
    }
    
    func addlateralMargins(to V: UIView) {
        let superView = V.superview!
        V.activateConstraints([
            V.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: M),
            V.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -M)
        ])
    }
    
    func innerHStack(bgcolor: UIColor = .clear) -> UIStackView {
        let vstack = HSTACK(into: self.VStack)
        vstack.backgroundColor = bgcolor
        
        return vstack
    }
    
}
