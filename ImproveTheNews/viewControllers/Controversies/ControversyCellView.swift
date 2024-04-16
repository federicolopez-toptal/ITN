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
    private var showBottom: Bool = true
    var mainHeightConstraint: NSLayoutConstraint?
    
    let figuresContainerView = UIView()
    let gradientView = UIView()
    let startLabel = UILabel()
    let endLabel = UILabel()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, showBottom: Bool = true) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.showBottom = showBottom
        
        self.buildContent()
    }

    private func buildContent() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        //self.backgroundColor = .red
        
        if(IPHONE()) {
            let line = UIView()
            line.tag = 444
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
        
        self.addSubview(self.figuresContainerView)
        //self.figuresContainerView.backgroundColor = .orange
        self.figuresContainerView.activateConstraints([
            self.figuresContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
            self.figuresContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
            self.figuresContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: M),
            self.figuresContainerView.heightAnchor.constraint(equalToConstant: 84)
        ])
        
        self.addSubview(self.gradientView)
        self.gradientView.backgroundColor = .black
        self.gradientView.activateConstraints([
            self.gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
            self.gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
            self.gradientView.heightAnchor.constraint(equalToConstant: 4),
            self.gradientView.topAnchor.constraint(equalTo: self.figuresContainerView.bottomAnchor, constant: 8)
        ])
        
        self.addSubview(self.startLabel)
        self.startLabel.font = AILERON(12)
        self.startLabel.textAlignment = .left
        self.startLabel.textColor = CSS.shared.displayMode().main_textColor
        self.startLabel.activateConstraints([
            self.startLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
            self.startLabel.topAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: 8)
        ])
        self.startLabel.text = "LOW"
        
        self.addSubview(self.endLabel)
        self.endLabel.font = AILERON(12)
        self.endLabel.textAlignment = .right
        self.endLabel.textColor = CSS.shared.displayMode().main_textColor
        self.endLabel.activateConstraints([
            self.endLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
            self.endLabel.topAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: 8)
        ])
        self.endLabel.text = "HIGH"
        
        if(showBottom) {
            self.titleLabel.numberOfLines = 0
            self.titleLabel.font = DM_SERIF_DISPLAY(20)
            self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
            self.addSubview(self.titleLabel)
            self.titleLabel.activateConstraints([
                self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
                self.titleLabel.topAnchor.constraint(equalTo: self.startLabel.bottomAnchor, constant: M)
            ])
        
            let pill = UILabel()
            pill.text = "CONTROVERSY"
            pill.font = AILERON(12)
            pill.textAlignment = .center
            pill.textColor = CSS.shared.displayMode().main_bgColor
            pill.backgroundColor = UIColor(hex: 0x60C4D6)
            self.addSubview(pill)
            pill.activateConstraints([
                pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
                pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: M),
                pill.widthAnchor.constraint(equalToConstant: 120),
                pill.heightAnchor.constraint(equalToConstant: 24)
            ])
            pill.layer.cornerRadius = 12
            pill.clipsToBounds = true
            
            self.timeLabel.font = AILERON(12)
            self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
            self.addSubview(self.timeLabel)
            self.timeLabel.activateConstraints([
                self.timeLabel.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: 12),
                self.timeLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor)
            ])
        }
        
        if(IPAD()) {
            let borderBG = RectangularDashedView()
            borderBG.tag = 444
            
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
        self.addFigures(controversy.figures)
        self.titleLabel.text = controversy.title
        
        var time = controversy.time
        if(time == "1 second ago"){ time = "JUST NOW" }
        self.timeLabel.text = time
        
        self.startLabel.text = controversy.textMin
        self.endLabel.text = controversy.textMax
        
        self.mainHeightConstraint?.constant = self.calculateHeight()
        
        DELAY(0.1) { // It needs to update the layout
            self.applyGradient(A: UIColor(hex: controversy.colorMin), B: UIColor(hex: controversy.colorMax))
            self.gradientView.show()
        }

    }

    func calculateHeight() -> CGFloat {
        let W = self.WIDTH - M - M
        
        var bottom: CGFloat = M
        if(self.showBottom) {
            bottom = M + self.titleLabel.calculateHeightFor(width: W) + M + 24 + M
        }
        let H: CGFloat = M + 84 + 8 + 4 + 8 + self.startLabel.calculateHeightFor(width: W) + bottom + (IPAD() ? 20 : 0)
        
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
    
    func hideTopLine() {
        if let _lineView = self.viewWithTag(444) {
            _lineView.hide()
        }
    }

}

extension ControversyCellView {

    func addFigures(_ figures: [FigureForScale]) {
        //var val_x: CGFloat = 0
        var nameDown = true
        
        for F in figures {
            let limInf: CGFloat = 1.0
            let limSup: CGFloat = self.WIDTH-M-M-44
            
            // https://stackoverflow.com/questions/42817020/how-to-interpolate-from-number-in-one-range-to-a-corresponding-value-in-another
            let val_x = limInf + (limSup - limInf) * (CGFloat(F.scale) - 1.0) / (99.0 - 1.0) // interpolate
        
            let figureImageView = UIImageView()
            figureImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
            self.figuresContainerView.addSubview(figureImageView)
            figureImageView.activateConstraints([
                figureImageView.widthAnchor.constraint(equalToConstant: 44),
                figureImageView.heightAnchor.constraint(equalToConstant: 44),
                figureImageView.leadingAnchor.constraint(equalTo: self.figuresContainerView.leadingAnchor, constant: val_x),
                figureImageView.topAnchor.constraint(equalTo: self.figuresContainerView.topAnchor, constant: 20)
            ])
            figureImageView.layer.cornerRadius = 22
            figureImageView.clipsToBounds = true
            figureImageView.layer.borderColor = CSS.shared.displayMode().main_bgColor.cgColor
            figureImageView.layer.borderWidth = 2.0
            figureImageView.sd_setImage(with: URL(string: F.image))
            
            var name = F.name.uppercased()
            if let lastName = name.components(separatedBy: " ").last {
                name = lastName
            }
            
            let nameLabel = UILabel()
            nameLabel.font = AILERON(11)
            nameLabel.textColor = CSS.shared.displayMode().sec_textColor
            nameLabel.text = "  " + name + "  "
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = CSS.shared.displayMode().main_bgColor
            self.figuresContainerView.addSubview(nameLabel)
            nameLabel.activateConstraints([
                nameLabel.centerXAnchor.constraint(equalTo: figureImageView.centerXAnchor)
            ])
            
            if(nameDown) {
                nameLabel.topAnchor.constraint(equalTo: figureImageView.bottomAnchor, constant: 4).isActive = true
            } else {
                nameLabel.topAnchor.constraint(equalTo: self.figuresContainerView.topAnchor, constant: 4).isActive = true
            }
            
            nameDown = !nameDown
        }
    }
    
}
