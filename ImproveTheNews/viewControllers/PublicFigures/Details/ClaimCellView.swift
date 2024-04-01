//
//  ClaimCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/03/2024.
//

import UIKit

protocol ClaimCellViewDelegate: AnyObject {
    func claimCellViewOnHeightChanged(sender: ClaimCellView)
}


class ClaimCellView: UIView {

    weak var delegate: ClaimCellViewDelegate?

    private var WIDTH: CGFloat = 1
    var isOpen = false
    var mainHeightConstraint: NSLayoutConstraint?
    var sourceUrl: String = ""
    var twitterText: String = ""
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    var controversyLabel = UILabel()
    let sourceImageView = UIImageView()
    let sourceNameLabel = UILabel()
    let moreSourcesView = UIView()
    let moreSourcesLabel = UILabel()
    
    let parrafoView = UIView()
    var parrafoViewHeightConstraint: NSLayoutConstraint?
    let parrafoLabel = UILabel()
    let parrafoLabelOver = UILabel()
    
    var _fullDescription = ""
    var _textToRemark = ""
    var _remarkLocation = -1
    var _remarkLength = -1
    var _remarkLimit = -1
    
    let openButton = UIButton(type: .system)
    
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
        
        self.photoImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        self.addSubview(self.photoImageView)
        self.photoImageView.activateConstraints([
            self.photoImageView.widthAnchor.constraint(equalToConstant: 40),
            self.photoImageView.heightAnchor.constraint(equalToConstant: 40),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
        self.photoImageView.layer.cornerRadius = 20
        self.photoImageView.clipsToBounds = true
        
        let column = UIView()
        //column.backgroundColor = .orange.withAlphaComponent(0.1)
        self.addSubview(column)
        column.activateConstraints([
            column.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor, constant: 7),
            column.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            column.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            column.heightAnchor.constraint(equalToConstant: 2000)
        ])
        
        self.nameLabel.font = AILERON(14)
        self.nameLabel.textColor = CSS.shared.displayMode().main_textColor
        column.addSubview(self.nameLabel)
        self.nameLabel.activateConstraints([
            self.nameLabel.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            self.nameLabel.topAnchor.constraint(equalTo: column.topAnchor)
        ])
        
        self.timeLabel.font = AILERON(14)
        self.timeLabel.textAlignment = .left
        self.timeLabel.textColor = CSS.shared.displayMode().main_textColor
        column.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.timeLabel.topAnchor.constraint(equalTo: column.topAnchor)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(18)
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.titleLabel.numberOfLines = 0
        column.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 6)
        ])
        
        column.addSubview(self.parrafoView)
        //self.parrafoView.backgroundColor = .yellow
        self.parrafoView.activateConstraints([
            self.parrafoView.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            self.parrafoView.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.parrafoView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor)
        ])
        self.parrafoViewHeightConstraint = self.parrafoView.heightAnchor.constraint(equalToConstant: 0)
        self.parrafoViewHeightConstraint?.isActive = true
        self.parrafoView.hide()
        
        self.parrafoLabel.numberOfLines = 0
        self.parrafoLabel.font = AILERON(16)
        self.parrafoView.addSubview(self.parrafoLabel)
        self.parrafoLabel.activateConstraints([
            self.parrafoLabel.leadingAnchor.constraint(equalTo: self.parrafoView.leadingAnchor),
            self.parrafoLabel.trailingAnchor.constraint(equalTo: self.parrafoView.trailingAnchor),
            self.parrafoLabel.topAnchor.constraint(equalTo: self.parrafoView.topAnchor, constant: 16)
        ])
        
        self.parrafoLabelOver.numberOfLines = 0
        self.parrafoLabelOver.font = AILERON(16)
        self.parrafoView.addSubview(self.parrafoLabelOver)
        self.parrafoLabelOver.activateConstraints([
            self.parrafoLabelOver.leadingAnchor.constraint(equalTo: self.parrafoView.leadingAnchor),
            self.parrafoLabelOver.trailingAnchor.constraint(equalTo: self.parrafoView.trailingAnchor),
            self.parrafoLabelOver.topAnchor.constraint(equalTo: self.parrafoView.topAnchor, constant: 16)
        ])
        
        self.controversyLabel.font = AILERON(16)
        self.controversyLabel.textColor = CSS.shared.displayMode().main_textColor
        self.controversyLabel.numberOfLines = 0
        column.addSubview(self.controversyLabel)
        self.controversyLabel.activateConstraints([
            self.controversyLabel.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            self.controversyLabel.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.controversyLabel.topAnchor.constraint(equalTo: self.parrafoView.bottomAnchor, constant: 16)
        ])
        
        let buttonsContainer = UIView()
        //buttonsContainer.backgroundColor = .green.withAlphaComponent(0.1)
        column.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.topAnchor.constraint(equalTo: self.controversyLabel.bottomAnchor, constant: 20),
            buttonsContainer.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        self.openButton.setImage(UIImage(named: "cyanPlus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(self.openButton)
        self.openButton.activateConstraints([
            self.openButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            self.openButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            self.openButton.widthAnchor.constraint(equalToConstant: 32),
            self.openButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        self.openButton.addTarget(self, action: #selector(openButtonOnTap(_:)), for: .touchUpInside)
        
        let twitterButton = UIButton(type: .system)
        twitterButton.setImage(UIImage(named: "twitterCircle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(twitterButton)
        twitterButton.activateConstraints([
            twitterButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 8),
            twitterButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            twitterButton.widthAnchor.constraint(equalToConstant: 32),
            twitterButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        twitterButton.addTarget(self, action: #selector(twitterButtonOnTap(_:)), for: .touchUpInside)
        
        self.sourceImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        buttonsContainer.addSubview(self.sourceImageView)
        self.sourceImageView.activateConstraints([
            self.sourceImageView.leadingAnchor.constraint(equalTo: twitterButton.trailingAnchor, constant: 8),
            self.sourceImageView.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            self.sourceImageView.widthAnchor.constraint(equalToConstant: 32),
            self.sourceImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        self.sourceImageView.layer.cornerRadius = 16
        self.sourceImageView.clipsToBounds = true
        
        self.sourceNameLabel.font = AILERON(14)
        self.sourceNameLabel.textColor = CSS.shared.displayMode().main_textColor
        buttonsContainer.addSubview(self.sourceNameLabel)
        self.sourceNameLabel.activateConstraints([
            self.sourceNameLabel.leadingAnchor.constraint(equalTo: self.sourceImageView.trailingAnchor, constant: 8),
            self.sourceNameLabel.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
        ])
        
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
        openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        buttonsContainer.addSubview(openIcon)
        openIcon.activateConstraints([
            openIcon.leadingAnchor.constraint(equalTo: self.sourceNameLabel.trailingAnchor, constant: 4),
            openIcon.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
        ])
        
        let sourceButton = UIButton(type: .custom)
        //sourceButton.backgroundColor = .red.withAlphaComponent(0.5)
        buttonsContainer.addSubview(sourceButton)
        sourceButton.activateConstraints([
            sourceButton.leadingAnchor.constraint(equalTo: self.sourceImageView.leadingAnchor),
            sourceButton.topAnchor.constraint(equalTo: self.sourceImageView.topAnchor),
            sourceButton.bottomAnchor.constraint(equalTo: self.sourceImageView.bottomAnchor),
            sourceButton.trailingAnchor.constraint(equalTo: openIcon.trailingAnchor)
        ])
        sourceButton.addTarget(self, action: #selector(sourceButtonOnTap(_:)), for: .touchUpInside)
        
        //self.moreSourcesView.backgroundColor = .orange.withAlphaComponent(0.25)
        buttonsContainer.addSubview(self.moreSourcesView)
        self.moreSourcesView.activateConstraints([
            self.moreSourcesView.leadingAnchor.constraint(equalTo: openIcon.trailingAnchor, constant: 7),
            self.moreSourcesView.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            self.moreSourcesView.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor),
            self.moreSourcesView.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor)
        ])
        
        let vLine = UIView()
        vLine.backgroundColor = CSS.shared.displayMode().main_textColor
        self.moreSourcesView.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: self.moreSourcesView.leadingAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 1),
            vLine.heightAnchor.constraint(equalToConstant: 18),
            vLine.centerYAnchor.constraint(equalTo: self.moreSourcesView.centerYAnchor)
        ])
        
        self.moreSourcesLabel.font = AILERON(14)
        self.moreSourcesLabel.textColor = CSS.shared.displayMode().main_textColor
        self.moreSourcesView.addSubview(self.moreSourcesLabel)
        self.moreSourcesLabel.activateConstraints([
            self.moreSourcesLabel.leadingAnchor.constraint(equalTo: self.moreSourcesView.leadingAnchor, constant: 8),
            self.moreSourcesLabel.centerYAnchor.constraint(equalTo: self.moreSourcesView.centerYAnchor)
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
    
    @objc func twitterButtonOnTap(_ sender: UIButton?) {
        SHARE_ON_TWITTER(text: self.twitterText)
    }
    
    @objc func sourceButtonOnTap(_ sender: UIButton?) {
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: self.sourceUrl)
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func openButtonOnTap(_ sender: UIButton?) {
        if(!self.isOpen) {
            // Abro
            self.isOpen = true
            self.openButton.setImage(UIImage(named: DisplayMode.imageName("grayMinus"))?.withRenderingMode(.alwaysOriginal),
                 for: .normal)
            
            // Muestro contenido extra
            let W: CGFloat = self.WIDTH - 16 - 40 - 7 - 16
            self.parrafoViewHeightConstraint?.constant = 16 + self.parrafoLabel.calculateHeightFor(width: W)
            self.parrafoView.show()
            
            self.mainHeightConstraint?.constant = self.calculateHeight()
            self.layoutIfNeeded() // visual update
            
            self.delegate?.claimCellViewOnHeightChanged(sender: self)
            
            self.startDescriptionAnimation()
        } else {
            // Cierro
            self.isOpen = false
            self.openButton.setImage(UIImage(named: "cyanPlus")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            // Oculto contenido extra
            self.parrafoViewHeightConstraint?.constant = 0
            self.parrafoView.hide()
            
            self.mainHeightConstraint?.constant = self.calculateHeight()
            self.layoutIfNeeded() // visual update
            
            self.delegate?.claimCellViewOnHeightChanged(sender: self)
            
        }
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = self.WIDTH - 16 - 40 - 7 - 16
        let H: CGFloat = 16 + self.nameLabel.calculateHeightFor(width: W) +
            6 + self.titleLabel.calculateHeightFor(width: W) +
            16 + self.controversyLabel.calculateHeightFor(width: W) +
            20 + 32 +
            20 + (IPAD() ? 20 : 0)
        
        var extraH: CGFloat = 0
        if(self.isOpen) {
            extraH = 16 + self.parrafoLabel.calculateHeightFor(width: W)
        }

        return H + extraH
    }
    
    func populate(with claim: Claim) {
        self.photoImageView.sd_setImage(with: URL(string: claim.figureImage))
        self.nameLabel.text = claim.figureName.uppercased()
        self.timeLabel.text = claim.time.uppercased()
        self.titleLabel.text = claim.claim
        self.applyControversyFormatTo(self.controversyLabel, text: claim.controversyTitle)
        
        if let _firstSource = claim.sources.first {
            self.sourceNameLabel.text = _firstSource.name.uppercased()
            
            var id = _firstSource.strId
            if(id.isEmpty) {
                id = _firstSource.name
                id = id.replacingOccurrences(of: " ", with: "")
            }
            
            self.loadSource(id)
            self.sourceUrl = _firstSource.url
        }
        
        self.moreSourcesView.hide()
        if(claim.sources.count>1) {
            self.moreSourcesView.show()
            
            let text = "+\(claim.sources.count-1)" // MORE"
            let attributedString = NSMutableAttributedString(string: text, attributes: [
                .underlineStyle: 1
            ])
            self.moreSourcesLabel.attributedText = attributedString
        }
        
        self.twitterText = claim.figureName + ": " + claim.claim + " — according to @improvethenews. www.improvethenews.org/controversy/" + claim.controversySlug

        self.applyDescriptionFormatTo(self.parrafoLabel, text: claim.description, remark: claim.title)
        self.parrafoLabelOver.hide()

        self.mainHeightConstraint?.constant = self.calculateHeight()
    }
    
    func loadSource(_ source: String) {
        if let _icon = Sources.shared.search(identifier: source), _icon.url != nil {
            if(!_icon.url!.contains(".svg")) {
                sourceImageView.sd_setImage(with: URL(string: _icon.url!))
            } else {
                sourceImageView.image = UIImage(named: _icon.identifier + ".png")
            }
        } else {
            sourceImageView.image = UIImage(named: "LINK64")
        }
    }
}

// MARK: UILabel(s)
extension ClaimCellView {
    
    func applyControversyFormatTo(_ label: UILabel, text: String) {
        let prefix = "Controversy: "
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributedString = NSMutableAttributedString(string: prefix + text, attributes: [
            .font: AILERON(16),
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0x60C4D6) : UIColor(hex: 0x19191C),
            .underlineStyle: 1,
            .paragraphStyle: paragraphStyle
        ])
        
        let prefixAttributes: [NSAttributedString.Key: Any] = [
            .font: AILERON(16),
            .underlineStyle: 0,
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        ]
        let prefixAttributedString = NSAttributedString(string: prefix, attributes: prefixAttributes)
        let range = (attributedString.string as NSString).range(of: prefix)
        attributedString.replaceCharacters(in: range, with: prefixAttributedString)
        
        label.attributedText = attributedString
    }
    
    func applyDescriptionFormatTo(_ label: UILabel, text: String, remark: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let fullText = "... " + text + " ..."
        
        self._fullDescription = fullText
        self._textToRemark = remark
        
        // main label
        let mainAttrStr = NSMutableAttributedString(string: fullText, attributes: [
            .font: AILERON(16),
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C),
            .paragraphStyle :paragraphStyle
        ])
        
        label.attributedText = mainAttrStr
    }
    
    func startDescriptionAnimation() {
        let range = (self._fullDescription as NSString).range(of: self._textToRemark)

        self._remarkLocation = range.location
        self._remarkLength = 0
        self._remarkLimit = range.length
    
        self.animateDescriptionCharacter()
    }
    
    func animateDescriptionCharacter() {
        self._remarkLength += 1
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let secAttrStr = NSMutableAttributedString(string: self._fullDescription, attributes: [
            .font: AILERON(16),
            .foregroundColor: UIColor.clear,
            .paragraphStyle: paragraphStyle
        ])
                
        let remarkAttributes: [NSAttributedString.Key: Any] = [
            .font: AILERON(16),
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0x60C4D6) : UIColor(hex: 0x19191C),
            .backgroundColor: DARK_MODE() ? UIColor(hex: 0x2E4C54) : UIColor(hex: 0xA8DAE2)
        ]
        
//        let range = (secAttrStr.string as NSString).range(of: self._textToRemark)
        let range = NSRange(location: self._remarkLocation, length: self._remarkLength)
//        let remarkAttrStr = NSAttributedString(string: self._textToRemark, attributes: remarkAttributes)
        let subStr = self.subStr(from: self._textToRemark, start: 0, count: self._remarkLength)
        let remarkAttrStr = NSAttributedString(string: subStr, attributes: remarkAttributes)
        secAttrStr.replaceCharacters(in: range, with: remarkAttrStr)
        
        self.parrafoLabelOver.attributedText = secAttrStr
        self.parrafoLabelOver.show()
        
        if( (self._remarkLength<self._remarkLimit) && self.isOpen) {
            DELAY(0.1/14) {
                self.animateDescriptionCharacter()
            }
        }
    }
    
    private func subStr(from: String, start: Int, count: Int) -> String {
        var result = ""
        let limit = start + count
        
        for (i, C) in from.enumerated() {
            if(i>=start && i<limit) {
                result += String(C)
            }
        }
        
        return result
    }
    
}
