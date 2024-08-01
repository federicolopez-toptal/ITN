//
//  PublicFiguresViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/03/2024.
//

import UIKit
import SDWebImage


class PublicFiguresViewController: BaseViewController {

    let navBar = NavBarView()
    var lastKeyTapTime: Date?
    
    var page: Int = 0
    var tmpTotal: Int = 0
    var allItems = [PublicFigureListItem]()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let showMoreView = UIView()

    var showMoreButton = UIButton(type: .custom)
    let noItemsLabel = UILabel()

        var typeSelector = UIView()
        let darkView = DarkView()
        var typePicker = UIPickerView()
        var typePickerTopConstraint: NSLayoutConstraint!
        var typeOptions = ["All", "Organization", "Public Figure"]
        let typePickerButton = UIButton()
        var currentType: Int = 0
        
        var filterTextfield = FigureFilterTextView()
        let itemsContainer = UIView()
        var itemsContainerHeightConstraint: NSLayoutConstraint!
        
        let items_DIM: CGFloat = 92
        var items_H_SEP: CGFloat = 92
        let items_V_SEP: CGFloat = 30
        var items_COLS: CGFloat = IPHONE() ? 2 : 5
        let imgs_DIM: CGFloat = 66
        let texts_WIDTH: CGFloat = 160
        
        var COL: CGFloat = 0
        var ROW: CGFloat = 0

    
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
//            self.navBar.addComponents([.back, .title])
            self.navBar.addComponents([.menuIcon, .title])
            self.navBar.setTitle("Public Figures")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    func buildContent() {
        if(IPAD()) {
            let _h = SCREEN_SIZE().height
            let _w = SCREEN_SIZE().width
            let minDim = (_h < _w) ? _h : _w
            let calcW = (self.items_COLS * self.items_DIM) + ((self.items_COLS-1) * self.items_H_SEP)
            
            if(calcW > minDim) {
                self.items_COLS = 4
            }
        }
        
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        //self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        // ****
        self.typeSelector.backgroundColor = .orange
        self.contentView.addSubview(self.typeSelector)
        self.typeSelector.activateConstraints([
            self.typeSelector.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16*2),
            self.typeSelector.heightAnchor.constraint(equalToConstant: 40)
        ])
        if(IPHONE()) {
            self.typeSelector.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            self.typeSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        } else {
            self.typeSelector.widthAnchor.constraint(equalToConstant: 500).isActive = true
            self.typeSelector.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        }
        self.createSelectorView(with: self.typeSelector, index: 99)
        
