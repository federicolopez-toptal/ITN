//
//  LoadingView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/09/2022.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func insertInto(_ container: UIView) {
        // Square (self)
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 15
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.widthAnchor.constraint(equalToConstant: 70),
            self.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Spinning wheel
        let loading = UIActivityIndicatorView(style: .large)
        loading.color = .white
        self.addSubview(loading)
        loading.center = CGPoint(x: 35, y: 35)
        loading.startAnimating()
        
        self.hide()
    }
    
}
