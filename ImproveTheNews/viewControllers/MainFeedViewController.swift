//
//  MainFeedViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class MainFeedViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            self.setNavBar() // from extension
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
        }
    }
    
    func loadData() {
        self.showLoading()
        UUID.shared.check { _ in // generates a new uuid (if needed)
            let data = MainFeed()
            data.loadData { (error) in
                self.hideLoading()
            }
        }
    }

}
