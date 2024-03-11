//
//  NewsLetterArchiveViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/03/2024.
//

import UIKit

class NewsLetterArchiveViewController: BaseViewController {

    let navBar = NavBarView()
    var vStack: UIStackView!
    let darkView = DarkView()
    
    var viewSelector: UIView!
        var viewPicker = UIPickerView()
        var viewPickerTopConstraint: NSLayoutConstraint!
        var currentView: Int = 0
        let viewPickerButton = UIButton()
        
    var dateSelector: UIView!
        var dateOptions = ["Last month", "Last 3 months", "Last 6 months", "Specific dates"]
        var datePicker = UIPickerView()
        var datePickerTopConstraint: NSLayoutConstraint!
        var currentDate: Int = 0
        let datePickerButton = UIButton()
        
        
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Newsletter archive")
            self.navBar.addBottomLine()

            CustomNavController.shared.hidePanelAndButtonWithAnimation()
            self.buildContent()
        }
    }
    
    func buildContent() {
        let margin = CSS.shared.iPhoneSide_padding
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.vStack = VSTACK(into: self.view)
        self.vStack.backgroundColor = self.view.backgroundColor //.green.withAlphaComponent(0.2)
        self.view.addSubview(self.vStack)
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            self.vStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            self.vStack.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: margin)
        ])
        
        let searchText = UILabel()
        searchText.font = DM_SERIF_DISPLAY(20)
        searchText.text = "Search our newsletter"
        searchText.textColor = CSS.shared.displayMode().main_textColor
        self.vStack.addArrangedSubview(searchText)
        ADD_SPACER(to: self.vStack, height: margin)
        
        // VIEW ---------------------------------------
        let viewText = UILabel()
        viewText.font = AILERON(15)
        viewText.text = "View"
        viewText.textColor = CSS.shared.displayMode().sec_textColor
        self.vStack.addArrangedSubview(viewText)
        ADD_SPACER(to: self.vStack, height: margin/2)
        
        self.viewSelector = self.createSelectorView(into: self.vStack, index: 1)
        ADD_SPACER(to: self.vStack, height: margin)
        
        self.view.addSubview(self.viewPicker)
        self.viewPicker.activateConstraints([
            self.viewPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.viewPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.viewPickerTopConstraint = self.viewPicker.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.viewPickerTopConstraint.isActive = true
        self.viewPicker.backgroundColor = .white
        self.viewPicker.delegate = self
        
        self.viewPickerButton.layer.cornerRadius = 8
        self.viewPickerButton.setTitle("Select", for: .normal)
        self.viewPickerButton.titleLabel?.font = AILERON(15)
        self.viewPickerButton.setTitleColor(.white, for: .normal)
        self.viewPickerButton.backgroundColor = CSS.shared.orange
        self.view.addSubview(self.viewPickerButton)
        self.viewPickerButton.activateConstraints([
            self.viewPickerButton.widthAnchor.constraint(equalToConstant: 70),
            self.viewPickerButton.heightAnchor.constraint(equalToConstant: 30),
            self.viewPickerButton.topAnchor.constraint(equalTo: self.view.bottomAnchor,
                constant: -self.viewPicker.frame.size.height+10),
            self.viewPickerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
        ])
        self.viewPickerButton.hide()
        self.viewPickerButton.addTarget(self, action: #selector(viewSelectorOnSelect(_:)), for: .touchUpInside)
        
        // DATE ---------------------------------------
        let dateText = UILabel()
        dateText.font = AILERON(15)
        dateText.text = "Date Range"
        dateText.textColor = CSS.shared.displayMode().sec_textColor
        self.vStack.addArrangedSubview(dateText)
        ADD_SPACER(to: self.vStack, height: margin/2)
        
        self.dateSelector = self.createSelectorView(into: self.vStack, index: 2)
        ADD_SPACER(to: self.vStack, height: margin*2)
        
        self.view.addSubview(self.datePicker)
        self.datePicker.activateConstraints([
            self.datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.datePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.datePickerTopConstraint = self.datePicker.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.datePickerTopConstraint.isActive = true
        self.datePicker.backgroundColor = .white
        self.datePicker.delegate = self
        
        self.datePickerButton.layer.cornerRadius = 8
        self.datePickerButton.setTitle("Select", for: .normal)
        self.datePickerButton.titleLabel?.font = AILERON(15)
        self.datePickerButton.setTitleColor(.white, for: .normal)
        self.datePickerButton.backgroundColor = CSS.shared.orange
        self.view.addSubview(self.datePickerButton)
        self.datePickerButton.activateConstraints([
            self.datePickerButton.widthAnchor.constraint(equalToConstant: 70),
            self.datePickerButton.heightAnchor.constraint(equalToConstant: 30),
            self.datePickerButton.topAnchor.constraint(equalTo: self.view.bottomAnchor,
                constant: -self.datePicker.frame.size.height+10),
            self.datePickerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
        ])
        self.datePickerButton.hide()
        self.datePickerButton.addTarget(self, action: #selector(dateSelectorOnSelect(_:)), for: .touchUpInside)
        
        // LINE ---------------------------------------
        let sepLine = UIView()
        sepLine.backgroundColor = .red
        self.vStack.addArrangedSubview(sepLine)
        sepLine.activateConstraints([
            sepLine.heightAnchor.constraint(equalToConstant: 3)
        ])
        ADD_HDASHES(to: sepLine)
        
        self.darkView.buildInto(self.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(darkViewOnTap(sender:)))
        self.darkView.addGestureRecognizer(tapGesture)
        
        self.view.bringSubviewToFront(self.viewPicker)
        self.view.bringSubviewToFront(self.datePicker)
        self.view.bringSubviewToFront(viewPickerButton)
        self.view.bringSubviewToFront(datePickerButton)
        
        self.refreshContent(index: 1)
        self.refreshContent(index: 2)
    }
    
    @objc func viewSelectorOnSelect(_ sender: UIButton) {
        self.darkViewOnTap(sender: nil)
        self.currentView = self.viewPicker.selectedRow(inComponent: 0)
        self.refreshContent(index: 1)
    }
    
    @objc func dateSelectorOnSelect(_ sender: UIButton) {
        self.darkViewOnTap(sender: nil)
        self.currentDate = self.datePicker.selectedRow(inComponent: 0)
        self.refreshContent(index: 2)
    }
    
    @objc func darkViewOnTap(sender: UITapGestureRecognizer?) {
        self.viewPickerTopConstraint.constant = 0
        self.datePickerTopConstraint.constant = 0
        self.viewPickerButton.hide()
        self.datePickerButton.hide()
        
        UIView.animate(withDuration: 0.3) {
            self.darkView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.darkView.hide()
        }
    }

}

extension NewsLetterArchiveViewController {
    
    func refreshContent(index: Int) {
        if(index==1) {
            // view
            let contentView = self.viewSelector.viewWithTag(999)!
            REMOVE_ALL_SUBVIEWS(from: contentView)
            
            ///
            var items = [String]()
            switch self.currentView {
                case 0:
                    items = ["D"]
                case 1:
                    items = ["W"]
                case 2:
                    items = ["D", "W"]
                    
                default:
                    NOTHING()
            }
        
            var posX: CGFloat = 0
            for i in items {
                let circle = UIView()
                
                var circleBgColor = CSS.shared.cyan
                if(i=="W"){ circleBgColor = CSS.shared.orange }
                
                var circleTextColor = UIColor(hex: 0x19191C)
                if(i=="W"){ circleTextColor = .white }
                
                var itemText = "Daily"
                if(i=="W"){ itemText = "Weekly" }
                else if(self.currentView==2) { itemText += " +" }
                
                circle.backgroundColor = circleBgColor
                contentView.addSubview(circle)
                circle.activateConstraints([
                    circle.widthAnchor.constraint(equalToConstant: 26),
                    circle.heightAnchor.constraint(equalToConstant: 26),
                    circle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: posX),
                    circle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ])
                circle.layer.cornerRadius = 13
                posX += 26 + 5
                
                let letter = UILabel()
                letter.text = i
                letter.font = DM_SERIF_DISPLAY(16)
                letter.textColor = circleTextColor
                circle.addSubview(letter)
                letter.activateConstraints([
                    letter.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                    letter.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
                ])
                
                let text = UILabel()
                text.textColor = CSS.shared.displayMode().sec_textColor
                text.font = UIFont.systemFont(ofSize: 16)
                text.text = itemText
                contentView.addSubview(text)
                text.activateConstraints([
                    text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: posX),
                    text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ])
                posX += 55
            }
            ///
        } else {
            let contentView = self.dateSelector.viewWithTag(999)!
            REMOVE_ALL_SUBVIEWS(from: contentView)
            
            ///
            let text = UILabel()
            text.textColor = CSS.shared.displayMode().sec_textColor
            text.font = UIFont.systemFont(ofSize: 16)
            text.text = self.dateOptions[self.currentDate]
            contentView.addSubview(text)
            text.activateConstraints([
                text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                text.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            ///
        }
    }

    func createSelectorView(into container: UIStackView, index: Int) -> UIView {
        let rect = UIView()
        rect.backgroundColor = self.view.backgroundColor
        rect.layer.cornerRadius = 6
        rect.layer.borderWidth = 0.5
        rect.layer.borderColor = CSS.shared.displayMode().sec_textColor.cgColor
        container.addArrangedSubview(rect)
        rect.activateConstraints([
            rect.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let arrowDownImage = UIImage(named: "arrow.down.old")?.withRenderingMode(.alwaysTemplate)
        let arrowImageView = UIImageView(image: arrowDownImage)
        arrowImageView.tintColor = CSS.shared.displayMode().main_textColor
        rect.addSubview(arrowImageView)
        arrowImageView.activateConstraints([
            arrowImageView.widthAnchor.constraint(equalToConstant: 28),
            arrowImageView.heightAnchor.constraint(equalToConstant: 28),
            arrowImageView.centerYAnchor.constraint(equalTo: rect.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -8),
        ])
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        rect.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: rect.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: rect.trailingAnchor),
            button.topAnchor.constraint(equalTo: rect.topAnchor),
            button.bottomAnchor.constraint(equalTo: rect.bottomAnchor)
        ])
        button.tag = index
        button.addTarget(self, action: #selector(selectorOnTap(_:)), for: .touchUpInside)
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        rect.addSubview(contentView)
        contentView.activateConstraints([
            contentView.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -50),
            contentView.centerYAnchor.constraint(equalTo: rect.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 30)
        ])
        contentView.isUserInteractionEnabled = false
        contentView.tag = 999
        
        return rect
    }
    
    @objc func selectorOnTap(_ sender: UIButton) {
        let index = sender.tag
        
        self.darkView.alpha = 0
        self.darkView.show()
        
        // ANIM
        if(index == 1) {
            self.viewPicker.selectRow(self.currentView, inComponent: 0, animated: false)
        
            self.viewPickerTopConstraint.constant = -self.viewPicker.frame.size.height
            self.datePickerTopConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.darkView.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.viewPickerButton.show()
            }
        } else{
            self.datePicker.selectRow(self.currentDate, inComponent: 0, animated: false)
            
            self.datePickerTopConstraint.constant = -self.datePicker.frame.size.height
            self.viewPickerTopConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.darkView.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.datePickerButton.show()
            }
        }
    }
}

extension NewsLetterArchiveViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

extension NewsLetterArchiveViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.viewPicker) {
            return 3    // view
        } else {
            return self.dateOptions.count   // date
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if(pickerView == self.viewPicker) {
            return self.createOptionForView(index: row)
        } else {
            return self.createOptionForDate(index: row)
        }
    }
    
    func createOptionForDate(index: Int) -> UIView {
        let optionView = UIView()
        optionView.backgroundColor = .white
        
        let text = UILabel()
        text.textColor = UIColor(hex: 0x19191C)
        text.font = UIFont.systemFont(ofSize: 16)
        text.text = self.dateOptions[index]
        optionView.addSubview(text)
        text.activateConstraints([
            text.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            text.centerYAnchor.constraint(equalTo: optionView.centerYAnchor)
        ])
        
        return optionView
    }
    
    func createOptionForView(index: Int) -> UIView {
        let optionView = UIView()
        optionView.backgroundColor = .white
        
        var items = [String]()
        switch index {
            case 0:
                items = ["D"]
            case 1:
                items = ["W"]
            case 2:
                items = ["D", "W"]
                
            default:
                NOTHING()
        }
        
        var posX: CGFloat = 16
        for i in items {
            let circle = UIView()
            
            var circleBgColor = CSS.shared.cyan
            if(i=="W"){ circleBgColor = CSS.shared.orange }
            
            var circleTextColor = UIColor(hex: 0x19191C)
            if(i=="W"){ circleTextColor = .white }
            
            var itemText = "Daily"
            if(i=="W"){ itemText = "Weekly" }
            else if(index==2) { itemText += " +" }
            
            circle.backgroundColor = circleBgColor
            optionView.addSubview(circle)
            circle.activateConstraints([
                circle.widthAnchor.constraint(equalToConstant: 26),
                circle.heightAnchor.constraint(equalToConstant: 26),
                circle.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: posX),
                circle.centerYAnchor.constraint(equalTo: optionView.centerYAnchor)
            ])
            circle.layer.cornerRadius = 13
            posX += 26 + 5
            
            let letter = UILabel()
            letter.text = i
            letter.font = DM_SERIF_DISPLAY(16)
            letter.textColor = circleTextColor
            circle.addSubview(letter)
            letter.activateConstraints([
                letter.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                letter.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
            ])
            
            let text = UILabel()
            text.textColor = UIColor(hex: 0x19191C)
            text.font = UIFont.systemFont(ofSize: 16)
            text.text = itemText
            optionView.addSubview(text)
            text.activateConstraints([
                text.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: posX),
                text.centerYAnchor.constraint(equalTo: optionView.centerYAnchor)
            ])
            posX += 55
        }
        
        return optionView
    }
    
}
