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
    let sliderRowsHeight: CGFloat = 190 + 10
    let buttonsHeight: CGFloat = 35
    var saveButton = UIButton()
    
    var allSliders = [UISlider]()

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
        self.allSliders = [UISlider]()
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(22)
        self.titleLabel.text = "Slider preferences"
        self.mainContainer.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 16*2),
        ])
        
        //-----
        let paragraph_01 = HyperlinkLabel.parrafo(text: self.texts(1), linkTexts: self.linkTexts(1),
            urls: self.urls(1), onTap: self.onLinkTap(_:))
        self.place(view: paragraph_01, below: self.titleLabel)
        paragraph_01.tag = 400+1
        
        //-----
        let title2 = self.orangeTitle(text: "What spin do you want?")
        self.place(view: title2, below: paragraph_01)
        
        let paragraph_02 = HyperlinkLabel.parrafo(text: self.texts(2), linkTexts: self.linkTexts(2),
            urls: self.urls(2), onTap: self.onLinkTap(_:))
        self.place(view: paragraph_02, below: title2)
        
        let sliders1 = self.sliderRows(1)
        self.place(view: sliders1, below: paragraph_02, extraMargin: 20)
        
        //-----
        let title3 = self.orangeTitle(text: "What writing style do you want?")
        self.place(view: title3, below: sliders1)
        
        let paragraph_03 = HyperlinkLabel.parrafo(text: self.texts(3), linkTexts: self.linkTexts(3),
            urls: self.urls(3), onTap: self.onLinkTap(_:))
        self.place(view: paragraph_03, below: title3)
        
        let sliders2 = self.sliderRows(2)
        self.place(view: sliders2, below: paragraph_03, extraMargin: 20)
        
        //-----
        let title4 = self.orangeTitle(text: "Do you want evergreen or fresh?")
        self.place(view: title4, below: sliders2)
        
        let paragraph_04 = HyperlinkLabel.parrafo(text: self.texts(4), linkTexts: self.linkTexts(4),
            urls: self.urls(4), onTap: self.onLinkTap(_:))
        self.place(view: paragraph_04, below: title4)
        
        let sliders3 = self.sliderRows(3)
        self.place(view: sliders3, below: paragraph_04)
        
        //-----
        self.saveButton = self.longButton(color: UIColor(hex: 0x60C4D6), tag: 100)
        self.place(view: self.saveButton, below: sliders3, extraMargin: 40)
        self.setText("Save slider preferences", toButton: self.saveButton)
        self.saveButton.isEnabled = false
        //self.saveButton.alpha = 0.5
        
        let resetButton = self.longButton(color: UIColor(hex: 0xBBBDC0), tag: 200)
        self.place(view: resetButton, below: saveButton)
        self.setText("Reset to default settings", toButton: resetButton)
        
        
        let W = SCREEN_SIZE().width - 32
        let vMargin: CGFloat = 20
        PrefSliders_cell.height = 16 + 16 + self.titleLabel.calculateHeightFor(width: W) + vMargin +
                            paragraph_01.calculateHeightFor(width: W) + vMargin +
                            title2.calculateHeightFor(width: W) + vMargin +
                            paragraph_02.calculateHeightFor(width: W) + vMargin + vMargin +
                            self.sliderRowsHeight + vMargin +
                            title3.calculateHeightFor(width: W) + vMargin +
                            paragraph_03.calculateHeightFor(width: W) + vMargin + vMargin +
                            self.sliderRowsHeight + vMargin +
                            title4.calculateHeightFor(width: W) + vMargin +
                            paragraph_04.calculateHeightFor(width: W) +
                            self.sliderRowsHeight + vMargin +
                            40 + (vMargin*3) +
                            40 + (vMargin*2) +
                            12 + 28
        
//        let red = UIView()
//        red.backgroundColor = .red.withAlphaComponent(0.5)
//        red.frame = CGRect(x: 0, y: posY, width: 300, height: 50)
//        self.contentView.addSubview(red)
        
        //-----
        self.refreshDisplayMode()
    }

    // MARK: - misc
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.mainContainer.backgroundColor = self.contentView.backgroundColor
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
    static func calculateHeight() -> CGFloat {
        return PrefSliders_cell.height
    }

}

// MARK: - UI build
extension PrefSliders_cell {

