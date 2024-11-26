//
//  MetaculusClaimCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/03/2024.
//

import UIKit
import WebKit


protocol ClaimMetaculusCellViewDelegate: AnyObject {
    func claimMetaculusCellViewOnHeightChanged(sender: MetaculusClaimCellView?)
    func claimMetaculusCellViewOnFigureTap(sender: MetaculusClaimCellView?)
    func claimMetaculusCellViewOnControversyTap(sender: MetaculusClaimCellView?)
}


class MetaculusClaimCellView: UIView {

    weak var delegate: ClaimMetaculusCellViewDelegate?

    private var WIDTH: CGFloat = 1
    
    var isOpen = false
    var figureSlug: String = ""
    var controversySlug: String = ""
    var mainHeightConstraint: NSLayoutConstraint?
        
    let componentsContainer = UIView()
    let photoImageView = UIImageView()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
        
    let browserContainer = UIView()
    let webView = WKWebView()
        
    
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
            line.tag = 555
            ADD_HDASHES(to: line)
        }
        
        //self.componentsContainer.backgroundColor = .green
        self.addSubview(self.componentsContainer)
        self.componentsContainer.activateConstraints([
            self.componentsContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.componentsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.componentsContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.componentsContainer.heightAnchor.constraint(equalToConstant: 1000)
        ])
        
        // ---
        self.photoImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        self.componentsContainer.addSubview(self.photoImageView)
        self.photoImageView.activateConstraints([
            self.photoImageView.widthAnchor.constraint(equalToConstant: 40),
            self.photoImageView.heightAnchor.constraint(equalToConstant: 40),
            self.photoImageView.leadingAnchor.constraint(equalTo: self.componentsContainer.leadingAnchor),
            self.photoImageView.topAnchor.constraint(equalTo: self.componentsContainer.topAnchor)
        ])
        self.photoImageView.layer.cornerRadius = 20
        self.photoImageView.clipsToBounds = true
        
        let imgButton = UIButton(type: .custom)
        //imgButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.componentsContainer.addSubview(imgButton)
        imgButton.activateConstraints([
            imgButton.leadingAnchor.constraint(equalTo: self.photoImageView.leadingAnchor),
            imgButton.topAnchor.constraint(equalTo: self.photoImageView.topAnchor),
            imgButton.trailingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor),
            imgButton.bottomAnchor.constraint(equalTo: self.photoImageView.bottomAnchor)
        ])
        imgButton.addTarget(self, action: #selector(imgButtonOnTap(_:)), for: .touchUpInside)
        
        let column = UIView()
        //column.backgroundColor = .orange
        self.componentsContainer.addSubview(column)
        column.activateConstraints([
            column.leadingAnchor.constraint(equalTo: self.photoImageView.trailingAnchor, constant: 7),
            column.trailingAnchor.constraint(equalTo: self.componentsContainer.trailingAnchor),
            column.topAnchor.constraint(equalTo: self.componentsContainer.topAnchor),
            column.heightAnchor.constraint(equalToConstant: 1000)
        ])
        
        self.nameLabel.font = AILERON(14)
        self.nameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.nameLabel.numberOfLines = 0
        //self.nameLabel.backgroundColor = .red.withAlphaComponent(0.25)
        column.addSubview(self.nameLabel)
        self.nameLabel.activateConstraints([
            self.nameLabel.topAnchor.constraint(equalTo: column.topAnchor),
            self.nameLabel.trailingAnchor.constraint(equalTo: column.trailingAnchor),
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

        let buttonsContainer = UIView()
        //buttonsContainer.backgroundColor = .green.withAlphaComponent(0.1)
        column.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24),
            buttonsContainer.leadingAnchor.constraint(equalTo: column.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: column.trailingAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let openButton = UIButton(type: .system)
        openButton.setImage(UIImage(named: "cyanPlus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(openButton)
        openButton.activateConstraints([
            openButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor),
            openButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            openButton.widthAnchor.constraint(equalToConstant: 32),
            openButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        openButton.addTarget(self, action: #selector(openButtonOnTap0(_:)), for: .touchUpInside)
        
    /* */
        //self.browserContainer.backgroundColor = .green
        self.addSubview(self.browserContainer)
        self.browserContainer.activateConstraints([
            self.browserContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.browserContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.browserContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.browserContainer.heightAnchor.constraint(equalToConstant: self.heightForChart() + 16 + 32)
        ])
        
        self.browserContainer.addSubview(self.webView)
        self.webView.activateConstraints([
            self.webView.leadingAnchor.constraint(equalTo: self.browserContainer.leadingAnchor,
                constant: IPHONE() ? 0 : 16),
            self.webView.trailingAnchor.constraint(equalTo: self.browserContainer.trailingAnchor,
                constant: IPHONE() ? 0 : -16),
            self.webView.topAnchor.constraint(equalTo: self.browserContainer.topAnchor),
            self.webView.heightAnchor.constraint(equalToConstant: self.heightForChart())
        ])
        self.webView.navigationDelegate = self
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: DisplayMode.imageName("grayMinus"))?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.browserContainer.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.trailingAnchor.constraint(equalTo: self.browserContainer.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(equalTo: self.browserContainer.bottomAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        closeButton.addTarget(self, action: #selector(openButtonOnTap0(_:)), for: .touchUpInside)
        
        
    /* */
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
                
        self.mainHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        self.mainHeightConstraint?.isActive = true
    }
    
    @objc func imgButtonOnTap(_ sender: UIButton?) {
        self.delegate?.claimMetaculusCellViewOnFigureTap(sender: self)
    }
    
    @objc func openButtonOnTap0(_ sender: UIButton?) {
        self.openButtonOnTap(sender, callDelegate: true)
    }
    
    func openButtonOnTap(_ sender: UIButton?, callDelegate: Bool) {
        self.isOpen = !self.isOpen

        if(self.isOpen) {
            self.componentsContainer.show()
            
            UIView.animate(withDuration: 0.3) {
                self.browserContainer.alpha = 0
                self.layoutIfNeeded()
            } completion: { _ in
                self.browserContainer.hide()
            }
            
        } else {
            self.componentsContainer.hide()
            
            self.browserContainer.show()
            self.browserContainer.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.browserContainer.alpha = 1
                self.layoutIfNeeded()
            }
        }

        self.mainHeightConstraint?.constant = self.calculateHeight()
        self.layoutIfNeeded() // visual update
        
        if(callDelegate) {
            self.delegate?.claimMetaculusCellViewOnHeightChanged(sender: self)
        }

        
    }
    
    func calculateHeight() -> CGFloat {
        var _H: CGFloat = 0
        
        if(self.isOpen) {
            let colWidth: CGFloat = self.WIDTH-16-40-7-16
        
            _H = 16 + self.nameLabel.calculateHeightFor(width: colWidth) +
                6 + self.titleLabel.calculateHeightFor(width: colWidth) +
                24 + 32 + 16
        } else {
            _H = 16 + self.heightForChart() + 16+32+16
        }
        
        if(IPAD()) {
            _H += 16
        }
        
        return _H
    }
    
    func heightForChart() -> CGFloat {
        var W = self.WIDTH
        if(IPAD()){ W -= 32 }
        
        let H: CGFloat = (9 * W)/16

        return H
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
        let W: CGFloat = self.WIDTH - 16 - 40 - 7 - 16
        self.figureSlug = claim.figureSlug
        self.controversySlug = claim.controversySlug
    
        self.photoImageView.sd_setImage(with: URL(string: claim.figureImage))
        self.nameLabel.text = claim.figureName.uppercased()
        self.titleLabel.text = claim.claim
        
        var iframeUrl = ""
        if let _firstSource = claim.sources.first {
            iframeUrl =  self.getMetaculusUrl(from: _firstSource.url)
        }
        self.webView.load(URLRequest(url: URL(string: iframeUrl)!))
        
        self.mainHeightConstraint?.constant = self.calculateHeight()
    }

}

extension MetaculusClaimCellView: WKNavigationDelegate {
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
