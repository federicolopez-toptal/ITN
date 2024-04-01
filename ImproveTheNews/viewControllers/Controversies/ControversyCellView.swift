//
//  ControversyCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import UIKit

class ControversyCellView: UIView {

    let M: CGFloat = 16
    private var WIDTH: CGFloat = 1
    var mainHeightConstraint: NSLayoutConstraint?
    
    let gradientView = UIView()
    let titleLabel = UILabel()
    
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        
        self.buildContent()
    }

    private func buildContent() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        if(IPHONE()) {
            let line = UIView()
            line.backgroundColor = .green
            self.addSubview(line)
            line.activateConstraints([
                line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                line.topAnchor.constraint(equalTo: self.topAnchor),
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_HDASHES(to: line)
        }
        
        self.addSubview(self.gradientView)
        self.gradientView.backgroundColor = .black
        self.gradientView.activateConstraints([
            self.gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
            self.gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
            self.gradientView.heightAnchor.constraint(equalToConstant: 4),
            self.gradientView.topAnchor.constraint(equalTo: self.topAnchor, constant: M)
        ])
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = DM_SERIF_DISPLAY(18)
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
            self.titleLabel.topAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: M)
        ])
        
        if(IPAD()) {
            let borderBG = RectangularDashedView()
            
            borderBG.cornerRadius = 10
            borderBG.dashWidth = 1
            borderBG.dashColor = CSS.shared.displayMode().line_color
            borderBG.dashLength = 5
            borderBG.betweenDashesSpace = 5
            
            self.addSubview(borderBG)
            borderBG.activateConstraints([
                borderBG.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                borderBG.topAnchor.constraint(equalTo: self.topAnchor),
                borderBG.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                borderBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
            
            self.sendSubviewToBack(borderBG)
        }
        
        self.mainHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        self.mainHeightConstraint?.isActive = true
    }
    
    func populate(with controversy: ControversyListItem) {
        self.titleLabel.text = controversy.title
        self.mainHeightConstraint?.constant = self.calculateHeight()
        
        DELAY(0.1/4) { // It needs to update the layout
            self.applyGradient(A: UIColor(hex: controversy.colorMin), B: UIColor(hex: controversy.colorMax))
        }

    }

    func calculateHeight() -> CGFloat {
        let W = self.WIDTH - M - M
        let H: CGFloat = M + 4 +
            M + self.titleLabel.calculateHeightFor(width: W) + M +
            (IPAD() ? 20 : 0)
        
        return H
    }

    func applyGradient(A: UIColor, B: UIColor) {
        let newLayer = CAGradientLayer()
        newLayer.colors = [A.cgColor, B.cgColor]
        newLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        newLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        newLayer.frame = self.gradientView.bounds

        self.gradientView.layer.addSublayer(newLayer)
    }

}
