//
//  ColumnsCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/09/2022.
//

import UIKit

class ColumnsCell: UITableViewCell {

    static let identifier = "ColumnsCell"

    private let mainHStack = UIStackView()
    private var storyFlags = [false, false]

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ColumnsCell {
    
    func buildContent() {
        self.backgroundColor = .white
        
        self.mainHStack.backgroundColor = .clear //.orange
        self.mainHStack.spacing = 22
        self.addSubview(mainHStack)
        self.mainHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.mainHStack.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -16),
            self.mainHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0) //-16
        ])
        
        let W: CGFloat = (SCREEN_SIZE().width - (16*2) - 22)/2
        let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 15)
        let roboto_bold = UIFont(name: "Roboto-Bold", size: 10)
        let characterSpacing: Double = 1.35
        
        for _ in 1...2 {
            let itemVStack = VSTACK(into: self.mainHStack)
            itemVStack.backgroundColor = .green
            itemVStack.spacing = 10
            NSLayoutConstraint.activate([
                itemVStack.widthAnchor.constraint(equalToConstant: W)
            ])
            
            let mainImageView = UIImageView()
            mainImageView.backgroundColor = .gray
            itemVStack.addArrangedSubview(mainImageView)
            mainImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainImageView.leadingAnchor.constraint(equalTo: itemVStack.leadingAnchor),
                mainImageView.trailingAnchor.constraint(equalTo: itemVStack.trailingAnchor),
                mainImageView.topAnchor.constraint(equalTo: itemVStack.topAnchor),
                mainImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
            mainImageView.contentMode = .scaleAspectFill
            mainImageView.clipsToBounds = true
            
            let titleLabel = UILabel()
            titleLabel.backgroundColor = .yellow
            titleLabel.textColor = UIColor(hex: 0x1D242F)
            titleLabel.numberOfLines = 4
            titleLabel.font = merriweather_bold
            titleLabel.text = "Vaccine required for NHS health care workers"
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.65
            itemVStack.addArrangedSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: itemVStack.leadingAnchor, constant: 5),
                titleLabel.trailingAnchor.constraint(equalTo: itemVStack.trailingAnchor, constant: -5),
            ])
            
            // ---------
            let gradient = UIImageView()
            gradient.backgroundColor = .clear
            itemVStack.addSubview(gradient)
            gradient.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                gradient.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
                gradient.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
                gradient.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
                gradient.heightAnchor.constraint(equalToConstant: 42)
            ])
            gradient.contentMode = .scaleToFill
            gradient.clipsToBounds = true
            
            let storyLabel = UILabel()
            storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
            storyLabel.textColor = .white
            storyLabel.text = "STORY"
            storyLabel.textAlignment = .center
            storyLabel.font = roboto_bold
            storyLabel.layer.masksToBounds = true
            storyLabel.layer.cornerRadius = 12
            storyLabel.addCharacterSpacing(kernValue: characterSpacing)
            itemVStack.addSubview(storyLabel)
            storyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                storyLabel.widthAnchor.constraint(equalToConstant: 55),
                storyLabel.heightAnchor.constraint(equalToConstant: 23),
                storyLabel.leadingAnchor.constraint(equalTo: itemVStack.leadingAnchor, constant: 6),
                storyLabel.bottomAnchor.constraint(equalTo: gradient.bottomAnchor)
            ])
            
            // ---------------------
            let sourcesContainer = UIStackView()
            sourcesContainer.backgroundColor = .orange
            itemVStack.addArrangedSubview(sourcesContainer)
            
            ADD_SPACER(to: itemVStack)
        }
    }
    
    func populate(with articles: [MainFeedArticle?]) {
        
        self.storyFlags = [false, false]
        for (i, view) in self.mainHStack.arrangedSubviews.enumerated() {
            let vStack = view as! UIStackView

            if let _A = articles[i] {
                let imageView = vStack.arrangedSubviews[0] as! UIImageView
                imageView.image = nil
                if let _url = URL(string: _A.imgUrl) {
                    imageView.sd_setImage(with: _url)
                }
                
                let titleLabel = vStack.arrangedSubviews[1] as! UILabel
                titleLabel.text = _A.title
                
                let storyLabel = vStack.subviews[3] as! UILabel
                storyLabel.hide()
                if(_A.isStory){ storyLabel.show() }
                
                let gradient = vStack.subviews[2] as! UIImageView
                gradient.isHidden = storyLabel.isHidden
                
                self.storyFlags[i] = _A.isStory
                
                let sourcesContainer = vStack.arrangedSubviews[2] as! UIStackView
                if(_A.isStory) {
                    ADD_SOURCE_ICONS(data: _A.storySources, to: sourcesContainer)
                } else {
                    var sourcesArray = [String]()
                    if let _identifier = Sources.shared.search(name: _A.source) {
                        sourcesArray.append(_identifier)
                    }
                    ADD_SOURCE_ICONS(data: sourcesArray, to: sourcesContainer)
                }
            }
            
        }

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        for (i, view) in self.mainHStack.arrangedSubviews.enumerated() {
            let vStack = view as! UIStackView

            let imageView = vStack.arrangedSubviews[0] as! UIImageView
            imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray

            let titleLabel = vStack.arrangedSubviews[1] as! UILabel
            titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            
            let gradient = vStack.subviews[2] as! UIImageView
            gradient.image = UIImage(named: DisplayMode.imageName("story.gradient"))
            
            let storyLabel = vStack.subviews[3] as! UILabel
            storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
            storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            
            if(self.storyFlags[i]) {
                vStack.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
            } else {
                vStack.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
            }
        }
    }
    
    
}
