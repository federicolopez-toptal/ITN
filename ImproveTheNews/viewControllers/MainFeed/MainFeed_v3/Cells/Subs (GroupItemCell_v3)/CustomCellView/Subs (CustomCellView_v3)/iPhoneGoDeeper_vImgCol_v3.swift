//
//  iPhoneGoDeeper_vImgCol_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/11/2023.
//

import Foundation
import UIKit


class iPhoneGoDeeper_vImgCol_v3: CustomCellView_v3 {

    var article: MainFeedArticle!
    private var WIDTH: CGFloat = 1
    var minimumLineNum: Bool = true

    private let imgWidth: CGFloat = 160
    private var imgHeight: CGFloat = 94
    
    let mainImageView = CustomImageView()
    
    var storyComponents = [UIView]()
        let storyTitleLabel = UILabel()
        let storyPill = StoryPillMiniView()
        let storyPillLabel = UILabel()
        let storySources = SourceIconsView(size: 24, border: 2, separation: 18)
        let storyTimeLabel = UILabel()
        let storyMoreSources = UILabel()
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat, minimumLineNum: Bool = true, imgHeight: CGFloat = 94) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.imgHeight = imgHeight
        self.minimumLineNum = minimumLineNum
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
        
    // Story
        self.storyTitleLabel.numberOfLines = 0
        self.storyTitleLabel.font = DM_SERIF_DISPLAY_resize(18)
        self.addSubview(self.storyTitleLabel)
        self.storyTitleLabel.activateConstraints([
            self.storyTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.storyTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.storyTitleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 8)
        ])
        storyComponents.append(self.storyTitleLabel)
        
        self.storySources.buildInto(self)
        self.storySources.activateConstraints([
            self.storySources.leadingAnchor.constraint(equalTo: self.storyTitleLabel.leadingAnchor),
            self.storySources.topAnchor.constraint(equalTo: self.storyTitleLabel.bottomAnchor, constant: 8),
        ])
        storyComponents.append(self.storySources)
        
        self.storyMoreSources.font = AILERON(13)
        self.addSubview(self.storyMoreSources)
        self.storyMoreSources.activateConstraints([
            self.storyMoreSources.centerYAnchor.constraint(equalTo: self.storySources.centerYAnchor),
            self.storyMoreSources.leadingAnchor.constraint(equalTo: self.storySources.trailingAnchor, constant: 8)
        ])
        
        self.storyPill.buildInto(self)
        self.storyPill.activateConstraints([
            self.storyPill.topAnchor.constraint(equalTo: self.storySources.bottomAnchor, constant: 8),
            self.storyPill.leadingAnchor.constraint(equalTo: self.storyTitleLabel.leadingAnchor)
        ])
        self.storyPill.hide()
        storyComponents.append(self.storyPill)
        
        let storyPillContainer = UIView()
        storyPillContainer.backgroundColor = .green
        self.addSubview(storyPillContainer)
        storyPillContainer.activateConstraints([
            storyPillContainer.leadingAnchor.constraint(equalTo: self.storyTitleLabel.leadingAnchor),
            storyPillContainer.topAnchor.constraint(equalTo: self.storySources.bottomAnchor, constant: 8),
            storyPillContainer.heightAnchor.constraint(equalToConstant: 24)
        ])
        storyPillContainer.layer.cornerRadius = 12
        
        self.storyPillLabel.font = AILERON(12)
        self.storyPillLabel.textColor = UIColor(hex: 0x19191C)
        self.storyPillLabel.textAlignment = .center
        self.storyPillLabel.text = "DIVE"
        storyPillContainer.addSubview(self.storyPillLabel)
        self.storyPillLabel.activateConstraints([
            self.storyPillLabel.heightAnchor.constraint(equalToConstant: 24),
            self.storyPillLabel.leadingAnchor.constraint(equalTo: storyPillContainer.leadingAnchor, constant: 11),
            self.storyPillLabel.topAnchor.constraint(equalTo: storyPillContainer.topAnchor)
        ])
        storyPillContainer.widthAnchor.constraint(equalTo: self.storyPillLabel.widthAnchor, constant: 22).isActive = true
        
        
        self.storyTimeLabel.font = AILERON(13)
        self.storyTimeLabel.textAlignment = .left
        self.addSubview(self.storyTimeLabel)
        self.storyTimeLabel.activateConstraints([
            self.storyTimeLabel.topAnchor.constraint(equalTo: storyPillContainer.bottomAnchor, constant: 8),
            self.storyTimeLabel.leadingAnchor.constraint(equalTo: self.storyTitleLabel.leadingAnchor)
        ])
        storyComponents.append(self.storyTimeLabel)
        
        // -------------------
        self.refreshDisplayMode()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article
        
        if(self.imgHeight > 0) {
            self.mainImageView.load(url: article.imgUrl)
            self.mainImageView.showCorners(self.article.isStory)
        }
        
        ///
        self.storyTitleLabel.text = article.title
        if let _searchTerm = KeywordSearch.searchTerm {
            self.storyTitleLabel.remarkSearchTerm(_searchTerm, color: CSS.shared.displayMode().main_textColor)
        }
        
