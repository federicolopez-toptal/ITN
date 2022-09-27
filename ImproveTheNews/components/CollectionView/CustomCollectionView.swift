//
//  CustomCollectionView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/09/2022.
//

import UIKit


protocol CustomCollectionViewDelegate {
    func collectionViewOnRefreshPulled(sender: CustomCollectionView)
}

class CustomCollectionView: UICollectionView {
    
    let refresher = UIRefreshControl()
    var customDelegate: CustomCollectionViewDelegate?
    
    init() {
        
//        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
//        let layout = CustomFlowLayout()

        let layout = MainFeedFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0 // vertical separation
        layout.minimumInteritemSpacing = 0 // horizontal separation
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: 100, height: 100) // UNUSED
    
        super.init(frame: .zero, collectionViewLayout: layout)
        //self.contentInsetAdjustmentBehavior = .always
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
