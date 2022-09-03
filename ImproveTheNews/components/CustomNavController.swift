//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationBarHidden = true
        self.addViewController()
    }
    
    private func addViewController() {
        let vc = MainFeedViewController()
        self.setViewControllers([vc], animated: false)
    }

}
