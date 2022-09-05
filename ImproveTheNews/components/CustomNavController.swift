//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    let loadingView = LoadingView()
    let slidersPanel = SlidersPanel()
    let floatingButton = FloatingButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationBarHidden = true
        self.slidersPanel.buildInto(self.view)
        self.floatingButton.buildInto(self.view, panel: self.slidersPanel)
        
        self.loadingView.buildInto(self.view)
        self.addViewController()
    }
    
    private func addViewController() {
        let vc = MainFeedViewController()
        self.setViewControllers([vc], animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DELAY(1.0) {
            self.slidersPanel.show(rows: 2, animated: true)
        }
    }

}


