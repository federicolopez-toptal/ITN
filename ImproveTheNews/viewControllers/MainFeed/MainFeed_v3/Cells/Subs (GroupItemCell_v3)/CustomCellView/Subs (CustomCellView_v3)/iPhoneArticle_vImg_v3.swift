//
//  iPhoneArticle_vImg_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/12/2023.
//

import Foundation
import UIKit

class iPhoneArticle_vImg_v3: CustomCellView_v3 {

    var article: MainFeedArticle!
    private var WIDTH: CGFloat = 1

    private let imgWidth: CGFloat = 370
    private let imgHeight: CGFloat = 213
    
    let mainImageView = CustomImageView()
        var articleComponents = [UIView]()
    let articleTitleLabel = UILabel()
    let articleFlag = FlagView(size: 30)
    let articleSource = SourceIconsView(size: 30, border: 2, separation: 15)
    let articleSourceNameLabel = UILabel()
    let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
    let articleTimeLabel = UILabel()
    let articleStanceIcon = StanceBigIconView()
    var sourceTime_leading: NSLayoutConstraint?
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        
        self.buildContent()
    }
    
    private func calculateImageViewHeight() -> CGFloat {
        if(TEXT_ONLY()) {
            return 0
        }
        
        let H = (self.WIDTH * imgHeight)/imgWidth
        return H
    }
    
    private func buildContent() {

        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.heightAnchor.constraint(equalToConstant: self.calculateImageViewHeight())
        ])
        self.mainImageView.setSmallLoading()
        
    // Article
        self.articleTitleLabel.numberOfLines = 0
        self.articleTitleLabel.font = CSS.shared.iPhoneArticle_bigTitleFont
        self.addSubview(self.articleTitleLabel)
        self.articleTitleLabel.activateConstraints([
            self.articleTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                constant: CSS.shared.iPhoneSide_padding),
            self.articleTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                constant: -CSS.shared.iPhoneSide_padding),
            self.articleTitleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        articleComponents.append(self.articleTitleLabel)
        
        self.articleFlag.buildInto(self)
        self.articleFlag.activateConstraints([
            self.articleFlag.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                constant: CSS.shared.iPhoneSide_padding),
            self.articleFlag.topAnchor.constraint(equalTo: self.articleTitleLabel.bottomAnchor, constant: 12+2)
        ])
        articleComponents.append(self.articleFlag)
        
        self.articleSource.buildInto(self)
        self.articleSource.activateConstraints([
            self.articleSource.leadingAnchor.constraint(equalTo: self.articleFlag.trailingAnchor,
                constant: 4),
            self.articleSource.topAnchor.constraint(equalTo: self.articleTitleLabel.bottomAnchor, constant: 12)
        ])
        articleComponents.append(self.articleSource)
        
        self.articleSourceNameLabel.font = CSS.shared.iPhoneArticle_bigTextFont
        self.articleSourceNameLabel.numberOfLines = 0
        self.articleSourceNameLabel.textAlignment = .left
        self.addSubview(self.articleSourceNameLabel)
        self.articleSourceNameLabel.activateConstraints([
            self.articleSourceNameLabel.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor)
        ])
        self.sourceTime_leading = self.articleSourceNameLabel.leadingAnchor.constraint(equalTo: self.articleSource.trailingAnchor, constant: 8)
        self.sourceTime_leading?.isActive = true
        articleComponents.append(self.articleSourceNameLabel)
        
        self.addSubview(self.openIcon)
        self.openIcon.activateConstraints([
            self.openIcon.widthAnchor.constraint(equalToConstant: 12),
            self.openIcon.heightAnchor.constraint(equalToConstant: 12),
            self.openIcon.centerYAnchor.constraint(equalTo: self.articleSourceNameLabel.centerYAnchor),
            self.openIcon.leadingAnchor.constraint(equalTo: self.articleSourceNameLabel.trailingAnchor, constant: 6)
        ])
        
        self.articleTimeLabel.font = self.articleSourceNameLabel.font
        self.addSubview(self.articleTimeLabel)
        self.articleTimeLabel.activateConstraints([
            self.articleTimeLabel.centerYAnchor.constraint(equalTo: self.articleSourceNameLabel.centerYAnchor),
            self.articleTimeLabel.leadingAnchor.constraint(equalTo: self.openIcon.trailingAnchor, constant: 6)
        ])
        
        self.addSubview(self.articleStanceIcon)
        self.articleStanceIcon.activateConstraints([
            self.articleStanceIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                constant: -CSS.shared.iPhoneSide_padding),
            self.articleStanceIcon.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor)
        ])
        self.articleStanceIcon.delegate = self
        articleComponents.append(self.articleStanceIcon)
        
        let stanceIconButton = UIButton(type: .system)
        //stanceIconButton.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(stanceIconButton)
        stanceIconButton.activateConstraints([
            stanceIconButton.leadingAnchor.constraint(equalTo: self.articleStanceIcon.leadingAnchor,
                constant: -10),
            stanceIconButton.trailingAnchor.constraint(equalTo: self.articleStanceIcon.trailingAnchor,
                constant: 10),
            stanceIconButton.topAnchor.constraint(equalTo: self.articleStanceIcon.topAnchor,
                constant: -10),
            stanceIconButton.bottomAnchor.constraint(equalTo: self.articleStanceIcon.bottomAnchor,
                constant: 10),
        ])
        stanceIconButton.tag = 64
        stanceIconButton.addTarget(self, action: #selector(stanceIconOnTap(_:)), for: .touchUpInside)
        
        self.refreshDisplayMode()
        // -------------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func stanceIconOnTap(_ sender: UIButton) {
        self.onStanceBigIconTap(sender: self.articleStanceIcon)
    
    
        //self.articleStanceIcon.viewOnTap(sender: nil)
        
//        let popup = StancePopupView()
//        popup.populate(sourceName: spin.media_name, country: spin.media_country_code,
//            LR: spin.LR, PE: spin.CP)
//        popup.pushFromBottom()
    }
    
    
    // MARK: Overrides
    func populate(spin: Spin) {
        self.article = MainFeedArticle(url: spin.url)
        self.article.LR = spin.LR
        self.article.PE = spin.CP
        self.article.country = spin.media_country_code
        self.article.source = spin.media_name
        ///

        self.mainImageView.load(url: spin.image) { (sucess, size) in
            
        }
        self.mainImageView.showCorners(false)
        
        //self.articleTitleLabel.font = CSS.shared.iPhoneStory_titleFont_small
        self.articleTitleLabel.text = spin.subTitle
        self.articleTitleLabel.setLineSpacing(lineSpacing: 6)
            
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: spin.media_title) {
            sourcesArray.append(_identifier)
        }
        self.articleSource.load(sourcesArray)
        
        let sourceName = CLEAN_SOURCE(from: spin.media_title).uppercased()
        self.articleSourceNameLabel.text = sourceName
        self.articleTimeLabel.text = SHORT_TIME(input:FIX_TIME(spin.timeRelative)) + " AGO"
        
