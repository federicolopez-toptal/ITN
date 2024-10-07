//
//  ControversyCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import UIKit

protocol ControversyCellViewDelegate: AnyObject {
    func controversyCellViewOnFigureTap(sender: ControversyCellView?)
}


class ControversyCellView: UIView {

    weak var delegate: ControversyCellViewDelegate?
    let resolvedViewHeight: CGFloat = 80

    let M: CGFloat = 16
    private var WIDTH: CGFloat = 1
    private var showBottom: Bool = true
    var mainHeightConstraint: NSLayoutConstraint?
    var statusTopConstraint: NSLayoutConstraint?
    
    let figuresContainerView = UIView()
    let gradientView = UIView()
    let startLabel = UILabel()
    let endLabel = UILabel()
    
    let preStatusLabel = UILabel()
    let statusLabel = UILabel()
    
    let titleLabel = UILabel()
    let pill = UILabel()
    let timeLabel = UILabel()
    
    var figureSlugs = [String]()
    let buttonArea = UIButton(type: .custom)
    var controversySlug: String = ""
    var figureSlug: String = ""

    var mustShowChartFlag = true
    var statusLabelTextColor = UIColor.black

    var mainImageView: UIImageView!
    var mainImageViewHeightConstraint: NSLayoutConstraint?

