//
//  PrefSliders_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/12/2022.
//

import UIKit

class PrefSliders_cell: UITableViewCell {

    static let identifier = "PrefSliders_cell"
    static var height: CGFloat = 0.0
    
    let mainContainer = UIView()
    let titleLabel = UILabel()
    
    

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.backgroundColor = .systemPink
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
        
        self.titleLabel.font = MERRIWEATHER(17)
        self.titleLabel.text = "Slider preferences"
        self.mainContainer.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 28),
        ])
        
        //-----
        let paragraph_01 = HyperlinkLabel.parrafo(text: self.texts(1), linkTexts: self.linkTexts(1),
            urls: self.urls(1), onTap: self.onLinkTap(_:))
        self.place(label: paragraph_01, below: self.titleLabel)
        
        //-----
        let title2 = self.orangeTitle(text: "What spin do you want?")
        self.place(label: title2, below: paragraph_01)
        
        let paragraph_02 = HyperlinkLabel.parrafo(text: self.texts(2), linkTexts: self.linkTexts(2),
            urls: self.urls(2), onTap: self.onLinkTap(_:))
        self.place(label: paragraph_02, below: title2)
        
        //-----
        let title3 = self.orangeTitle(text: "What writing style do you want?")
        self.place(label: title3, below: paragraph_02)
        
        let paragraph_03 = HyperlinkLabel.parrafo(text: self.texts(3), linkTexts: self.linkTexts(3),
            urls: self.urls(3), onTap: self.onLinkTap(_:))
        self.place(label: paragraph_03, below: title3)
        
        //-----
        let title4 = self.orangeTitle(text: "Do you want evergreen or fresh?")
        self.place(label: title4, below: paragraph_03)
        
        let paragraph_04 = HyperlinkLabel.parrafo(text: self.texts(4), linkTexts: self.linkTexts(4),
            urls: self.urls(4), onTap: self.onLinkTap(_:))
        self.place(label: paragraph_04, below: title4)
        
        //-----
        let W = SCREEN_SIZE().width - 32 - 32
        let vMargin: CGFloat = 20
        PrefSliders_cell.height = 12 + 28 + self.titleLabel.calculateHeightFor(width: W) + vMargin +
                            paragraph_01.calculateHeightFor(width: W) + vMargin +
                            title2.calculateHeightFor(width: W) + vMargin +
                            paragraph_02.calculateHeightFor(width: W) + vMargin +
                            title3.calculateHeightFor(width: W) + vMargin +
                            paragraph_03.calculateHeightFor(width: W) + vMargin +
                            title4.calculateHeightFor(width: W) + vMargin +
                            paragraph_04.calculateHeightFor(width: W) +
                            12 + 28
        
//        let red = UIView()
//        red.backgroundColor = .red.withAlphaComponent(0.5)
//        red.frame = CGRect(x: 0, y: posY, width: 300, height: 50)
//        self.contentView.addSubview(red)
        
        //-----
        self.refreshDisplayMode()
    }
    
    func orangeTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(hex: 0xFF643C)
        label.font = MERRIWEATHER(17)
        return label
    }
    
    func place(label: UILabel, below: UIView) {
        self.mainContainer.addSubview(label)
        label.activateConstraints([
            label.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: below.bottomAnchor, constant: 20),
        ])
    }
    
    

    // MARK: - misc
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202D).withAlphaComponent(0.4) : UIColor(hex: 0xF4F6F8)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }

    func onLinkTap(_ url: URL) {
        OPEN_URL(url.absoluteString)
    }
    
    static func calculateHeight() -> CGFloat {
        return PrefSliders_cell.height
    }

}



extension PrefSliders_cell {

    func texts(_ index: Int) -> String {
        switch index {
            case 1:
                return "The sliders lets you choose your news diet the way you aim to choose your food: deliberately rather than impulsively ([0])"
            case 2:
                return "Two sliders let you choose the political stance of your news sources. The left-right slider uses a classification of media outlets based on political leaning, mainly from [0]. The establishment slider classifies media outlets based on how close they are to power (see, e.g., Wikipedia’s lists of [1], libertarian and [2] alternative media and [3] classification): does the news source normally accept or challenge claims by powerful entities such as the government and large corporations? Rather than leaving them alone, you’ll probably enjoy spicing things up by occasionally sliding them to see what those you disagree with cover various topics."
            case 3:
                return "Irrespective of topic and spin, two sliders let you choose your preferred writing style. The nuance slider ranges from provocative writing with inflammatory low-blows, ad-hominem attacks, and deliberately ugly photos of criticized people, to nuanced writing in a more respectful style. The depth slider ranges from short breezy pieces with unsubstantiated claims to in-depth coverage/analysis/expose providing good context, careful sourcing, and often detailed numbers/graphics and a more academic style."
            case 4:
                return "The shelf-life slider ranges from fast-expiring topics such as celebrity gossip and “so-and-so tweeted the following” to evergreen pieces (high-impact/novel analysis) that are likely to remain relevant for a long time to come. The recent slider lets you choose whether to focus on golden oldies or the very latest news. Note that your news gets ranked by combining the match to all the sliders, so we can give you the very latest news only at the cost of paying slightly less attention to the other sliders."
            default:
                return ""
        }
    }
    func linkTexts(_ index: Int) -> [String] {
        switch index {
            case 1:
                return ["see this video demo"]
            case 2:
                return ["here", "left", "right", "this"]
            default:
                return []
        }
    }
    func urls(_ index: Int) -> [String] {
        switch index {
            case 1:
                return ["https://www.youtube.com/watch?v=PRLF17Pb6vo"]
            case 2:
                return ["https://www.allsides.com/media-bias",
                        "https://en.wikipedia.org/wiki/Alternative_media_(U.S._political_left)",
                        "https://en.wikipedia.org/wiki/Alternative_media_(U.S._political_right)",
                        "https://swprs.org/media-navigator/"]
            default:
                return []
        }
    }

}
