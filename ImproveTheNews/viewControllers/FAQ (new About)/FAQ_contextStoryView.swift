//
//  FAQ_contextStoryView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 17/10/2023.
//

import Foundation
import SDWebImage


class FAQ_contextStoryView: CustomCellView {

    private var article: MainFeedArticle!

    let mainImageView = ARTICLE_IMG()
    let pill = STORY_PILL(bgColor: UIColor(hex: 0x3FBC04), text: "CONTEXT")
    let titleLabel = ARTICLE_TITLE()
    let gradient = UIImageView()
    let gradientBottom = UIView()
    
    var storySourcesRow: UIStackView? = nil
    var sourcesRowHeight: NSLayoutConstraint?
    var storySources: UIStackView? = nil
    let storyTimeLabel = UILabel()
    


    // MARK: - Start
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.clipsToBounds = true
        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -22),
            self.mainImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        //---
        self.addSubview(gradientBottom)
        self.gradientBottom.activateConstraints([
            self.gradientBottom.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.gradientBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.gradientBottom.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gradientBottom.topAnchor.constraint(equalTo: self.topAnchor, constant: 135),
        ])
        
        //self.gradient.backgroundColor = .red.withAlphaComponent(0.5)
        self.addSubview(self.gradient)
        self.gradient.activateConstraints([
            self.gradient.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.gradient.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.gradient.bottomAnchor.constraint(equalTo: self.gradientBottom.topAnchor),
            self.gradient.heightAnchor.constraint(equalToConstant: 80),
        ])
        self.gradient.contentMode = .scaleToFill
        self.gradient.clipsToBounds = true
        //---
        
        let vStack = VSTACK(into: self)
        //vStack.backgroundColor = .green.withAlphaComponent(0.3)
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IPAD_INNER_MARGIN),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -IPAD_INNER_MARGIN),
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 90)
        ])

        let hStack_pill = HSTACK(into: vStack)
        hStack_pill.addArrangedSubview(self.pill)
        ADD_SPACER(to: hStack_pill)

        ADD_SPACER(to: vStack, height: 10)
        vStack.addArrangedSubview(self.titleLabel)
        //self.titleLabel.backgroundColor = .red.withAlphaComponent(0.3)

        ADD_SPACER(to: vStack, height: 14)
        self.storySourcesRow = HSTACK(into: vStack)
        self.sourcesRowHeight = self.storySourcesRow?.heightAnchor.constraint(equalToConstant: 18)
        self.storySourcesRow!.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.storySources = HSTACK(into: self.storySourcesRow!)
        self.storySources!.backgroundColor = .clear //.systemPink
        ADD_SPACER(to: self.storySourcesRow!)

        ADD_SPACER(to: vStack, height: 10)
        let bottomRow = HSTACK(into: vStack)
        //bottomRow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.storyTimeLabel.text = "Updated 2 hours ago"
        self.storyTimeLabel.textColor = UIColor(hex: 0x1D242F)
        self.storyTimeLabel.font = ROBOTO(14)
        //self.storyTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 1.0)
        self.storyTimeLabel.numberOfLines = 1
        //self.storyTimeLabel.backgroundColor = .red.withAlphaComponent(0.3)
        bottomRow.addArrangedSubview(self.storyTimeLabel)

        ADD_SPACER(to: bottomRow, width: 5)
        let arrowStack = VSTACK(into: bottomRow)
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        arrowStack.addArrangedSubview(arrow)
        arrow.activateConstraints([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        ADD_SPACER(to: arrowStack)

        vStack.superview?.bringSubviewToFront(vStack)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func getHeight(forColumnWidth columnW: CGFloat) -> CGFloat {
        let H: CGFloat = 90 + 23 + 10 + self.titleLabel.calculateHeightFor(width: columnW-(IPAD_INNER_MARGIN*2)) + 14 + 18 + 10 + 18 + 15
        return H
    }
    
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour?.cancel()
        if(article.isEmpty()){ return }

        let vc = StoryViewController()
        vc.story = self.article
        vc.isContext = true
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article

        self.mainImageView.image = nil
        if let _videoFile = article.videoFile {
            if let _url = URL(string: YOUTUBE_GET_THUMB_IMG(id: _videoFile)) {
                self.mainImageView.sd_setImage(with: _url)
            }
        }
        
        self.titleLabel.text = article.title
        self.pill.alpha = 1.0
        self.gradient.alpha = 1.0
        self.gradientBottom.alpha = 1.0

        if(PREFS_SHOW_SOURCE_ICONS()) {
            ADD_SOURCE_ICONS(data: article.storySources, to: self.storySources!)
            if(article.storySources.count == 0) {
                self.sourcesRowHeight?.constant = 0
            } else {
                self.sourcesRowHeight?.constant = 18
            }
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.storySources!)
        }

        self.storySourcesRow!.alpha = 1
        self.storyTimeLabel.text = "Updated " + article.time
        self.storyTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
        
        self.refreshDisplayMode()
        self.show()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.shortGradient"))
        self.gradientBottom.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE9EAEB)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.storyTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        //self.backgroundColor = .systemPink
    }
    
}



