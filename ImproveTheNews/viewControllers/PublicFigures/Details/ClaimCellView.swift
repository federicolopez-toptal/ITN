//
//  ClaimCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/03/2024.
//

import UIKit
import WebKit


protocol ClaimCellViewDelegate: AnyObject {
    func claimCellViewOnHeightChanged(sender: ClaimCellView?)
    func claimCellViewOnFigureTap(sender: ClaimCellView?)
    func claimCellViewOnControversyTap(sender: ClaimCellView?)
}


class ClaimCellView: UIView {

    weak var delegate: ClaimCellViewDelegate?

    private var WIDTH: CGFloat = 1
    private var showControversyLink: Bool = true
    
    var isOpen = false
    var mainHeightConstraint: NSLayoutConstraint?
    var sourceUrl: String = ""
    
    var twitterText: String = ""
    var twitterUrl: String = ""
    
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let titleLabel = UILabel()
    
    let controversyView = UIView()
    var controversyViewHeightConstraint: NSLayoutConstraint?
    let controversyLabel = UILabel()
    
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
    
    var figureSlug: String = ""
    var controversySlug: String = ""
    
    var showMetaculusChart = false
    var webView: WKWebView?
    var chartExtraComponents = [UIView]()
    
    //let clickView = UIView()
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, showControversyLink: Bool = true) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.showControversyLink = showControversyLink
        
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
            line.tag = 555
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
        
        let imgButton = UIButton(type: .custom)
        //imgButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(imgButton)
        imgButton.activateConstraints([
            imgButton.leadingAnchor.constraint(equalTo: self.photoImageView.leadingAnchor),
            imgButton.topAnchor.constraint(equalTo: self.photoImageView.topAnchor),
            imgButton.trailingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor),
            imgButton.bottomAnchor.constraint(equalTo: self.photoImageView.bottomAnchor)
        ])
        imgButton.addTarget(self, action: #selector(imgButtonOnTap(_:)), for: .touchUpInside)
        
        let column = UIView()
        //column.backgroundColor = .orange
        self.addSubview(column)
        column.activateConstraints([
            column.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor, constant: 7),
            column.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            column.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            column.heightAnchor.constraint(equalToConstant: 2000)
        ])
        
        self.timeLabel.font = AILERON(14)
        self.timeLabel.textAlignment = .left
        self.timeLabel.textColor = CSS.shared.displayMode().main_textColor
        //self.timeLabel.backgroundColor = .red.withAlphaComponent(0.5)
        column.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.timeLabel.topAnchor.constraint(equalTo: column.topAnchor),
            self.timeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])

        self.nameLabel.font = AILERON(14)
        self.nameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.nameLabel.numberOfLines = 0
        //self.nameLabel.backgroundColor = .red.withAlphaComponent(0.25)
        column.addSubview(self.nameLabel)
        self.nameLabel.activateConstraints([
            self.nameLabel.topAnchor.constraint(equalTo: column.topAnchor),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.timeLabel.leadingAnchor, constant: -5),
            self.nameLabel.leadingAnchor.constraint(equalTo: column.leadingAnchor)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY_resize(18)
        self.titleLabel.textColor = CSS.shared.displayMode().main_textColor
        //self.titleLabel.backgroundColor = .red.withAlphaComponent(0.5)
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
        self.parrafoLabel.font = AILERON_resize(14)
        self.parrafoView.addSubview(self.parrafoLabel)
        self.parrafoLabel.activateConstraints([
            self.parrafoLabel.leadingAnchor.constraint(equalTo: self.parrafoView.leadingAnchor),
            self.parrafoLabel.trailingAnchor.constraint(equalTo: self.parrafoView.trailingAnchor),
            self.parrafoLabel.topAnchor.constraint(equalTo: self.parrafoView.topAnchor, constant: 16)
        ])
        
        self.parrafoLabelOver.numberOfLines = 0
        self.parrafoLabelOver.font = AILERON_resize(14)
        self.parrafoView.addSubview(self.parrafoLabelOver)
        self.parrafoLabelOver.activateConstraints([
            self.parrafoLabelOver.leadingAnchor.constraint(equalTo: self.parrafoView.leadingAnchor),
            self.parrafoLabelOver.trailingAnchor.constraint(equalTo: self.parrafoView.trailingAnchor),
            self.parrafoLabelOver.topAnchor.constraint(equalTo: self.parrafoView.topAnchor, constant: 16)
        ])
        
        // --- CONTROVERSY LABEL
        column.addSubview(self.controversyView)
        //self.controversyView.backgroundColor = .orange
        //self.parrafoView.backgroundColor = .red.withAlphaComponent(0.5)
        self.controversyView.activateConstraints([
            self.controversyView.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            self.controversyView.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            self.controversyView.topAnchor.constraint(equalTo: self.parrafoView.bottomAnchor, constant: 0)
        ])
        self.controversyViewHeightConstraint = self.controversyView.heightAnchor.constraint(equalToConstant: 0)
        self.controversyViewHeightConstraint?.isActive = true
        if(!self.showControversyLink) {
            self.controversyView.hide()
        }

        self.controversyLabel.font = AILERON_resize(16)
        self.controversyLabel.textColor = CSS.shared.displayMode().main_textColor
        self.controversyLabel.numberOfLines = 0
        self.controversyView.addSubview(self.controversyLabel)
        self.controversyLabel.activateConstraints([
            self.controversyLabel.leadingAnchor.constraint(equalTo: self.controversyView.leadingAnchor),
            self.controversyLabel.trailingAnchor.constraint(equalTo: self.controversyView.trailingAnchor),
            self.controversyLabel.topAnchor.constraint(equalTo: self.controversyView.topAnchor, constant: 16)
        ])
        
        

        // ----- PARRAFO BUTTON
        let parrafoButton = UIButton(type: .custom)
        //parrafoButton.backgroundColor = .green.withAlphaComponent(0.25)
        column.addSubview(parrafoButton)
        parrafoButton.activateConstraints([
            parrafoButton.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            parrafoButton.topAnchor.constraint(equalTo: self.nameLabel.topAnchor),
            parrafoButton.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            parrafoButton.bottomAnchor.constraint(equalTo: self.controversyLabel.bottomAnchor)
        ])
        parrafoButton.addTarget(self, action: #selector(parrafoButtonOnTap(_:)), for: .touchUpInside)
        // -----
        
        let buttonsContainer = UIView()
        //buttonsContainer.backgroundColor = .green.withAlphaComponent(0.1)
        column.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.topAnchor.constraint(equalTo: self.controversyView.bottomAnchor, constant: 24),
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
        self.openButton.addTarget(self, action: #selector(openButtonOnTap0(_:)), for: .touchUpInside)
        
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
        
        self.sourceNameLabel.font = AILERON(12)
        self.sourceNameLabel.numberOfLines = 2
        self.sourceNameLabel.lineBreakMode = .byTruncatingTail
        self.sourceNameLabel.textColor = CSS.shared.displayMode().main_textColor
        //self.sourceNameLabel.backgroundColor = .red.withAlphaComponent(0.5)
        
        buttonsContainer.addSubview(self.sourceNameLabel)
        self.sourceNameLabel.activateConstraints([
            self.sourceNameLabel.leadingAnchor.constraint(equalTo: self.sourceImageView.trailingAnchor, constant: 8),
            self.sourceNameLabel.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
        ])
        
        let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
        openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        buttonsContainer.addSubview(openIcon)
        openIcon.activateConstraints([
            openIcon.widthAnchor.constraint(equalToConstant: 12),
            openIcon.heightAnchor.constraint(equalToConstant: 12),
            openIcon.leadingAnchor.constraint(equalTo: self.sourceNameLabel.trailingAnchor, constant: 4),
            openIcon.topAnchor.constraint(equalTo: self.sourceNameLabel.topAnchor, constant: 1)
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
            borderBG.tag = 444
            
            self.addSubview(borderBG)
            borderBG.activateConstraints([
                borderBG.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                borderBG.topAnchor.constraint(equalTo: self.topAnchor),
                borderBG.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                borderBG.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
            
            self.sendSubviewToBack(borderBG)
        }
        
//        let alpha: CGFloat = 0.5
//        self.clickView.backgroundColor = DARK_MODE() ? .white : .black
//        self.clickView.hide()
        //.white.withAlphaComponent(alpha) : .black.withAlphaComponent(alpha)
        
        self.mainHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        self.mainHeightConstraint?.isActive = true
    }
    
    @objc func parrafoButtonOnTap(_ sender: UIButton?) {
        self.delegate?.claimCellViewOnControversyTap(sender: self)
    }
    
    @objc func imgButtonOnTap(_ sender: UIButton?) {
        self.delegate?.claimCellViewOnFigureTap(sender: self)
    }
    
    @objc func twitterButtonOnTap(_ sender: UIButton?) {
        //SHARE_ON_TWITTER(text: self.twitterText)
        SHARE_ON_TWITTER_2(url: self.twitterUrl, text: self.twitterText)
    }
    
    @objc func sourceButtonOnTap(_ sender: UIButton?) {
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: self.sourceUrl)
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func openButtonOnTap0(_ sender: UIButton?) {
        self.openButtonOnTap(sender, callDelegate: true)
    }
    
    func openButtonOnTap(_ sender: UIButton?, callDelegate: Bool) {
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
            
            if(callDelegate) {
                self.delegate?.claimCellViewOnHeightChanged(sender: self)
            }
            
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
            
            
            if(callDelegate) {
                self.delegate?.claimCellViewOnHeightChanged(sender: self)
            }
        }
    }
    
    func calculateHeight() -> CGFloat {
        if(self.showMetaculusChart) {
            var H = 16 + self.heightForChart() + 16
            if(IPAD()){ H += 16 }
            return H
        }
        
        let W: CGFloat = self.WIDTH - 16 - 40 - 7 - 16
        
        var controversyLabelHeight: CGFloat = 0
        if(self.showControversyLink){
            controversyLabelHeight = 16 + self.controversyLabel.calculateHeightFor(width: W)
        }
        
        let timeW = self.timeLabel.calculateWidthFor(height: 18)
        let H: CGFloat = 16 + self.nameLabel.calculateHeightFor(width: W-5-timeW) +
            6 + self.titleLabel.calculateHeightFor(width: W) + controversyLabelHeight +
            24 + 32 +
            20 + (IPAD() ? 20 : 0)
        
        var extraH: CGFloat = 0
        if(self.isOpen) {
            extraH = 16 + self.parrafoLabel.calculateHeightFor(width: W)
        }

        return H + extraH
    }
    
    func showComponents(_ state: Bool) {
        for V in self.subviews {
            if(V is WKWebView) {
            } else {
                V.isHidden = !state
            }
        }
    }
    
    func heightForChart() -> CGFloat {
        var W = self.WIDTH
        if(IPAD()){ W -= 32 }
        
        let H: CGFloat = (9 * W)/16

        return H
    }
    
    func populateForChart(with claim: Claim) {
        self.showMetaculusChart = true
        self.showComponents(false)
        
        // top line
        if let _line = self.viewWithTag(555) {
            _line.show()
        }
        // border
        if let _border = self.viewWithTag(444) {
            _border.show()
        }
        
        var iframeUrl = ""
        if let _firstSource = claim.sources.first {
            iframeUrl =  self.getMetaculusUrl(from: _firstSource.url)
        }
        
        if(self.webView == nil) {
            self.webView = WKWebView()
            self.addSubview(self.webView!)
            self.webView?.activateConstraints([
                self.webView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IPHONE() ? 0 : 16),
                self.webView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: IPHONE() ? 0 : -16),
                self.webView!.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
                self.webView!.heightAnchor.constraint(equalToConstant: self.heightForChart())
            ])
            self.webView!.navigationDelegate = self
            self.webView?.load(URLRequest(url: URL(string: iframeUrl)!))
        }
        
        self.webView?.isHidden = false
        self.mainHeightConstraint?.constant = self.calculateHeight()
    }
    
    func getMetaculusUrl(from url: String) -> String {
        var result: String = ""
    
        var parsed = url.replacingOccurrences(of: "https://www.metaculus.com/questions/", with: "")
        parsed = parsed.replacingOccurrences(of: "https://metaculus.com/questions/", with: "")
        
        if(!parsed.isEmpty) {
            for (i, CHR) in parsed.enumerated() {
                if(CHR=="/") {
                    if let _id = parsed.subString2(from: 0, count: i-1) {
                        result = ITN_URL() + "/php/metaculus.php?id=" + _id
                    }
                    break
                }
            }
        }

        if(!result.isEmpty) {
            result += "&mode="
            result += DARK_MODE() ? "dark" : "light"
        }
        
        print("METACULUS URL", result)
        return result
    }
    
    func populate(with claim: Claim) {
        self.showMetaculusChart = false
        self.showComponents(true)
        self.webView?.isHidden = true

        let W: CGFloat = self.WIDTH - 16 - 40 - 7 - 16
        self.figureSlug = claim.figureSlug
        self.controversySlug = claim.controversySlug
    
        self.photoImageView.sd_setImage(with: URL(string: claim.figureImage))
        self.nameLabel.text = claim.figureName.replacingOccurrences(of: "\n", with: "").uppercased()
        self.timeLabel.text = claim.time.uppercased()
        self.titleLabel.text = claim.claim
        
        self.applyControversyFormatTo(self.controversyLabel, text: claim.controversyTitle)
        if(self.showControversyLink) {
            self.controversyViewHeightConstraint?.constant = 16 + self.controversyLabel.calculateHeightFor(width: W)
        } else {
            self.controversyViewHeightConstraint?.constant = 0
        }
        
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
        
        self.twitterText = claim.figureName + ": " + claim.claim + " — according to @improvethenews."
        self.twitterUrl = ITN_URL() + "/controversy/" + claim.controversySlug
        
        self.applyDescriptionFormatTo(self.parrafoLabel, text: claim.description, remark: claim.title)
        self.parrafoLabel.setLineSpacing(lineSpacing: 8)
        self.parrafoLabelOver.hide()

        self.mainHeightConstraint?.constant = self.calculateHeight()
    }
    
    func loadSource(_ source: String) {
        var _source = source.lowercased()
        
        if let _icon = Sources.shared.search(identifier: _source), _icon.url != nil {
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
            .font: AILERON_resize(16),
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0x60C4D6) : UIColor(hex: 0x19191C),
            .underlineStyle: 1,
            .paragraphStyle: paragraphStyle
        ])
        
        let prefixAttributes: [NSAttributedString.Key: Any] = [
            .font: AILERON_resize(16),
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
            .font: AILERON_resize(14),
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
            .font: AILERON_resize(14),
            .foregroundColor: UIColor.clear,
            .paragraphStyle: paragraphStyle
        ])
                
        let remarkAttributes: [NSAttributedString.Key: Any] = [
            .font: AILERON_resize(14),
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
        self.parrafoLabelOver.setLineSpacing(lineSpacing: 8)
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

extension ClaimCellView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.mainDocumentURL?.absoluteString {
            if(url.contains("metaculus.php")) {
                decisionHandler(.allow)
            } else if(url.contains("metaculus.com")) {
                let vc = ArticleViewController()
                vc.article = MainFeedArticle(url: url)
                vc.showComponentsOnClose = false
                vc.altTitle = "Metaculus"
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                decisionHandler(.cancel)
            }
        }
    }
}
