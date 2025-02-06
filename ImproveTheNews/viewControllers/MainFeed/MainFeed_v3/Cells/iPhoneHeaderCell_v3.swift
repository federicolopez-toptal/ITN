//
//  iPhoneHeaderCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2023.
//

import UIKit

class iPhoneHeaderCell_v3: UITableViewCell {

    static let identifier = "iPhoneHeaderCell_v3"

    let titleLabel = UILabel()
    let secTitleLabel = UILabel()
    var titleLeadingConstraint: NSLayoutConstraint? = nil

    var infoView: UIView? = nil

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        self.titleLabel.font = CSS.shared.iPhoneHeader_font
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
//            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: CSS.shared.iPhoneHeader_vMargins),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        self.titleLeadingConstraint = self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
            constant: CSS.shared.iPhoneSide_padding)
        self.titleLeadingConstraint?.isActive = true
        
        self.secTitleLabel.font = self.titleLabel.font
        self.secTitleLabel.text = "Your Fact Viewfinder"
        self.contentView.addSubview(self.secTitleLabel)
        
        self.secTitleLabel.activateConstraints([
            self.secTitleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.secTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                constant: -CSS.shared.iPhoneSide_padding)
        ])
        self.secTitleLabel.hide()
    }
    
    func populate(with item: DP3_headerItem, removePadding: Bool = false) {
        if(removePadding){ self.titleLeadingConstraint?.constant = 0 }
        self.titleLabel.text = item.title

        let titles = ["headlines"]

        var i = -1
        for (j, T) in titles.enumerated() {
            if(item.title.lowercased() == T) {
                i = j
                break
            }
        }

        if(i != -1) {
            self.addInfoButtonNextTo(label: self.titleLabel, index: i)
        } else {
            self.infoView?.hide()
        }

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.titleLabel.textColor = CSS.shared.displayMode().header_textColor
        self.secTitleLabel.textColor = CSS.shared.displayMode().main_textColor
    }
    
    func calculateHeight() -> CGFloat {
        let W = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 2)
        return self.titleLabel.calculateHeightFor(width: W) + (CSS.shared.iPhoneHeader_vMargins * 2)
    }

    //////////////////////////////////////////////////
    func addInfoButtonNextTo(label: UILabel, index: Int) {
        if let _superview = label.superview {
        if(self.infoView == nil) {
            
            self.infoView = UIView()
            self.infoView?.backgroundColor = .clear
            _superview.addSubview(self.infoView!)
            self.infoView?.activateConstraints([
                self.infoView!.widthAnchor.constraint(equalToConstant: 34),
                self.infoView!.heightAnchor.constraint(equalToConstant: 34),
                self.infoView!.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: IPHONE() ? 4 : 8),
                self.infoView!.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])
        
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: DisplayMode.imageName("storyInfo"))
            self.infoView!.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.centerYAnchor.constraint(equalTo: self.infoView!.centerYAnchor),
                iconImageView.centerXAnchor.constraint(equalTo: self.infoView!.centerXAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 32),
                iconImageView.heightAnchor.constraint(equalToConstant: 32)
            ])
            
            let button = UIButton(type: .custom)
            button.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            _superview.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -5),
                button.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
                button.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5)
            ])
            
            button.tag = index
            button.addTarget(self, action: #selector(infoButtonOnTap(_:)), for: .touchUpInside)
        }
        }
    }
    
    @objc func infoButtonOnTap(_ sender: UIButton?) {
        if let _sender = sender {
            let index = _sender.tag + 1
                        
            let popup = StoryInfoPopupView(title: self.getTitleFrom(index: index),
                    description: self.getDescriptionFrom(index: index),
                    linkedTexts: [], links: [], height: self.getHeightFor(index: index))
                
            popup.pushFromBottom()
        }
    }
    
    func getTitleFrom(index: Int) -> String {
        switch(index) {
            case 1:
                return "Headlines"
            case 2:
                return "B"
            case 3:
                return "C"
            case 4:
                return "D"
                
            default:
                return ""
        }
    }
    
    func getDescriptionFrom(index: Int) -> String {
        var descr = ""
        
        switch(index) {
            case 1:
                descr = """
        The latest news curated by our editorial team. We separate facts from spin to help you stay informed!
        """
        
            case 2:
                descr = """
        We neutrally provide the main arguments — or “narratives” — from different sides of the controversy, so you can make up your own mind on an issue and keep tabs on varying points of view. Depending on the topic, the narrative splits can be left v. right, Democratic v. Republican, pro-establishment (i.e. what all big US/Western parties and powers agree on) v. establishment critical, etc. Finally, for our readers interested in probability, we also strive to include a “Metaculus predictions” with a related prediction from the Metaculus community where possible.
        """
            case 3:
                descr = """
        We source our facts from a wide range of news outlets across the political and establishment spectrum, as well as supplementary primary sources (e.g. academic publications, social media posts by public figures, think tanks, NGOs, databases, etc.) where possible. We classify sources as left/right and pro-establishment/establishment-critical based on an MIT [0] on media bias conducted by Max Tegmark and Samantha D’Alonzo.
        """
            case 4:
                descr = """
        For those readers more interested in probability, we strive to include “Metaculus predictions” where possible. These provide forecasts of the most likely outcome of an event, according to the [0] prediction platform and aggregation engine. Framed as an interactive chart, you can further see how these predictions have changed over time by hovering over various points of the graph.
        """
        
            default:
                NOTHING()
        }
        
        
        return descr
    }

    func getHeightFor(index: Int) -> CGFloat {
        var result: CGFloat = 0
        
        switch(index) {
            case 1:
                return 165
                
            case 2:
                return 340
                
            case 3:
                return 310
                
            case 4:
                return 300
                
            default:
                NOTHING()
        }
        
        return result
    }

}
