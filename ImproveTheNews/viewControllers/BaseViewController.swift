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
            (self.navigationController as! CustomNavController).loadingView.show()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            (self.navigationController as! CustomNavController).loadingView.hide()
        }
    }

}
