//
//  SourceFilterViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/11/2022.
//

import UIKit
import SDWebImage


class SourceFilterViewController: BaseViewController {
    
    var dataProvider = [SourceIcon]()
    var sourcesLoaded = false
    
    let titleLabel = UILabel()
//    let sTitleLabel = UILabel()
    let filterText = FilterTextView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                self.sourcesLoaded = true
                MAIN_THREAD {
                    self.searchForText("")
                }
            }
        
            self.didLayout = true
            self.buildContent()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.searchForText(self.filterText.text())
    }

    // MARK: - misc
    func buildContent() {
        let topSpace: CGFloat = Y_TOP_NOTCH_FIX(54)
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        //DARK_MODE() ? UIColor(hex: 0x19191C) : .white
    
        let closeImage = UIImage(named: DisplayMode.imageName("SourcesClose"))
        let closeIcon = UIImageView(image: closeImage)
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace+4)
        ])
        //closeIcon.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.view.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    
        self.view.addSubview(self.titleLabel)
        self.titleLabel.font = DM_SERIF_DISPLAY_fixed(24) //MERRIWEATHER_BOLD(24)
        self.titleLabel.text = "Source filter"
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: -4)
        ])
        
//        self.view.addSubview(self.sTitleLabel)
//        self.sTitleLabel.font = ROBOTO(14)
//        self.sTitleLabel.text = "Search media"
//        self.sTitleLabel.activateConstraints([
//            self.sTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
//            self.sTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15)
//        ])
    
        self.filterText.delegate = self
        self.filterText.buildInto(viewController: self)
        self.filterText.activateConstraints([
            self.filterText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            self.filterText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17),
            self.filterText.heightAnchor.constraint(equalToConstant: 64),
            self.filterText.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16)
        ])
    
        let moneyIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("money")))
        self.view.addSubview(moneyIcon)
        moneyIcon.activateConstraints([
            moneyIcon.widthAnchor.constraint(equalToConstant: 24),
            moneyIcon.heightAnchor.constraint(equalToConstant: 24),
            moneyIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            moneyIcon.topAnchor.constraint(equalTo: self.filterText.bottomAnchor, constant: 27)
        ])
    
        let paywallLabel = UILabel()
        paywallLabel.text = "Indicates a paywall."
        paywallLabel.textColor = DARK_MODE() ? UIColor(hex: 0xbbbdc0) : UIColor(hex: 0x19191c)
        paywallLabel.font = AILERON(16)
        self.view.addSubview(paywallLabel)
        paywallLabel.activateConstraints([
            paywallLabel.leadingAnchor.constraint(equalTo: moneyIcon.trailingAnchor, constant: 17),
            paywallLabel.centerYAnchor.constraint(equalTo: moneyIcon.centerYAnchor)
        ])
        
        var bottomSpace: CGFloat = 0
        if let _extraSpace = SAFE_AREA()?.bottom {
            bottomSpace += _extraSpace
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: moneyIcon.bottomAnchor, constant: 27),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomSpace)
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        H.priority = .defaultLow
        
        self.contentView.backgroundColor = self.view.backgroundColor
        self.contentView.clipsToBounds = true
        self.scrollView.addSubview(self.contentView)
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            H, self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    
        self.refreshDisplayMode()
        if(self.sourcesLoaded){ self.searchForText("") }
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        //DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        //self.sTitleLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : self.titleLabel.textColor
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension SourceFilterViewController: FilterTextViewDelegate {
    
    func FilterTextView_onTextChange(sender: FilterTextView, text: String) {
        self.searchForText(text)
    }
    
    func searchForText(_ text: String) {
        //---------------------
        if(text.isEmpty) {
            self.dataProvider = Sources.shared.all!.filter { obj in true }
        } else {
            self.dataProvider = Sources.shared.all!.filter { obj in
                obj.name.lowercased().contains(text.lowercased())
            }
        }
        
        // self.dataProvider = self.dataProvider.sorted(by: { $0.name < $1.name })
        // print("FILTER", self.dataProvider.count)
        //---------------------
        REMOVE_ALL_SUBVIEWS(from: self.contentView)
        
        let row_H: CGFloat = 40
        
        let limit = SCREEN_SIZE().width - 13 - 13
        let iconDim: CGFloat = 24
        
        let VStack = VSTACK(into: self.contentView)
        VStack.spacing = 15
        VStack.backgroundColor = .clear
        VStack.activateConstraints([
            VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        var val_x: CGFloat = 0
        var val_y: CGFloat = 0
        for (i, icon) in self.dataProvider.enumerated() {
            var HStack: UIStackView!
            var moneyIcon: UIImageView!

            if(i==0) {
                HStack = HSTACK(into: VStack)
                HStack?.spacing = 7
                HStack?.backgroundColor = .clear
                HStack?.activateConstraints([
                    HStack!.heightAnchor.constraint(equalToConstant: row_H)
                ])
            } else {
                HStack = VStack.arrangedSubviews.last as? UIStackView
            }
        
            let nameLabel = UILabel()
            //nameLabel.backgroundColor = .yellow
            nameLabel.font = AILERON(16)
            //DM_SERIF_DISPLAY_fixed(14) //MERRIWEATHER_BOLD(14)
            nameLabel.textColor = CSS.shared.displayMode().sec_textColor //DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            nameLabel.text = icon.name
            
//            if(icon.paywall) {
//                nameLabel.textColor = UIColor(hex: 0xDA4933)
//                nameLabel.text = icon.name + " *"
//            } else {
//                nameLabel.text = icon.name
//            }
        
            let labelWidth: CGFloat = nameLabel.calculateWidthFor(height: iconDim)
            var W: CGFloat = 8 + iconDim + 8 + labelWidth + 40
            if(icon.paywall) {
                W += 5 + 24
            }
        
            if(val_x + W > limit) {
                val_x = 0
                val_y += row_H + 15
                
                ADD_SPACER(to: HStack)
                
                HStack = HSTACK(into: VStack)
                HStack?.spacing = 7
                HStack?.backgroundColor = .clear
                HStack?.activateConstraints([
                    HStack!.heightAnchor.constraint(equalToConstant: row_H)
                ])
            }
        
        
            let tag = UIView()
            tag.backgroundColor = DARK_MODE() ? UIColor(hex: 0x93A0B4).withAlphaComponent(0.2) : UIColor(hex: 0x283241).withAlphaComponent(0.1)
            
            tag.layer.cornerRadius = 20
            HStack.addArrangedSubview(tag)
            tag.activateConstraints([
                tag.heightAnchor.constraint(equalToConstant: 40),
                tag.widthAnchor.constraint(equalToConstant: W)
            ])
            
            let iconImageView = UIImageView()
            iconImageView.backgroundColor = .gray
            tag.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.widthAnchor.constraint(equalToConstant: iconDim),
                iconImageView.heightAnchor.constraint(equalToConstant: iconDim),
                iconImageView.leadingAnchor.constraint(equalTo: tag.leadingAnchor, constant: 8),
                iconImageView.centerYAnchor.constraint(equalTo: tag.centerYAnchor)
            ])
            
            if let _url = icon.url {
                //print("ICON", _url, icon.name)
                if(!_url.contains(".svg")) {
                    iconImageView.sd_setImage(with: URL(string: _url))
                } else {
                    iconImageView.image = UIImage(named: icon.identifier + ".png")
                }
            }
            iconImageView.layer.cornerRadius = iconDim/2
            iconImageView.clipsToBounds = true
            
            tag.addSubview(nameLabel)
            nameLabel.activateConstraints([
                nameLabel.heightAnchor.constraint(equalToConstant: iconDim),
                nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                nameLabel.centerYAnchor.constraint(equalTo: tag.centerYAnchor)
            ])
            
            if(icon.paywall) {
                moneyIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("money2")))
                moneyIcon.tag = 88
                tag.addSubview(moneyIcon)
                moneyIcon?.activateConstraints([
                    moneyIcon.widthAnchor.constraint(equalToConstant: 24),
                    moneyIcon.heightAnchor.constraint(equalToConstant: 24),
                    moneyIcon.centerYAnchor.constraint(equalTo: tag.centerYAnchor),
                    moneyIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5)
                ])
            }
            
            let actionIconImage = UIImage(named: "tag.check")?.withRenderingMode(.alwaysTemplate)
            let actionIcon = UIImageView(image: actionIconImage)
            actionIcon.tintColor = DARK_MODE() ? UIColor(hex: 0xbbbdc0) : UIColor(hex: 0x2d2d31)
            actionIcon.tag = 99
            tag.addSubview(actionIcon)
            actionIcon.activateConstraints([
                actionIcon.widthAnchor.constraint(equalToConstant: 24),
                actionIcon.heightAnchor.constraint(equalToConstant: 24),
                actionIcon.centerYAnchor.constraint(equalTo: tag.centerYAnchor),
                actionIcon.trailingAnchor.constraint(equalTo: tag.trailingAnchor, constant: -13)
            ])
            
            
            let buttonArea = UIButton(type: .custom)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            tag.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: tag.leadingAnchor),
                buttonArea.topAnchor.constraint(equalTo: tag.topAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: tag.trailingAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: tag.bottomAnchor)
            ])
            buttonArea.tag = i
            buttonArea.addTarget(self, action: #selector(tagOnTap(_:)), for: .touchUpInside)
            
            self.updateUIState(for: tag, icon.state)
            
            // ---------------------------
            if(i==self.dataProvider.count-1) {
                ADD_SPACER(to: HStack)
            }
            
            val_x += W + 7
        }
    }
    
    func updateUIState(for view: UIView, _ state: Bool) {
//        if(state) {
//            view.alpha = 1
//        } else {
//            if(DARK_MODE()) { view.alpha = 0.35 }
//            else { view.alpha = 0.5 }
//        }

        let moneyIcon = view.viewWithTag(88) as? UIImageView
        let actionIcon = view.viewWithTag(99) as! UIImageView

        if(state) {
            view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x93A0B4).withAlphaComponent(0.2) :
                UIColor(hex: 0x283241).withAlphaComponent(0.1)
            view.layer.borderColor = UIColor.clear.cgColor
            
            moneyIcon?.image = UIImage(named: DisplayMode.imageName("money2"))
            actionIcon.image = UIImage(named: "tag.check")?.withRenderingMode(.alwaysTemplate)
            actionIcon.tintColor = DARK_MODE() ? UIColor(hex: 0xbbbdc0) : UIColor(hex: 0x2d2d31)
        } else {
            view.backgroundColor = CSS.shared.displayMode().main_bgColor
            view.layer.borderWidth = 1
            view.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x93A0B4).withAlphaComponent(0.3).cgColor :
                UIColor(hex: 0x283241).withAlphaComponent(0.3).cgColor
                
            moneyIcon?.image = UIImage(named: DisplayMode.imageName("money"))
            actionIcon.image = UIImage(named: "tag.close")?.withRenderingMode(.alwaysTemplate)
            actionIcon.tintColor = DARK_MODE() ? UIColor(hex: 0x93A0B4).withAlphaComponent(0.5) :
                UIColor(hex: 0x283241).withAlphaComponent(0.3)
        }
    }
    
    @objc func tagOnTap(_ sender: UIButton) {
        let i = sender.tag
        if let v = sender.superview {
            self.updatePrefSourceFilters(code: self.dataProvider[i].code)
        
            self.dataProvider[i].state = !self.dataProvider[i].state
            Sources.shared.updateSourceState(self.dataProvider[i].code!, self.dataProvider[i].state)
            self.updateUIState(for: v, self.dataProvider[i].state)
        }
    }
    
    func updatePrefSourceFilters(code: String?) {
        if(code==nil){ return }
        
        var filters: [String] = READ(LocalKeys.preferences.sourceFilters)?.components(separatedBy: ",") ?? []
        if let _index = filters.firstIndex(of: code!) {
            filters.remove(at: _index)
        } else {
            filters.append(code!)
        }
        
        var value = filters.joined(separator: ",")
        
        WRITE(LocalKeys.preferences.sourceFilters, value: value)
        print("Writing", value)
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeedOnShow)
    }
    
}

/*
REFS

JSON
example: https://www.improvemynews.com/news.json

Figma
https://www.figma.com/file/bsHo1TXWWWoQ3l0PUzXN4l/Ancillary-pages?node-id=1003%3A5029&t=qvuf1AWKV3oUm7vx-0

 */