//        let _MAX_NUM_LINES = 3
//        if(self.minimumLineNum) {
//            let numLines = self.storyTitleLabel.calculateHeightFor(width: self.WIDTH) / self.storyTitleLabel.font.lineHeight
//            let diff = _MAX_NUM_LINES - Int(numLines)
//            if(diff>0) {
//                for _ in 1...diff {
//                    self.storyTitleLabel.text! += "\n"
//                }
//            }
//        }
        
        self.storySources.load(article.storySources)
        
        self.storyMoreSources.text = ""
        if(article.storySources.count>3) {
            let diff = article.storySources.count - 3
            self.storyMoreSources.text = "+" + String(diff)
        }
        
//        var timeText = ""
//        if(article.storySources.count>3 && self.minimumLineNum) {
//            timeText = "+\(article.storySources.count-3)  •  "
//        }
//        timeText += SHORT_TIME(input: FIX_TIME(article.time)) + " AGO"
//            timeText += FIX_TIME(article.time).uppercased()

        self.storyTimeLabel.text = "UPDATED " + SHORT_TIME(input: FIX_TIME(article.time)) + " AGO"
        
        let type = article.summaryText.lowercased()
        
        if(type == "deepdive") {
            self.storyPillLabel.text = "DEEP DIVE"
            self.storyPillLabel.superview!.backgroundColor = UIColor(hex: 0xEFD80D)
        } else if(type == "context") {
            self.storyPillLabel.text = "CONTEXT"
            self.storyPillLabel.superview!.backgroundColor = UIColor(hex: 0x71D656)
        }
        
    }
    
    override func refreshDisplayMode() {
        self.storyTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        self.storySources.refreshDisplayMode()
        self.storyTimeLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.mainImageView.refreshDisplayMode()
        self.storyMoreSources.textColor = CSS.shared.displayMode().main_textColor
        self.backgroundColor = .clear
    }
    
    // MARK: misc
    private func calculateHeightForStory() -> CGFloat {
        return self.storyTitleLabel.calculateHeightFor(width: self.WIDTH)
    }
    
    func calculateHeight() -> CGFloat {
        var result: CGFloat = self.calculateImageViewHeight() + 8
        result += self.storyTitleLabel.calculateHeightFor(width: self.WIDTH-16) + 8 + 24 + 8 + 24 + 8
        result += self.storyTimeLabel.calculateHeightFor(width: self.WIDTH-16) + 8
        result += 32
        
        return result
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour_old?.cancel()
        if(self.article.isEmpty()) { return }
        
        let vc = StoryViewController()
        vc.story = self.article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
}
