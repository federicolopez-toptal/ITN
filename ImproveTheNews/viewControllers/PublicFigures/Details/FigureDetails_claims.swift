//
//  FigureDetails_claims.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/03/2024.
//

import UIKit

extension FigureDetailsViewController {
    
    func addClaims_structure(name: String) {
        let mainView = self.createContainerView()
        //mainView.backgroundColor = .red
        
        let label = UILabel()
        label.font = DM_SERIF_DISPLAY(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Claims from \(name)"
        mainView.addSubview(label)
        label.activateConstraints([
            label.widthAnchor.constraint(equalToConstant: self.W()),
            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            label.topAnchor.constraint(equalTo: mainView.topAnchor)
        ])
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .orange
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: M),
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)            
        ])
        containerView.tag = 555
        self.claimsContainerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        self.claimsContainerViewHeightConstraint!.isActive = true

        // More
        let moreView = UIView()
        mainView.addSubview(moreView)
        moreView.backgroundColor = CSS.shared.displayMode().main_bgColor
        moreView.activateConstraints([
            moreView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            moreView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            moreView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        moreView.tag = 556
        self.claimShowMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
        self.claimShowMoreViewHeightConstraint?.isActive = true
        
        if(IPHONE()) {
            let line = UIView()
            line.backgroundColor = .green
            moreView.addSubview(line)
            line.activateConstraints([
                line.leadingAnchor.constraint(equalTo: moreView.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: moreView.trailingAnchor),
                line.topAnchor.constraint(equalTo: moreView.topAnchor),
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_HDASHES(to: line)
        }
        
        let button = UIButton(type: .custom)
        moreView.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
        ])
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        button.titleLabel?.font = AILERON(15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
        button.addTarget(self, action: #selector(loadMoreClaimsOnTap(_:)), for: .touchUpInside)

        // Finally
        mainView.bottomAnchor.constraint(equalTo: moreView.bottomAnchor, constant: M).isActive = true
    }
    
    func fillClaims(_ claims: [Claim]) {
        for C in claims {
            self.claims.append(C)
        }
    }
    
    func addClaims(_ claims: [Claim], count: Int) {
        let containerView = self.view.viewWithTag(555)!
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        for (i, CL) in claims.enumerated() {
            let claimView = ClaimCellView(width: item_W)
            claimView.delegate = self
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ClaimCellView? = nil
            if(i>0) {
                if(IPHONE()) {
                    prev = (containerView.subviews.last as! ClaimCellView)
                } else { // IPAD
                    if(i==1) {
                        prev = (containerView.subviews.first as! ClaimCellView)
                    } else {
                        prev = (containerView.subviews[i-2] as! ClaimCellView)
                    }
                }
            }
            
            containerView.addSubview(claimView)
            claimView.activateConstraints([
                claimView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                claimView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(i==0) {
                claimView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(i==1) { // col2
                        let first = containerView.subviews.first as! ClaimCellView
                        claimView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                    }
                }
            }
            claimView.populate(with: CL)
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += claimView.calculateHeight()
                }
            } else {
                val_y += claimView.calculateHeight()
            }
        }
        
        // Show more --------------
        if(self.claims.count < count) {
            self.showMoreClaimsButton(true)
        } else {
            self.showMoreClaimsButton(false)
        }
        
        // Finally
        self.claimsContainerViewHeightConstraint?.constant = val_y
    }
    
    func addMoreClaims(_ claims: [Claim], newCount: Int, count: Int) {
        let containerView = self.view.viewWithTag(555)!
    
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        
        for (i, CL) in claims.enumerated() {
            let claimView = ClaimCellView(width: item_W)
            claimView.delegate = self
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ClaimCellView? = nil
            if(IPHONE()) {
                prev = (containerView.subviews.last as! ClaimCellView)
            } else { // IPAD
                let index = containerView.subviews.count-2
                prev = (containerView.subviews[index] as! ClaimCellView)
            }
            
            containerView.addSubview(claimView)
            claimView.activateConstraints([
                claimView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                claimView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(IPHONE()) {
                claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
            } else { // IPAD
                claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
            }
            claimView.populate(with: CL)
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                }
            }
        }
        
        // Show more --------------
        print(newCount, "de", count)
        if(newCount < count) {
            self.showMoreClaimsButton(true)
        } else {
            self.showMoreClaimsButton(false)
        }
        
        // Finally
        self.claimsContainerViewHeightConstraint?.constant = self.calculateContainerViewHeight()
    }
    
    func showMoreClaimsButton(_ visible: Bool) {
        let moreView = self.view.viewWithTag(556)!
        
        if(visible) {
            self.claimShowMoreViewHeightConstraint?.constant = 88
            moreView.show()
        } else {
            self.claimShowMoreViewHeightConstraint?.constant = 0
            moreView.hide()
        }
    }
    
    @objc func loadMoreClaimsOnTap(_ sender: UIButton) {
        self.claimsPage += 1
        let T = self.topics[0]
        
        self.showLoading()
        PublicFigureData.shared.loadMore(slug: self.slug, topic: T.slug, page: self.claimsPage) { (error, figure) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading figure claims,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()

                    if let _figure = figure {
                        self.addMoreClaims(_figure.claims,
                            newCount: self.claims.count + _figure.claims.count,
                            count: _figure.claimsCount)
                            
                        self.fillClaims(_figure.claims)
                    }
                    
                }
            }
        }
    }
    
}

extension FigureDetailsViewController: ClaimCellViewDelegate {
    
    func calculateContainerViewHeight() -> CGFloat {
        let containerView = self.view.viewWithTag(555)!
        var H: CGFloat = 0
        
        if(IPHONE()) {
            for V in containerView.subviews {
                if let _claimView = V as? ClaimCellView {
                    H += _claimView.calculateHeight()
                }
            }
        } else { //IPAD
            var col = 1
            var col1_H: CGFloat = 0
            var col2_H: CGFloat = 0
            
            for V in containerView.subviews {
                if let _claimView = V as? ClaimCellView {
                    if(col==1) {
                        col1_H += _claimView.calculateHeight()
                    } else {
                        col2_H += _claimView.calculateHeight()
                    }
                }
                
                col += 1
                if(col==3){ col=1 }
            }
            
            if(col1_H>col2_H){ H = col1_H }
            else{ H = col2_H }
        }
        
        return H
    }
    
    func claimCellViewOnHeightChanged(sender: ClaimCellView) {
        let H = self.calculateContainerViewHeight()
        self.claimsContainerViewHeightConstraint?.constant = H
    }
    
}