//        self.articleSourceNameLabel.text = CLEAN_SOURCE(from: spin.media_title).uppercased() + "    " +
//            SHORT_TIME(input:FIX_TIME(spin.timeRelative))
        
        self.articleStanceIcon.setValues(spin.LR, spin.CP)
        
        for V in self.articleComponents {
            V.show()
        }
        
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.articleSource.show()
            self.sourceTime_leading?.constant = 8
        } else {
            self.articleSource.customHide()
            self.sourceTime_leading?.constant = 0
        }
        
        if(PREFS_SHOW_FLAGS()) {
            self.articleFlag.setFlag(spin.media_country_code)
            self.articleFlag.customShow()
//            self.source_leading?.constant = 2
            if(!PREFS_SHOW_SOURCE_ICONS()) {
                self.sourceTime_leading?.constant += 3
            }
        } else {
            self.articleFlag.customHide()
            //self.source_leading?.constant = 0
        }
        
        if(PREFS_SHOW_STANCE_ICONS()) {
            self.articleStanceIcon.show()
        } else {
            self.articleStanceIcon.hide()
        }
        
        if(spin.LR==0 && spin.CP==0) {
            if let button = self.viewWithTag(64) {
                button.hide()
                self.articleStanceIcon.hide()
            }
        }
        
        if(!PREFS_SHOW_SOURCE_ICONS() && !PREFS_SHOW_FLAGS()) {
            self.sourceTime_leading?.constant = 0
        }
    }
    
    override func refreshDisplayMode() {
        self.articleTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.articleSource.refreshDisplayMode()
        self.articleSourceNameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.articleTimeLabel.textColor = self.articleSourceNameLabel.textColor
        self.articleStanceIcon.refreshDisplayMode()
        self.openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
        
        self.mainImageView.refreshDisplayMode()
    }
    
    // MARK: misc
    private func calculateHeightForArticle() -> CGFloat {
        let W = self.WIDTH - (CSS.shared.iPhoneSide_padding * 2)
        
        return self.articleTitleLabel.calculateHeightFor(width: W) + 12 + 30 +
                CSS.shared.iPhoneSide_padding
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding
        if(self.article == nil){ return 0 }
        result += self.calculateHeightForArticle()

        return result
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour_old?.cancel()
        if(self.article.isEmpty()) { return }
    
        let vc = ArticleViewController()
        vc.article = article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
}

extension iPhoneArticle_vImg_v3: StanceBigIconViewDelegate {
    
    func onStanceBigIconTap(sender: StanceBigIconView) {
        let popup = StancePopupView()
        let sourceName = CLEAN_SOURCE(from: self.article.source)
        popup.populate(sourceName: sourceName, country: self.article.country,
            LR: self.article.LR, PE: self.article.PE)
        popup.pushFromBottom()
    }
    
}
