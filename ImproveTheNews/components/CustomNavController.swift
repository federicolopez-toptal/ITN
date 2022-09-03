//
//  CustomNavController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

class CustomNavController: UINavigationController {

    let loadingView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationBarHidden = true
        self.addLoading()
        self.addViewController()
    }
    
    private func addViewController() {
        let vc = MainFeedViewController()
        self.setViewControllers([vc], animated: false)
    }

}

// MARK: - Loading
extension CustomNavController {

    private func addLoading() {
        // Square container
        self.loadingView.backgroundColor = .black.withAlphaComponent(0.5)
        self.loadingView.layer.cornerRadius = 15
        self.view.addSubview(self.loadingView)
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loadingView.widthAnchor.constraint(equalToConstant: 70),
            self.loadingView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Spinning wheel
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = .white
        self.loadingView.addSubview(loading)
        loading.center = CGPoint(x: 35, y: 35)
        loading.startAnimating()
        
        self.loadingView.hide()
    }

}
