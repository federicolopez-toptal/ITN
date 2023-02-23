//
//  CustomCollectionView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/09/2022.
//

import UIKit


protocol CustomCollectionViewDelegate: AnyObject {
    func collectionViewOnRefreshPulled(sender: CustomCollectionView)
}

class CustomCollectionView: UICollectionView {
    
    let refresher = UIRefreshControl()
    let vLineView = UIView()
    var vLineHeightConstraint: NSLayoutConstraint?
    weak var customDelegate: CustomCollectionViewDelegate?
    
    init() {
        if(IPHONE()) {
            let layout = CustomFlowLayout()

            layout.minimumLineSpacing = 0 // vertical separation
            layout.minimumInteritemSpacing = 0 // horizontal separation
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
    //        layout.scrollDirection = .vertical  // UNUSED
    //        layout.estimatedItemSize = CGSize(width: 10, height: 10) // UNUSED
            
            super.init(frame: .zero, collectionViewLayout: layout)
            self.setupRefresher()
            self.setupVLine()
        } else {
            
        
            let layout = CustomIPadFlowLayout()

            layout.minimumLineSpacing = 8 // vertical separation
            layout.minimumInteritemSpacing = 8 // horizontal separation
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            
            super.init(frame: .zero, collectionViewLayout: layout)
            self.setupRefresher()
            self.setupVLine()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupRefresher() {
        self.alwaysBounceVertical = true
        self.refresher.tintColor = .lightGray
        self.refresher.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.addSubview(refresher)
    }
    
    private func setupVLine() {
        self.addSubview(self.vLineView)
        self.vLineView.backgroundColor = .systemPink
        self.vLineHeightConstraint = self.vLineView.heightAnchor.constraint(equalToConstant: 100)
        self.vLineView.activateConstraints([
            self.vLineView.widthAnchor.constraint(equalToConstant: 1.5),
            self.vLineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.vLineView.topAnchor.constraint(equalTo: self.topAnchor),
            self.vLineHeightConstraint!
        ])
        
        self.vLineView.hide()
    }
    
    func refreshVLine(lines: [(CGFloat, Bool)]) {
        var sum: CGFloat = 0
        
        REMOVE_ALL_SUBVIEWS(from: self.vLineView)
        for (_, L) in lines.enumerated() {
            let color = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            
            if(L.1) {
                let newLine = UIView()
                newLine.backgroundColor = color
                self.vLineView.addSubview(newLine)
                newLine.activateConstraints([
                    newLine.leadingAnchor.constraint(equalTo: self.vLineView.leadingAnchor),
                    newLine.trailingAnchor.constraint(equalTo: self.vLineView.trailingAnchor),
                    newLine.topAnchor.constraint(equalTo: self.vLineView.topAnchor, constant: sum),
                    newLine.heightAnchor.constraint(equalToConstant: L.0)
                ])
            }

            sum += L.0
        }
                
        self.vLineView.backgroundColor = .clear
        self.vLineHeightConstraint?.constant = sum
        self.vLineView.show()
    }
    
    @objc func refresh(_ sender: UIRefreshControl!) {
        self.refresher.beginRefreshing()
        self.customDelegate?.collectionViewOnRefreshPulled(sender: self)
    }
    
    func hideRefresher() {
        DispatchQueue.main.async {
            if(!self.refresher.isRefreshing){ return }
            self.refresher.endRefreshing()
        }
    }
    
    func forceUpdateLayoutForVisibleItems() {
        MAIN_THREAD {
            let frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
            if(IPHONE()) {
                let _ = (self.collectionViewLayout as! CustomFlowLayout).layoutAttributesForElements(in: frame)
            } else {
                let _ = (self.collectionViewLayout as! CustomIPadFlowLayout).layoutAttributesForElements(in: frame)
            }
        }
    }
    
}
