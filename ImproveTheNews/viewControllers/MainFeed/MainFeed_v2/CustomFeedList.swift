//
//  CustomFeedList.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit


protocol CustomFeedListDelegate: AnyObject {
    func feedListOnRefreshPulled(sender: CustomFeedList)
}

//----------------------------------
class CustomFeedList: UITableView {

    let refresher = UIRefreshControl()
    weak var customDelegate: CustomFeedListDelegate?

    // MARK: - Start
    init() {
        super.init(frame: .zero, style: .plain)
        self.setupRefresher()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - misc
    private func setupRefresher() {
        self.alwaysBounceVertical = true
        self.refresher.tintColor = .lightGray
        self.refresher.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.addSubview(refresher)
    }
    
    func hideRefresher() {
        DispatchQueue.main.async {
            if(!self.refresher.isRefreshing){ return }
            self.refresher.endRefreshing()
        }
    }
    
    // MARK: Action(s)
    func scrollToTop() {
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func scrollToBottom() {
        let count = self.numberOfRows(inSection: 0)
        self.scrollToRow(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
    }

}

extension CustomFeedList {

    // MARK: - Event(s)
    @objc func refresh(_ sender: UIRefreshControl!) {
        self.refresher.beginRefreshing()
        self.customDelegate?.feedListOnRefreshPulled(sender: self)
    }
    
}