    let resolutionDataLabel = UILabel()
    let resolvedDataLabel = UILabel()


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
            self.mainImageView = UIImageView()
            self.mainImageView.contentMode = .scaleAspectFill
            self.mainImageView.clipsToBounds = true
            self.mainImageView.backgroundColor = CSS.shared.displayMode().imageView_bgColor
            self.addSubview(self.mainImageView)
            self.mainImageView.activateConstraints([
                self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
                self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
                self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: M),
            ])
            
            var imgHeight: CGFloat = (self.WIDTH * 9)/16
            imgHeight /= 2.5
            
            self.mainImageViewHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: imgHeight)
            self.mainImageViewHeightConstraint?.isActive = true
        
            self.preStatusLabel.font = DM_SERIF_DISPLAY_resize(18) //IPHONE() ? DM_SERIF_DISPLAY(20) : DM_SERIF_DISPLAY(32)
            self.preStatusLabel.textColor = CSS.shared.displayMode().sec_textColor
            self.preStatusLabel.text = "Status:"
            self.addSubview(self.preStatusLabel)
            self.preStatusLabel.activateConstraints([
                self.preStatusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M)
                //,self.preStatusLabel.topAnchor.constraint(equalTo: self.startLabel.bottomAnchor, constant: 24)
            ])
            
            self.statusTopConstraint = self.preStatusLabel.topAnchor.constraint(equalTo: self.topAnchor,
                constant: M + 84 + 8 + 4  + 18 + 24)
            self.statusTopConstraint?.isActive = true
            
            
            //status2Label.backgroundColor = .yellow.withAlphaComponent(0.25)
            self.statusLabel.font = self.preStatusLabel.font
            self.statusLabel.textColor = CSS.shared.displayMode().main_textColor
            //if(status.lowercased() == "resolved"){ status2Label.textColor = CSS.shared.cyan }
            //status2Label.text = status
            self.addSubview(self.statusLabel)
            self.statusLabel.activateConstraints([
                self.statusLabel.leadingAnchor.constraint(equalTo: self.preStatusLabel.trailingAnchor, constant: M/2),
                self.statusLabel.topAnchor.constraint(equalTo: self.preStatusLabel.topAnchor)
            ])
            
            self.titleLabel.numberOfLines = 0
            self.titleLabel.font = DM_SERIF_DISPLAY_resize(22)
            self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
            self.addSubview(self.titleLabel)
            self.titleLabel.activateConstraints([
                self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: M),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -M),
                self.titleLabel.topAnchor.constraint(equalTo: self.statusLabel.bottomAnchor, constant: 10)
            ])
        
            self.pill.text = "CONTROVERSY"
            self.pill.font = AILERON(12)
            self.pill.textAlignment = .center
            self.pill.textColor = UIColor(hex: 0x19191C)
            self.pill.backgroundColor = UIColor(hex: 0x60C4D6)
            self.addSubview(self.pill)
            self.pill.activateConstraints([
                self.pill.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: M),
                self.pill.widthAnchor.constraint(equalToConstant: 120),
                self.pill.heightAnchor.constraint(equalToConstant: 24),
                self.pill.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
            ])
            self.pill.layer.cornerRadius = 12
            self.pill.clipsToBounds = true
            
            self.timeLabel.font = AILERON(12)
            self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
            self.addSubview(self.timeLabel)
            self.timeLabel.activateConstraints([
                self.timeLabel.leadingAnchor.constraint(equalTo: self.pill.trailingAnchor, constant: 12),
                self.timeLabel.centerYAnchor.constraint(equalTo: self.pill.centerYAnchor)
            ])
            
            self.buttonArea.backgroundColor = CSS.shared.displayMode().main_bgColor //.withAlphaComponent(0.25)
            self.addSubview(self.buttonArea)
            self.buttonArea.activateConstraints([
                self.buttonArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                self.buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
                self.buttonArea.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                self.buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
            ])
            self.buttonArea.addTarget(self, action: #selector(buttonAreaOnTap(_:)), for: .touchUpInside)
            self.sendSubviewToBack(self.buttonArea)
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
    
    @objc func buttonAreaOnTap(_ sender: UIButton?) {
        let vc = ControDetailViewController()
        vc.slug = self.controversySlug
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func mustShowChart(controversy: ControversyListItem) -> Bool {
        var result = true
        
        if(controversy.figures.count==0) {
            result = false
        }
        
        return result
    }
    
    func populate(with controversy: ControversyListItem, remark: String? = nil) {
        self.mustShowChartFlag = self.mustShowChart(controversy: controversy)
        
        self.controversySlug = controversy.slug
        self.addFigures(controversy.figures)
        
        self.titleLabel.text = controversy.title
        if let _remark = remark {
            self.titleLabel.remarkSearchTerm(_remark, color: CSS.shared.displayMode().main_textColor)
        }
        
        if(controversy.controversyType.uppercased() == "ELECTION_ISSUE") {
            self.pill.text = "ELECTION ISSUE"
            self.pill.font = AILERON_SEMIBOLD(12)
            self.pill.backgroundColor = UIColor(hex: 0xf4e457)
        } else {
            self.pill.text = "CONTROVERSY"
            self.pill.font = AILERON(12)
            self.pill.backgroundColor = UIColor(hex: 0x60C4D6)
        }
        
        var time = controversy.time
        if(time == "1 second ago"){ time = "JUST NOW" }
        self.timeLabel.text = time.uppercased()
        
        self.startLabel.text = controversy.textMin
        self.endLabel.text = controversy.textMax
        self.startLabel.show()
        self.endLabel.show()
        
        self.statusLabel.text = controversy.resolved
        self.statusLabel.textColor = CSS.shared.displayMode().main_textColor
        if(controversy.resolved.lowercased() == "resolved") {
            self.statusLabel.textColor = CSS.shared.cyan
        }
        self.statusLabelTextColor = self.statusLabel.textColor
        
        if(self.mustShowChartFlag) {
            if(self.mainImageView != nil) {
                self.mainImageView.hide()
            }
            
            if let _statusTopConstraint = self.statusTopConstraint {
                _statusTopConstraint.constant = M + 84 + 8 + 4  + 18 + 24
            }
        
            self.applyGradient(A: UIColor(hex: controversy.colorMin), B: UIColor(hex: controversy.colorMax))
            self.gradientView.show()
        } else {
            self.mainImageView.show()
            self.gradientView.hide()
            self.startLabel.hide()
            self.endLabel.hide()
            
            if let _statusTopConstraint = self.statusTopConstraint {
                var val = M
                if(!controversy.image_url.isEmpty) {
                    self.mainImageView.sd_setImage(with: URL(string: controversy.image_url))
                
                    if let _h = self.mainImageViewHeightConstraint {
                        val += _h.constant
                    }
                }
                
                _statusTopConstraint.constant = val + 8
            }
        }
        
        // Resolved (bottom)
        if(controversy.resolved.lowercased() == "resolved") {
            var resolvedView: UIStackView!

            if let _resolvedView = self.viewWithTag(696) as? UIStackView {
                resolvedView = _resolvedView
            } else {
                resolvedView = VSTACK(into: self)
                
                resolvedView.tag = 696
                resolvedView.backgroundColor = .clear //.orange
                resolvedView.activateConstraints([
                    resolvedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                    resolvedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                    resolvedView.topAnchor.constraint(equalTo: self.pill.bottomAnchor),
                    resolvedView.heightAnchor.constraint(equalToConstant: self.resolvedViewHeight)
                ])
                
                let resolutionLabel = UILabel()
                resolutionLabel.textColor = CSS.shared.displayMode().sec_textColor
                resolutionLabel.font = AILERON(15)
                resolutionLabel.text = "Resolution:"
                resolvedView.addSubview(resolutionLabel)
                resolutionLabel.activateConstraints([
                    resolutionLabel.leadingAnchor.constraint(equalTo: resolvedView.leadingAnchor),
                    resolutionLabel.topAnchor.constraint(equalTo: resolvedView.topAnchor, constant: 22)
                ])
                
                self.resolutionDataLabel.textColor = CSS.shared.cyan
                self.resolutionDataLabel.font = AILERON(15)
                self.resolutionDataLabel.text = "Lorem Ipsum"
                resolvedView.addSubview(self.resolutionDataLabel)
                self.resolutionDataLabel.activateConstraints([
                    self.resolutionDataLabel.leadingAnchor.constraint(equalTo: resolutionLabel.trailingAnchor, constant: 8),
                    self.resolutionDataLabel.topAnchor.constraint(equalTo: resolutionLabel.topAnchor)
                ])
                
                let resolvedLabel = UILabel()
                resolvedLabel.textColor = CSS.shared.displayMode().sec_textColor
                resolvedLabel.font = AILERON(15)
                resolvedLabel.text = "Resolved on:"
                resolvedView.addSubview(resolvedLabel)
                resolvedLabel.activateConstraints([
                    resolvedLabel.leadingAnchor.constraint(equalTo: resolvedView.leadingAnchor),
                    resolvedLabel.topAnchor.constraint(equalTo: resolutionLabel.bottomAnchor, constant: 8),
                ])
                
                self.resolvedDataLabel.textColor = CSS.shared.cyan
                self.resolvedDataLabel.font = AILERON(15)
                self.resolvedDataLabel.text = "Lorem Ipsum"
                resolvedView.addSubview(self.resolvedDataLabel)
                self.resolvedDataLabel.activateConstraints([
                    self.resolvedDataLabel.leadingAnchor.constraint(equalTo: resolvedLabel.trailingAnchor, constant: 8),
                    self.resolvedDataLabel.topAnchor.constraint(equalTo: resolvedLabel.topAnchor)
                ])
            }
            
            self.resolutionDataLabel.text = controversy.resolvedText
            self.resolvedDataLabel.text = controversy.resolvedDate
            
            resolvedView.show()
        } else {
            if let _resolvedView = self.viewWithTag(696) as? UIStackView {
                _resolvedView.hide()
            }
        }
        
        self.mainHeightConstraint?.constant = self.calculateHeight()
        self.refreshDisplayMode()
    }

    func refreshDisplayMode() {
        if(IPHONE()) {
            if let _line = self.viewWithTag(444) {
                REMOVE_ALL_SUBVIEWS(from: _line)
                ADD_HDASHES(to: _line)
            }
        } else {
            if let _borders = self.viewWithTag(444) as? RectangularDashedView {
                _borders.dashColor = CSS.shared.displayMode().line_color
            }
        }
        
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.startLabel.textColor = CSS.shared.displayMode().main_textColor
        self.endLabel.textColor = CSS.shared.displayMode().main_textColor
        self.preStatusLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.statusLabel.textColor = self.statusLabelTextColor
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.timeLabel.textColor = CSS.shared.displayMode().sec_textColor
    }

    func calculateHeight() -> CGFloat {
        let W = self.WIDTH - M - M
        
        var bottom: CGFloat = M
        if(self.showBottom) {
            bottom = 24 + self.statusLabel.calculateHeightFor(width: W) + 10 +
                self.titleLabel.calculateHeightFor(width: W) + M + 24 + M
        }
        var H: CGFloat = M + 84 + 8 + 4 + 8 + self.startLabel.calculateHeightFor(width: W) + bottom + (IPAD() ? 20 : 10)
        
        if(!self.mustShowChartFlag) {
            H = M + self.statusLabel.calculateHeightFor(width: W) + 10 +
                self.titleLabel.calculateHeightFor(width: W) + M + 24 + M +
                (IPAD() ? 20 : 10)
                
            if let _h = self.mainImageViewHeightConstraint {
                    H += _h.constant
            }
        }
        
        if(self.showBottom) {
            if let _resolvedView = self.viewWithTag(696), !_resolvedView.isHidden {
                H += self.resolvedViewHeight
            }
        }
        
        return H
    }

    func applyGradient(A: UIColor, B: UIColor) {
        self.gradientView.layer.sublayers = nil
        
        let newLayer = CAGradientLayer()
        newLayer.colors = [A.cgColor, B.cgColor]
        newLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        newLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        newLayer.frame = CGRect(x: 0, y: 0, width: self.WIDTH-M-M, height: 4)

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
        //self.figuresContainerView.backgroundColor = .orange
        REMOVE_ALL_SUBVIEWS(from: self.figuresContainerView)
        if(figures.count == 0) {
            self.figuresContainerView.hide()
            return
        }
        
        //var val_x: CGFloat = 0
        var nameDown = true
        
        self.figureSlugs = [String]()
        for (i, F) in figures.enumerated() {
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
            
//            let imgButton = UIButton(type: .custom)
//            //imgButton.backgroundColor = .red.withAlphaComponent(0.5)
//            self.figuresContainerView.addSubview(imgButton)
//            imgButton.activateConstraints([
//                imgButton.leadingAnchor.constraint(equalTo: figureImageView.leadingAnchor),
//                imgButton.topAnchor.constraint(equalTo: figureImageView.topAnchor),
//                imgButton.trailingAnchor.constraint(equalTo: figureImageView.trailingAnchor),
//                imgButton.bottomAnchor.constraint(equalTo: figureImageView.bottomAnchor)
//            ])
//            imgButton.tag = i
//            self.figureSlugs.append(F.slug)
//            imgButton.addTarget(self, action: #selector(imgButtonOnTap(_:)), for: .touchUpInside)
            
            var name = F.name.uppercased()
            if let lastName = name.components(separatedBy: " ").last {
                name = lastName
            }
            
            let nameLabel = UILabel()
            nameLabel.font = AILERON(9)
            nameLabel.textColor = CSS.shared.displayMode().sec_textColor
            //nameLabel.text = "  " + name + "  "
            nameLabel.text = name
            nameLabel.textAlignment = .center
            nameLabel.isUserInteractionEnabled = false
            nameLabel.backgroundColor = CSS.shared.displayMode().main_bgColor
            self.figuresContainerView.addSubview(nameLabel)
//            nameLabel.activateConstraints([
//                nameLabel.centerXAnchor.constraint(equalTo: figureImageView.centerXAnchor)
//            ])

            nameLabel.lineBreakMode = .byTruncatingTail
            nameLabel.activateConstraints([
                nameLabel.leadingAnchor.constraint(equalTo: figureImageView.leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: figureImageView.trailingAnchor)
            ])
            
            if(nameDown) {
                nameLabel.topAnchor.constraint(equalTo: figureImageView.bottomAnchor, constant: 4).isActive = true
            } else {
                nameLabel.topAnchor.constraint(equalTo: self.figuresContainerView.topAnchor, constant: 4).isActive = true
            }
            
            nameDown = !nameDown
        }
    }
    
    @objc func imgButtonOnTap(_ sender: UIButton?) {
        self.figureSlug = ""
        if let _index = sender?.tag {
            self.figureSlug = self.figureSlugs[_index]
        }
        
        if self.delegate != nil {
            self.delegate?.controversyCellViewOnFigureTap(sender: self)
        } else {
            let vc = FigureDetailsViewController()
            vc.slug = self.figureSlug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}
