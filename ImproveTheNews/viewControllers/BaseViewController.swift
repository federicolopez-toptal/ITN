//
//  BaseViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/09/2022.
//

import UIKit

class BaseViewController: UIViewController {

    var didLayout = false
    var didAppear = false
    
    func showLoading() {
        DispatchQueue.main.async {
            CustomNavController.shared.loading.show()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            CustomNavController.shared.loading.hide()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return DARK_MODE() ? .lightContent : .darkContent
    }

}

extension BaseViewController {

    @objc func refreshDisplayMode() {
        // nothing for now...
    }

}