    func orangeTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        label.font = DM_SERIF_DISPLAY(21)
        return label
    }
    
    func place(view: UIView, below: UIView, extraMargin: CGFloat = 0) {
        self.mainContainer.addSubview(view)
        view.activateConstraints([
            view.topAnchor.constraint(equalTo: below.bottomAnchor, constant: 20 + extraMargin)
        ])
        
        if(IPHONE()) {
            view.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: 0).isActive = true
        } else {
            if(view is UIButton) {
                view.widthAnchor.constraint(equalToConstant: 400).isActive = true
                view.centerXAnchor.constraint(equalTo: self.mainContainer.centerXAnchor).isActive = true
            } else {
                view.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16).isActive = true
                view.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -16).isActive = true
            }
        }
    }
    
    func longButton(color: UIColor, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 4
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.tag = tag
        button.addTarget(self, action: #selector(onLongButtonTap(sender:)), for: .touchUpInside)
        
        return button
    }
    func setText(_ text: String, toButton button: UIButton) {
        let label = UILabel()
        label.font = AILERON_SEMIBOLD(16)
        label.textColor = UIColor(hex: 0x19191C)
        label.text = text
        label.tag = button.tag + 1
        self.mainContainer.addSubview(label)
        label.activateConstraints([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        label.isUserInteractionEnabled = false
    }
    
    func sliderRows(_ index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear //.systemPink
        self.mainContainer.addSubview(view)
        view.activateConstraints([
            view.heightAnchor.constraint(equalToConstant: self.sliderRowsHeight)
        ])
        
        let aileronBold = AILERON_BOLD(13)
        let characterSpacing: Double = 1.5
        let titles = [
                        ["POLITICAL STANCE", "ESTABLISHMENT STANCE"],
                        ["WRITING STYLE", "DEPTH"],
                        ["SHELF-LIFE", "RECENCY"]
                    ]
                    
        let legends = [
                        ["LEFT", "RIGHT", "CRITICAL", "PRO"],
                        ["PROVOCATIVE", "NUANCED", "BREEZY", "DETAILED"],
                        ["SHORT", "LONG", "EVERGREEN", "LATEST"]
                    ]
        
        var indexCode = 0
        if(index==2){ indexCode=2 }
        else if(index==3){ indexCode=4 }
        
        var margin: CGFloat = 0
        if(IPAD()){ margin = 60 }
        
        var valY: CGFloat = 0
        for j in 1...2 {
            let _2titles = titles[index-1]
            let _4legends = legends[index-1]
            
            let titleLabel = UILabel()
            titleLabel.text = _2titles[j-1]
            titleLabel.font = aileronBold
            titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            titleLabel.addCharacterSpacing(kernValue: characterSpacing)
            view.addSubview(titleLabel)
            titleLabel.activateConstraints([
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: valY)
            ])
            
            let hStack = HSTACK(into: view)
            hStack.activateConstraints([
                hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
                hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
                hStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            ])
            
            var k = 0
            if(j==2){k=2}
            
            let leftLabel = UILabel()
            leftLabel.text = _4legends[k]
            leftLabel.font = aileronBold
            leftLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            leftLabel.addCharacterSpacing(kernValue: characterSpacing)
            hStack.addArrangedSubview(leftLabel)
            
            ADD_SPACER(to: hStack)
            
            let rightLabel = UILabel()
            rightLabel.text = _4legends[k+1]
            rightLabel.font = aileronBold
            rightLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            rightLabel.addCharacterSpacing(kernValue: characterSpacing)
            hStack.addArrangedSubview(rightLabel)
            
            let slider = UISlider()
            slider.backgroundColor = .clear //.blue.withAlphaComponent(0.3)
            slider.minimumValue = 0
            slider.maximumValue = 99
            slider.isContinuous = false
            slider.minimumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x545B67) : UIColor(hex: 0xD3D3D4)
            slider.maximumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x545B67) : UIColor(hex: 0xD3D3D4)
            slider.setThumbImage(UIImage(named: "slidersOrangeThumb"), for: .normal)
            //slider.tag = 20 + i
            slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
            view.addSubview(slider)
            slider.activateConstraints([
                slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2+margin),
                slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2-margin),
                slider.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 8)
            ])
            self.allSliders.append(slider)
            
            let i = indexCode+(j-1)
            var value = LocalKeys.sliders.defaultValues[i]
            if let _value = READ(LocalKeys.sliders.allKeys[i]) {
                value = Int(_value)!
            }
            
            slider.setValue(Float(value), animated: false)
            valY = 100+10
        }
        
        return view
    }

}

// MARK: - Data
extension PrefSliders_cell {

    func saveSliderValues() {
        for (i, key) in LocalKeys.sliders.allKeys.enumerated() {
            let slider = self.allSliders[i]
            let newValue = Int(round(slider.value))
            let strValue = String(format: "%02d", newValue)
            
            WRITE(key, value: strValue)
            CustomNavController.shared.slidersPanel.reloadSliderValues()
        }
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeedOnShow)
    }

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

// MARK: - Event(s)
extension PrefSliders_cell {
    
    func onLinkTap(_ url: URL) {
        OPEN_URL(url.absoluteString)
    }
    
    @objc func onLongButtonTap(sender: UIButton?) {
        if(sender?.tag == 100) {
            // Save
            self.saveSliderValues()
            self.saveButton.isEnabled = false
            //self.saveButton.alpha = 0.5
            
            if let label = self.mainContainer.viewWithTag(sender!.tag+1) as? UILabel {
                label.text = "SAVED!"
                DELAY(1.5) {
                    label.text = "SAVE SLIDER PREFERENCES"
                }
            }
            
        } else if(sender?.tag == 200) {
            // Reset all sliders
            for (i, value) in LocalKeys.sliders.defaultValues.enumerated() {
                self.allSliders[i].setValue(Float(value), animated: true)
            }
            self.saveSliderValues()
            
            self.saveButton.isEnabled = false
            //self.saveButton.alpha = 0.5
        }
    }
    
    @objc func sliderOnValueChange(_ sender: UISlider) {
        self.saveButton.isEnabled = true
        //self.saveButton.alpha = 1.0
    }
    
}
