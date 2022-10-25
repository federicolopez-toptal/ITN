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
    weak var customDelegate: CustomCollectionViewDelegate?
    
    init() {
        let layout = CustomFlowLayout()

        layout.minimumLineSpacing = 0 // vertical separation
        layout.minimumInteritemSpacing = 0 // horizontal separation
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
/*
        UNUSED
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 10, height: 10)
        
*/
        super.init(frame: .zero, collectionViewLayout: layout)
        self.setupRefresher()
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
    
    @objc func refresh(_ sender: UIRefreshControl!) {
        self.refresher.beginRefreshing()
        self.customDelegate?.collectionViewOnRefreshPulled(sender: self)
    }
    
    func hideRefresher() {
        DispatchQueue.main.async {
            if(!self.refresher.isRefreshing){ return }
            self.refresher.endRefreshing()
//            UIView.animate(withDuration: 0.5) {
//                self.refresher.layoutIfNeeded()
//            }
        }
    }
    
}
