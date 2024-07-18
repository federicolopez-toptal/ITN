//
//  FloatingButton.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/07/2024.
//

import UIKit

enum ArrowDirection {
    case up
    case down
}

// ---------------------------------------------
protocol FloatingButtonDelegate: AnyObject {
    func floatingButtonOnTap(sender: FloatingButton)
}

// ---------------------------------------------
class FloatingButton: UIView {

    weak var delegate: FloatingButtonDelegate?

    let size: CGFloat = 64
    let margin: CGFloat = 16
    
    let arrowImageView = UIImageView()
    

    // MARK: Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ containerView: UIView) {
        self.backgroundColor = .clear //.yellow.withAlphaComponent(0.5)
        
        containerView.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: self.size+self.margin),
            self.heightAnchor.constraint(equalToConstant: self.size+self.margin)
        ])
        
        let orange = UIView()
        orange.backgroundColor = CSS.shared.orange
        self.addSubview(orange)
        orange.activateConstraints([
            orange.widthAnchor.constraint(equalToConstant: self.size),
            orange.heightAnchor.constraint(equalToConstant: self.size),
            orange.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            orange.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        orange.layer.cornerRadius = self.size/2
        
        let slidersIcon = UIImageView(image: UIImage(named: "sliderIcons"))
        orange.addSubview(slidersIcon)
        slidersIcon.activateConstraints([
            slidersIcon.widthAnchor.constraint(equalToConstant: 27),
            slidersIcon.heightAnchor.constraint(equalToConstant: 22.3),
            slidersIcon.leadingAnchor.constraint(equalTo: orange.leadingAnchor, constant: 10.67),
            slidersIcon.centerYAnchor.constraint(equalTo: orange.centerYAnchor)
        ])
        
        orange.addSubview(self.arrowImageView)
        self.arrowImageView.activateConstraints([
            self.arrowImageView.widthAnchor.constraint(equalToConstant: 10.67),
            self.arrowImageView.heightAnchor.constraint(equalToConstant: 6.58),
            self.arrowImageView.trailingAnchor.constraint(equalTo: orange.trailingAnchor, constant: -10.67),
            self.arrowImageView.centerYAnchor.constraint(equalTo: orange.centerYAnchor),
        ])
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear //.black.withAlphaComponent(0.1)
        self.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: orange.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: orange.trailingAnchor),
            button.topAnchor.constraint(equalTo: orange.topAnchor),
            button.bottomAnchor.constraint(equalTo: orange.bottomAnchor)
        ])
        button.addTarget(self, action: #selector(buttonOnTap(_:)), for: .touchUpInside)
        
        self.pointTo(direction: .down)
    }

    @objc func buttonOnTap(_ sender: UIButton?) {
        self.delegate?.floatingButtonOnTap(sender: self)
    }

    func pointTo(direction: ArrowDirection) {
        if(direction == .down) {
            self.arrowImageView.image = UIImage(named: "arrowDown")
        } else {
            self.arrowImageView.image = UIImage(named: "arrowUp")
        }
    }
    
}
