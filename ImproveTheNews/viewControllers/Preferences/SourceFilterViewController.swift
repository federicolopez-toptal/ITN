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
    let sTitleLabel = UILabel()
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
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    
        let closeImage = UIImage(named: "menu.close")
        let closeIcon = UIImageView(image: closeImage)
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace)
        ])
        
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
        self.titleLabel.font = MERRIWEATHER_BOLD(24)
        self.titleLabel.text = "Source filter"
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ])
        
        self.view.addSubview(self.sTitleLabel)
        self.sTitleLabel.font = ROBOTO(14)
        self.sTitleLabel.text = "Search media"
        self.sTitleLabel.activateConstraints([
            self.sTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.sTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15)
        ])
    
        self.filterText.delegate = self
        self.filterText.buildInto(viewController: self)
        self.filterText.activateConstraints([
            self.filterText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            self.filterText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17),
            self.filterText.heightAnchor.constraint(equalToConstant: 44),
            self.filterText.topAnchor.constraint(equalTo: self.sTitleLabel.bottomAnchor, constant: 16)
        ])
    
        let paywallLabel = UILabel()
        paywallLabel.text = "* indicates pay wall"
        paywallLabel.textColor = UIColor(hex: 0xFF643C)
        paywallLabel.font = ROBOTO_BOLD(14)
        self.view.addSubview(paywallLabel)
        paywallLabel.activateConstraints([
            paywallLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            paywallLabel.topAnchor.constraint(equalTo: self.filterText.bottomAnchor, constant: 10)
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
            self.scrollView.topAnchor.constraint(equalTo: paywallLabel.bottomAnchor, constant: 10),
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
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sTitleLabel.textColor = self.titleLabel.textColor
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
        
        self.dataProvider = self.dataProvider.sorted(by: { $0.name < $1.name })
        //print("FILTER", self.dataProvider.count)
        //---------------------
        REMOVE_ALL_SUBVIEWS(from: self.contentView)
        
        let row_H: CGFloat = 56
        
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
            nameLabel.font = MERRIWEATHER_BOLD(14)
            nameLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            if(icon.paywall) {
                nameLabel.textColor = UIColor(hex: 0xFF643C)
                nameLabel.text = icon.name + " *"
            } else {
                nameLabel.text = icon.name
            }
        
            let labelWidth: CGFloat = nameLabel.calculateWidthFor(height: iconDim)
            let W: CGFloat = 22 + iconDim + 10 + labelWidth + 22
        
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
            tag.layer.cornerRadius = 28
            HStack.addArrangedSubview(tag)
            tag.activateConstraints([
                tag.heightAnchor.constraint(equalToConstant: 56),
                tag.widthAnchor.constraint(equalToConstant: W)
            ])
            
            let iconImageView = UIImageView()
            iconImageView.backgroundColor = .gray
            tag.addSubview(iconImageView)
            iconImageView.activateConstraints([
                iconImageView.widthAnchor.constraint(equalToConstant: iconDim),
                iconImageView.heightAnchor.constraint(equalToConstant: iconDim),
                iconImageView.leadingAnchor.constraint(equalTo: tag.leadingAnchor, constant: 22),
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
            
            
            tag.addSubview(nameLabel)
            nameLabel.activateConstraints([
                nameLabel.heightAnchor.constraint(equalToConstant: iconDim),
                nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                nameLabel.centerYAnchor.constraint(equalTo: tag.centerYAnchor)
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
        if(state) {
            view.alpha = 1
        } else {
            if(DARK_MODE()) { view.alpha = 0.35 }
            else { view.alpha = 0.5 }
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
