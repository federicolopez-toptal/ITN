//
//  FigureDetails_extras.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/03/2024.
//

import UIKit

extension FigureDetailsViewController {
    
    func W() -> CGFloat {
        if(IPHONE()) {
            return SCREEN_SIZE().width - (M*2)
        } else {
            return self.iPad_W
        }
    }
    
    func createContainerView(bgColor: UIColor = .clear, height: CGFloat? = nil) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = bgColor
        self.vStack.addArrangedSubview(containerView)
        
        if let _H = height {
            containerView.heightAnchor.constraint(equalToConstant: _H).isActive = true
        }
        
        return containerView
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
}
