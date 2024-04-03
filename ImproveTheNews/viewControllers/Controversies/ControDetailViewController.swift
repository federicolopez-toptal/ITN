//
//  ControDetailViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/04/2024.
//

import UIKit

class ControDetailViewController: BaseViewController {

    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!

    var slug: String = ""

    var claimsPage = 1



    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Controversy")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
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
        //self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.vStack = VSTACK(into: self.contentView)
        //self.vStack.backgroundColor = .yellow.withAlphaComponent(0.1)
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
//            ,self.vStack.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        self.refreshDisplayMode()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        //self.VStack.backgroundColor = self.view.backgroundColor
    }


}

// MARK: misc
extension ControDetailViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

extension ControDetailViewController {

    func loadData() {

//        self.showLoading()
//        PublicFigureData.shared.loadFigure(slug: self.slug) { (error, figure) in
//            if let _ = error {
//                ALERT(vc: self, title: "Server error",
//                message: "Trouble loading Public Figure,\nplease try again later.", onCompletion: {
//                    self.hideLoading()
//                    CustomNavController.shared.popViewController(animated: true)
//                })
//            } else {
//                MAIN_THREAD {
//                    self.hideLoading()
//                    if let _F = figure {
//                        self.fillContent(_F)
//                    }
//                }
//            }
//        }
    }

//    func addClaims_structure(name: String) {
//        let mainView = self.createContainerView()
//        //mainView.backgroundColor = .red
//        
//        let label = UILabel()
//        label.font = DM_SERIF_DISPLAY(20)
//        label.textColor = CSS.shared.displayMode().main_textColor
//        label.text = "Claims from \(name)"
//        mainView.addSubview(label)
//        label.activateConstraints([
//            label.widthAnchor.constraint(equalToConstant: self.W()),
//            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
//            label.topAnchor.constraint(equalTo: mainView.topAnchor)
//        ])
//        
//        let containerView = UIView()
//        mainView.addSubview(containerView)
//        //containerView.backgroundColor = .orange
//        mainView.addSubview(containerView)
//        containerView.activateConstraints([
//            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: M),
//            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
//            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
//        ])
//        containerView.tag = 555
//        self.claimsContainerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
//        self.claimsContainerViewHeightConstraint!.isActive = true
//
//        // More
//        let moreView = UIView()
//        mainView.addSubview(moreView)
//        moreView.backgroundColor = CSS.shared.displayMode().main_bgColor
//        moreView.activateConstraints([
//            moreView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
//            moreView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
//            moreView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
//        ])
//        moreView.tag = 556
//        self.claimShowMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
//        self.claimShowMoreViewHeightConstraint?.isActive = true
//        
//        if(IPHONE()) {
//            let line = UIView()
//            line.backgroundColor = .green
//            moreView.addSubview(line)
//            line.activateConstraints([
//                line.leadingAnchor.constraint(equalTo: moreView.leadingAnchor),
//                line.trailingAnchor.constraint(equalTo: moreView.trailingAnchor),
//                line.topAnchor.constraint(equalTo: moreView.topAnchor),
//                line.heightAnchor.constraint(equalToConstant: 1)
//            ])
//            ADD_HDASHES(to: line)
//        }
//        
//        let button = UIButton(type: .custom)
//        moreView.addSubview(button)
//        button.activateConstraints([
//            button.heightAnchor.constraint(equalToConstant: 42),
//            button.widthAnchor.constraint(equalToConstant: 150),
//            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
//        ])
//        button.setTitle("Show more", for: .normal)
//        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
//        button.titleLabel?.font = AILERON(15)
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 9
//        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
//        button.addTarget(self, action: #selector(loadMoreClaimsOnTap(_:)), for: .touchUpInside)
//
//        // Finally
//        mainView.bottomAnchor.constraint(equalTo: moreView.bottomAnchor, constant: M).isActive = true
//    }
//    
//    func createContainerView(bgColor: UIColor = .clear, height: CGFloat? = nil) -> UIView {
//        let containerView = UIView()
//        containerView.backgroundColor = bgColor
//        self.vStack.addArrangedSubview(containerView)
//        
//        if let _H = height {
//            containerView.heightAnchor.constraint(equalToConstant: _H).isActive = true
//        }
//        
//        return containerView
//    }

}