        self.darkView.buildInto(self.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(darkViewOnTap(sender:)))
        self.darkView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(self.typePicker)
        self.typePicker.activateConstraints([
            self.typePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.typePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.typePickerTopConstraint = self.typePicker.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.typePickerTopConstraint.isActive = true
        self.typePicker.backgroundColor = self.view.backgroundColor //.white
        self.typePicker.delegate = self
        
        self.typePickerButton.layer.cornerRadius = 8
        self.typePickerButton.setTitle("Select", for: .normal)
        self.typePickerButton.titleLabel?.font = AILERON(15)
        self.typePickerButton.setTitleColor(.white, for: .normal)
        self.typePickerButton.backgroundColor = CSS.shared.orange
        self.view.addSubview(self.typePickerButton)
        self.typePickerButton.activateConstraints([
            self.typePickerButton.widthAnchor.constraint(equalToConstant: 70),
            self.typePickerButton.heightAnchor.constraint(equalToConstant: 30),
            self.typePickerButton.topAnchor.constraint(equalTo: self.view.bottomAnchor,
                constant: -self.typePicker.frame.size.height+10),
            self.typePickerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
        self.typePickerButton.hide()
        self.typePickerButton.addTarget(self, action: #selector(typeSelectorOnSelect(_:)), for: .touchUpInside)
        // ****
    
        self.filterTextfield.delegate = self
        self.filterTextfield.buildInto(view: self.contentView)
        self.filterTextfield.activateConstraints([
            self.filterTextfield.topAnchor.constraint(equalTo: self.typeSelector.bottomAnchor, constant: 16),
            self.filterTextfield.heightAnchor.constraint(equalToConstant: 40),
        ])
        if(IPHONE()) {
            self.filterTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            self.filterTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        } else {
            self.filterTextfield.widthAnchor.constraint(equalToConstant: 500).isActive = true
            self.filterTextfield.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        }

        var W: CGFloat = (self.items_COLS * self.items_DIM) + ((self.items_COLS-1) * self.items_H_SEP)
        if(IPAD()) {
            var value: CGFloat = 0
            let w = SCREEN_SIZE().width
            let h = SCREEN_SIZE().height
            
            value = w
            if(h<w){ value = h }
            
            if(value-W<30) {
                value -= (30 * 2)
                W = value
                value -= (self.items_COLS * self.items_DIM)
                
                self.items_H_SEP = value / (self.items_COLS-1)
            }
        }
        
        self.contentView.addSubview(self.itemsContainer)
        //self.itemsContainer.backgroundColor = .orange
        self.itemsContainer.activateConstraints([
            self.itemsContainer.topAnchor.constraint(equalTo: self.filterTextfield.bottomAnchor, constant: 16*2),
            self.itemsContainer.widthAnchor.constraint(equalToConstant: W),
            self.itemsContainer.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        self.itemsContainerHeightConstraint = self.itemsContainer.heightAnchor.constraint(equalToConstant: 300)
        self.itemsContainerHeightConstraint.isActive = true
        
        //self.showMoreView.backgroundColor = .orange
        self.contentView.addSubview(self.showMoreView)
        self.showMoreView.activateConstraints([
            self.showMoreView.widthAnchor.constraint(equalToConstant: 150),
            self.showMoreView.heightAnchor.constraint(equalToConstant: 42+16),
            self.showMoreView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.showMoreView.topAnchor.constraint(equalTo: self.itemsContainer.bottomAnchor),
            
            self.showMoreView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -22)
        ])
        
        self.showMoreButton = UIButton(type: .custom)
        self.showMoreView.addSubview(self.showMoreButton)
        self.showMoreButton.activateConstraints([
            self.showMoreButton.heightAnchor.constraint(equalToConstant: 42),
            self.showMoreButton.widthAnchor.constraint(equalToConstant: 150),
            self.showMoreButton.leadingAnchor.constraint(equalTo: self.showMoreView.leadingAnchor),
            self.showMoreButton.topAnchor.constraint(equalTo: self.showMoreView.topAnchor, constant: 16)
        ])
        self.showMoreButton.setTitle("Show more", for: .normal)
        self.showMoreButton.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        self.showMoreButton.titleLabel?.font = AILERON(15)
        self.showMoreButton.layer.masksToBounds = true
        self.showMoreButton.layer.cornerRadius = 9
        self.showMoreButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        self.showMoreButton.addTarget(self, action: #selector(loadMoreOnTap(_:)), for: .touchUpInside)
        
        self.noItemsLabel.font = AILERON(16)
        self.noItemsLabel.textAlignment = .center
        self.noItemsLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.noItemsLabel.numberOfLines = 0
        self.noItemsLabel.text = "No items found\nPlease, try another search"
        self.contentView.addSubview(self.noItemsLabel)
        self.noItemsLabel.activateConstraints([
            self.noItemsLabel.topAnchor.constraint(equalTo: self.itemsContainer.topAnchor, constant: 20),
            self.noItemsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        self.noItemsLabel.hide()
        
        self.scrollView.hide()
        //self.refreshDisplayMode()
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        
        self.view.bringSubviewToFront(self.typePicker)
        self.view.bringSubviewToFront(self.typePickerButton)
        self.refreshContent(index: 1)
    }
    @objc func darkViewOnTap(sender: UITapGestureRecognizer?) {
        self.typePickerTopConstraint.constant = 0
        self.typePickerButton.hide()
        
        UIView.animate(withDuration: 0.3) {
            self.darkView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.darkView.hide()
        }
    }
    
    func createSelectorView(with theView: UIView, index: Int) {
        theView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191c) : .white
        theView.layer.cornerRadius = 5
        theView.layer.borderWidth = 1.0
        theView.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x37383a).cgColor : UIColor(hex: 0xc6c8ca).cgColor
        
        let arrowDownImage = UIImage(named: "arrow.down.old")?.withRenderingMode(.alwaysTemplate)
        let arrowImageView = UIImageView(image: arrowDownImage)
        arrowImageView.tintColor = DARK_MODE() ? UIColor(hex: 0xf6f6f7) : UIColor(hex: 0x838383)
        theView.addSubview(arrowImageView)
        arrowImageView.activateConstraints([
            arrowImageView.widthAnchor.constraint(equalToConstant: 28),
            arrowImageView.heightAnchor.constraint(equalToConstant: 28),
            arrowImageView.centerYAnchor.constraint(equalTo: theView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: theView.trailingAnchor, constant: -8),
        ])
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        theView.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: theView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: theView.trailingAnchor),
            button.topAnchor.constraint(equalTo: theView.topAnchor),
            button.bottomAnchor.constraint(equalTo: theView.bottomAnchor)
        ])
        button.tag = index
        button.addTarget(self, action: #selector(selectorOnTap(_:)), for: .touchUpInside)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        theView.addSubview(contentView)
        contentView.activateConstraints([
            contentView.leadingAnchor.constraint(equalTo: theView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: theView.trailingAnchor, constant: -50),
            contentView.centerYAnchor.constraint(equalTo: theView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 30)
        ])
        contentView.isUserInteractionEnabled = false
        contentView.tag = 999
    }
     @objc func selectorOnTap(_ sender: UIButton) {
        let index = sender.tag
        
        self.view.endEditing(true)
        self.darkView.alpha = 0
        self.darkView.show()
        
        if(index == 99) {
            self.typePicker.selectRow(self.currentType, inComponent: 0, animated: false)
        
            self.typePickerTopConstraint.constant = -self.typePicker.frame.size.height //+IPHONE_bottomOffset()
            UIView.animate(withDuration: 0.3) {
                self.darkView.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.typePickerButton.show()
            }
        }
    }
    @objc func typeSelectorOnSelect(_ sender: UIButton) {
        self.darkViewOnTap(sender: nil)
        self.currentType = self.typePicker.selectedRow(inComponent: 0)
        self.refreshContent(index: 1)
        
        self.resetListParams()
        self.loadContent(page: self.page)
    }
    func refreshContent(index: Int) {
        if(index==1) {
            let contentView = self.typeSelector.viewWithTag(999)!
            REMOVE_ALL_SUBVIEWS(from: contentView)

            let text = UILabel()
            text.textColor = CSS.shared.displayMode().sec_textColor
            text.font = UIFont.systemFont(ofSize: 16)
            text.text = self.typeOptions[self.currentType]
            contentView.addSubview(text)
            text.activateConstraints([
                text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            
            if(self.currentType == 0) {
                let newLabel = UILabel()
                newLabel.layer.cornerRadius = 4.0
                newLabel.clipsToBounds = true
                newLabel.backgroundColor = UIColor(hex: 0xefd80b)
                newLabel.textColor = UIColor(hex: 0x19191C)
                newLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

                newLabel.text = "NEW"
                newLabel.textAlignment = .center
                contentView.addSubview(newLabel)
                newLabel.activateConstraints([
                    newLabel.widthAnchor.constraint(equalToConstant: 44),
                    newLabel.heightAnchor.constraint(equalToConstant: 23),
                    newLabel.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 15),
                    newLabel.centerYAnchor.constraint(equalTo: text.centerYAnchor)
                ])

            }
        }
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.loadContent(page: self.page)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            self.resetListParams()
            self.loadContent(page: self.page)
        }
    }
    
    func resetListParams() {
        self.COL = 0
        self.ROW = 0
        self.page = 1
        self.allItems = [PublicFigureListItem]()
        REMOVE_ALL_SUBVIEWS(from: self.itemsContainer)
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        
        REMOVE_ALL_SUBVIEWS(from: self.typeSelector)
        self.createSelectorView(with: self.typeSelector, index: 99)
        self.refreshContent(index: 1)
        
        self.filterTextfield.refreshDisplayMode()
        self.noItemsLabel.textColor = CSS.shared.displayMode().sec_textColor
        
        let tmpItems = self.allItems
        self.resetListParams()
        self.fillList(total: self.tmpTotal, items: tmpItems)
        
        self.showMoreButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        self.showMoreButton.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        
        self.darkView.refreshDisplayMode()
        self.typePicker.backgroundColor = self.view.backgroundColor
        self.typePicker.reloadAllComponents()
    }

}

// MARK: Data
extension PublicFiguresViewController {
    
    private func loadContent(page P: Int) {
        self.showLoading()
        PublicFigureData.shared.loadList(term: self.filterTextfield.text(),
            page: P, type: self.currentType) { (error, total, items) in
            
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading the Public Figures,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                self.page += 1
            
                MAIN_THREAD {
                    self.hideLoading()
                    
                    if let _T = total, let _I = items {
                        self.fillList(total: _T, items: _I)
                    }
                }
            }
        }
                
    }
    
    func fillList(total: Int, items: [PublicFigureListItem]) {
        self.tmpTotal = total
        for LI in items {
            
//            if(LI.type==1) {
//                print("ITEM", LI.title)
//            }
            
            let newItem = self.createItemView(data: LI)
            let posX: CGFloat = self.COL * (self.items_DIM + self.items_H_SEP)
            let posY: CGFloat = self.ROW * ((self.items_DIM+40) + self.items_V_SEP)
            
            self.itemsContainer.addSubview(newItem)
            newItem.activateConstraints([
                newItem.leadingAnchor.constraint(equalTo: self.itemsContainer.leadingAnchor, constant: posX),
                newItem.topAnchor.constraint(equalTo: self.itemsContainer.topAnchor, constant: posY)
            ])
         
            self.itemsContainerHeightConstraint.constant = posY + self.items_DIM+40 + 16
         
            self.COL += 1
            if(self.COL == self.items_COLS) {
                self.COL = 0
                self.ROW += 1
            }
            
            self.allItems.append(LI)
        }
        
        if(self.allItems.count < total) {
            self.showMoreView.show()
        } else {
            self.showMoreView.hide()
        }
        
        self.scrollView.show()
        
        if(total == 0) {
            self.noItemsLabel.show()
        } else {
            self.noItemsLabel.hide()
        }
    }
    
    private func createItemView(data: PublicFigureListItem) -> UIView {
        let mainView = UIView()
        //mainView.backgroundColor = .cyan
        mainView.activateConstraints([
            mainView.widthAnchor.constraint(equalToConstant: self.items_DIM),
            mainView.heightAnchor.constraint(equalToConstant: self.items_DIM + 40)
        ])
    
        let borderView = UIView()
        mainView.addSubview(borderView)
        borderView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        borderView.activateConstraints([
            borderView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            borderView.topAnchor.constraint(equalTo: mainView.topAnchor),
            borderView.widthAnchor.constraint(equalToConstant: self.items_DIM),
            borderView.heightAnchor.constraint(equalToConstant: self.items_DIM)
        ])
        borderView.layer.cornerRadius = self.items_DIM/2
                        
        let imageView = UIImageView()
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        borderView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.heightAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
        imageView.layer.cornerRadius = self.imgs_DIM/2
        imageView.clipsToBounds = true
        let imageUrl = data.image.replacingOccurrences(of: " ", with: "%20")
        imageView.sd_setImage(with: URL(string: imageUrl))
        
        let nameLabel = UILabel()
        //nameLabel.backgroundColor = .orange
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = AILERON(16)
        nameLabel.textColor = CSS.shared.displayMode().main_textColor
        nameLabel.text = data.title
        //
        mainView.addSubview(nameLabel)
        nameLabel.activateConstraints([
            nameLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: self.texts_WIDTH),
            nameLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor)
        ])
        
        let buttonArea = UIButton(type: .custom)
        //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
        mainView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: mainView.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        buttonArea.tag = data.id
        buttonArea.addTarget(self, action: #selector(listItemOnTap(_:)), for: .touchUpInside)
        
        return mainView
    }
    
    @objc func listItemOnTap(_ sender: UIButton) {
        if let _item = self.allItems.first(where: { $0.id == sender.tag }) {
            let vc = FigureDetailsViewController()
            vc.slug = _item.slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: misc
extension PublicFiguresViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK:
extension PublicFiguresViewController: FigureFilterTextViewDelegate {

    func FigureFilterTextView_onTextChange(sender: FigureFilterTextView, text: String) {
        let limitDiff: TimeInterval = 0.8
        self.lastKeyTapTime = Date()

        DELAY(limitDiff) {
            let diff = Date().timeIntervalSince(self.lastKeyTapTime!)
            if(diff >= limitDiff) {
                //self.search(self.searchTextfield.text(), type: .all)
                self.resetListParams()
                self.loadContent(page: self.page)
            }
        }
    }
    
    func FigureFilterTextView_onSearchTap(sender: FigureFilterTextView) {
        NOTHING()
    }
    
}

extension PublicFiguresViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.typePicker) {
            return self.typeOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if(pickerView == self.typePicker) {
            return self.createOptionForType(index: row)
        }
        
        return UIView()
    }
    
    func createOptionForType(index: Int) -> UIView {
        let optionView = UIView()
        optionView.backgroundColor = self.view.backgroundColor //.white
        
        let text = UILabel()
        text.textColor = CSS.shared.displayMode().main_textColor // UIColor(hex: 0x19191C)
        text.font = UIFont.systemFont(ofSize: 16)
        text.text = self.typeOptions[index]
        optionView.addSubview(text)
        text.activateConstraints([
            text.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            text.centerYAnchor.constraint(equalTo: optionView.centerYAnchor)
        ])
        
        if(index == 0) {
            let newLabel = UILabel()
            newLabel.layer.cornerRadius = 4.0
            newLabel.clipsToBounds = true
            newLabel.backgroundColor = UIColor(hex: 0xefd80b)
            newLabel.textColor = UIColor(hex: 0x19191C)
            newLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

            newLabel.text = "NEW"
            newLabel.textAlignment = .center
            optionView.addSubview(newLabel)
            newLabel.activateConstraints([
                newLabel.widthAnchor.constraint(equalToConstant: 44),
                newLabel.heightAnchor.constraint(equalToConstant: 23),
                newLabel.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 15),
                newLabel.centerYAnchor.constraint(equalTo: text.centerYAnchor)
            ])
        }
        
        return optionView
    }

}

extension PublicFiguresViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        CustomNavController.shared.tour.rotate()
    }
    
}
