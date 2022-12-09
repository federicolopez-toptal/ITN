//
//  CircleAnimation.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/12/2022.
//

import UIKit

class CircleAnimation: UIView {

    let CIRCLE_SIZE: CGFloat = 64

    let circle = UIImageView(image: UIImage(named: "orangeCircle"))
    var WConstraint: NSLayoutConstraint?
    var HConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    var animating: Bool = false
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView) {
        self.animating = false
        self.backgroundColor = .clear //.blue.withAlphaComponent(0.25)
        container.addSubview(self)
        
        self.trailingConstraint = self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0)
        
        self.activateConstraints([
            self.trailingConstraint!,
            self.bottomConstraint!,
            self.widthAnchor.constraint(equalToConstant: CIRCLE_SIZE*2),
            self.heightAnchor.constraint(equalToConstant: CIRCLE_SIZE*2)
        ])
        
        self.addSubview(self.circle)
        self.WConstraint = self.circle.widthAnchor.constraint(equalToConstant: CIRCLE_SIZE)
        self.HConstraint = self.circle.heightAnchor.constraint(equalToConstant: CIRCLE_SIZE)
        self.circle.activateConstraints([
            WConstraint!, HConstraint!,
            self.circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.circle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func startAnimation() {
        self.animating = true
        self.circle.alpha = 0.4

        self.WConstraint?.constant = CIRCLE_SIZE*2
        self.HConstraint?.constant = CIRCLE_SIZE*2
        UIView.animate(withDuration: 2.0) {
            self.circle.alpha = 0.0
            self.layoutIfNeeded()
        } completion: { _ in
            self.WConstraint?.constant = self.CIRCLE_SIZE
            self.HConstraint?.constant = self.CIRCLE_SIZE

            if(self.animating) {
                DELAY(0.1) {
                    self.startAnimation()
                }
            }
        }
    }
    
    func stopAnimation() {
        self.hide()
        self.layer.removeAllAnimations()
        self.circle.layer.removeAllAnimations()
        self.animating = false
    }

}
