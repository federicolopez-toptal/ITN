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
    let articleSource = SourceIconsView(size: 30, border: 2, separation: 15)
    let articleSourceTimeLabel = UILabel()
    let articleStanceIcon = StanceIconView()
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
        
        
        self.articleSource.buildInto(self)
        self.articleSource.activateConstraints([
            self.articleSource.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                constant: CSS.shared.iPhoneSide_padding),
            self.articleSource.topAnchor.constraint(equalTo: self.articleTitleLabel.bottomAnchor, constant: 12)
        ])
        articleComponents.append(self.articleSource)
        
        self.articleSourceTimeLabel.font = CSS.shared.iPhoneArticle_bigTextFont
        self.articleSourceTimeLabel.numberOfLines = 0
        self.articleSourceTimeLabel.textAlignment = .left
        self.addSubview(self.articleSourceTimeLabel)
        self.articleSourceTimeLabel.activateConstraints([
            self.articleSourceTimeLabel.centerYAnchor.constraint(equalTo: self.articleSource.centerYAnchor),
            self.articleSourceTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35)
        ])
        self.sourceTime_leading = self.articleSourceTimeLabel.leadingAnchor.constraint(equalTo: self.articleSource.trailingAnchor, constant: 5)
        self.sourceTime_leading?.isActive = true
        articleComponents.append(self.articleSourceTimeLabel)
        
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
        self.onStanceIconTap(sender: self.articleStanceIcon)
    
    
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
            
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: spin.media_title) {
            sourcesArray.append(_identifier)
        }
        self.articleSource.load(sourcesArray)
        
        self.articleSourceTimeLabel.text = CLEAN_SOURCE(from: spin.media_title).uppercased() + "    " +
            SHORT_TIME(input:FIX_TIME(spin.timeRelative))
        self.articleStanceIcon.setValues(spin.LR, spin.CP)
        
        for V in self.articleComponents {
            V.show()
        }
        
        
        if(PREFS_SHOW_SOURCE_ICONS()) {
            self.articleSource.show()
            self.sourceTime_leading?.constant = 5
        } else {
            self.articleSource.customHide()
            self.sourceTime_leading?.constant = 0
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
    }
    
    override func refreshDisplayMode() {
        self.articleTitleLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.articleSource.refreshDisplayMode()
        self.articleSourceTimeLabel.textColor = CSS.shared.displayMode().main_textColor
        self.articleStanceIcon.refreshDisplayMode()
        
        self.mainImageView.refreshDisplayMode()
    }
    
    // MARK: misc
    private func calculateHeightForArticle() -> CGFloat {
        return self.articleTitleLabel.calculateHeightFor(width: self.WIDTH) + 12 + 18
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding
        if(self.article == nil){ return 0 }
        result += self.calculateHeightForArticle()

        return result + 25
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour?.cancel()
        if(self.article.isEmpty()) { return }
    
        let vc = ArticleViewController()
        vc.article = article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
}

extension iPhoneArticle_vImg_v3: StanceIconViewDelegate {
    
    func onStanceIconTap(sender: StanceIconView) {
        let popup = StancePopupView()
        let sourceName = CLEAN_SOURCE(from: self.article.source)
        popup.populate(sourceName: sourceName, country: self.article.country,
            LR: self.article.LR, PE: self.article.PE)
        popup.pushFromBottom()
    }
    
}
