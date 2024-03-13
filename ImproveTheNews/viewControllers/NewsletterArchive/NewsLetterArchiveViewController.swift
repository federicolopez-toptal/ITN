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
        
        let datesView = UIView()
        let dateFromPicker = UIDatePicker()
        let dateToPicker = UIDatePicker()
        let dateFromLabel = UILabel()
        let dateToLabel = UILabel()
        
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    var storiesVStack: UIStackView!
        
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
        
        // SCROLLVIEW + CONTENT VIEW ------------------------------------------------
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = self.view.backgroundColor //.systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

            let H = self.mainContentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow

        self.scrollView.addSubview(self.mainContentView)
        self.mainContentView.backgroundColor = self.viewPicker.backgroundColor
        self.mainContentView.activateConstraints([
            self.mainContentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.mainContentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.mainContentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.mainContentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.mainContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        // ------------------------------------------------------------------------------
        
        self.vStack = VSTACK(into: self.mainContentView)
        self.vStack.backgroundColor = self.view.backgroundColor
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.mainContentView.leadingAnchor, constant: margin),
            self.vStack.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -margin),
            self.vStack.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: margin),
            self.vStack.bottomAnchor.constraint(equalTo: self.mainContentView.bottomAnchor, constant: -margin)
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
        
        if(IPHONE()) {
            self.viewSelector = self.createSelectorView(into: self.vStack, index: 1)
        } else {
            let viewHStack = HSTACK(into: self.vStack)
            self.viewSelector = self.createSelectorView(into: viewHStack, index: 1)
            ADD_SPACER(to: viewHStack)
        }
        ADD_SPACER(to: self.vStack, height: margin)
        
        self.view.addSubview(self.viewPicker)
        self.viewPicker.activateConstraints([
            self.viewPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.viewPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.viewPickerTopConstraint = self.viewPicker.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.viewPickerTopConstraint.isActive = true
        self.viewPicker.backgroundColor = self.view.backgroundColor //.white
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
            self.viewPickerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
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
        
        if(IPHONE()) {
            self.dateSelector = self.createSelectorView(into: self.vStack, index: 2)
        } else {
            let dateHStack = HSTACK(into: self.vStack)
            self.dateSelector = self.createSelectorView(into: dateHStack, index: 2)
            ADD_SPACER(to: dateHStack)
        }
        ADD_SPACER(to: self.vStack, height: margin*2)
        
        self.view.addSubview(self.datePicker)
        self.datePicker.activateConstraints([
            self.datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.datePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.datePickerTopConstraint = self.datePicker.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.datePickerTopConstraint.isActive = true
        self.datePicker.backgroundColor = self.view.backgroundColor //.white
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
        
        // DATE(s)-------------------------------------
        self.datesView.backgroundColor = self.view.backgroundColor
        self.datesView.layer.cornerRadius = 8
        self.view.addSubview(self.datesView)
        self.datesView.activateConstraints([
            self.datesView.widthAnchor.constraint(equalToConstant: 350),
            self.datesView.heightAnchor.constraint(equalToConstant: 116 + 20 + 30),
            self.datesView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.datesView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        // from
        let startLabel = UILabel()
        startLabel.text = "Beginning:"
        startLabel.textColor = CSS.shared.displayMode().main_textColor
        startLabel.font = UIFont.systemFont(ofSize: 17)
        startLabel.backgroundColor = .clear //.systemPink
        self.datesView.addSubview(startLabel)
        startLabel.activateConstraints([
            startLabel.heightAnchor.constraint(equalToConstant: 34),
            startLabel.topAnchor.constraint(equalTo: self.datesView.topAnchor, constant: 16),
            startLabel.leadingAnchor.constraint(equalTo: self.datesView.leadingAnchor, constant: 16)
        ])

        self.dateFromPicker.date = Date()
        self.datesView.addSubview(self.dateFromPicker)
        self.dateFromPicker.datePickerMode = .date
        self.dateFromPicker.addTarget(self, action: #selector(dateFromOnChange(_:)), for: .valueChanged)
        self.dateFromPicker.backgroundColor = self.view.backgroundColor
        self.dateFromPicker.tintColor = CSS.shared.orange
        self.dateFromPicker.activateConstraints([
            self.dateFromPicker.topAnchor.constraint(equalTo: self.datesView.topAnchor, constant: 16),
            self.dateFromPicker.trailingAnchor.constraint(equalTo: self.datesView.trailingAnchor, constant: -16)
        ])
        
        self.dateFromLabel.font = UIFont.systemFont(ofSize: 17)
        self.datesView.addSubview(self.dateFromLabel)
        self.dateFromLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0x2D2D31)
        self.dateFromLabel.textColor = CSS.shared.displayMode().main_textColor
        self.dateFromLabel.activateConstraints([
            self.dateFromLabel.leadingAnchor.constraint(equalTo: self.dateFromPicker.leadingAnchor),
            self.dateFromLabel.topAnchor.constraint(equalTo: self.dateFromPicker.topAnchor, constant: 0),
            self.dateFromLabel.trailingAnchor.constraint(equalTo: self.dateFromPicker.trailingAnchor, constant: 0),
            self.dateFromLabel.bottomAnchor.constraint(equalTo: self.dateFromPicker.bottomAnchor)
        ])
        self.dateFromLabel.textAlignment = .center
        self.dateFromLabel.text = "ABC DEF"
        self.dateFromLabel.layer.cornerRadius = 8
        self.dateFromLabel.clipsToBounds = true
        self.dateFromLabel.isUserInteractionEnabled = false
        
        // to
        let endLabel = UILabel()
        endLabel.text = "End:"
        endLabel.textColor = CSS.shared.displayMode().main_textColor
        endLabel.font = UIFont.systemFont(ofSize: 17)
        endLabel.backgroundColor = .clear //.systemPink
        self.datesView.addSubview(endLabel)
        endLabel.activateConstraints([
            endLabel.heightAnchor.constraint(equalToConstant: 34),
            endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 16),
            endLabel.leadingAnchor.constraint(equalTo: self.datesView.leadingAnchor, constant: 16)
        ])
        
        let DAY: TimeInterval = 60 * 60 * 24
        self.dateToPicker.date = Date() + DAY
        self.datesView.addSubview(self.dateToPicker)
        self.dateToPicker.datePickerMode = .date
        self.dateToPicker.addTarget(self, action: #selector(dateToOnChange(_:)), for: .valueChanged)
        self.dateToPicker.backgroundColor = self.view.backgroundColor
        self.dateToPicker.tintColor = CSS.shared.orange
        self.dateToPicker.activateConstraints([
            self.dateToPicker.topAnchor.constraint(equalTo: self.dateFromPicker.bottomAnchor, constant: 16),
            self.dateToPicker.trailingAnchor.constraint(equalTo: self.datesView.trailingAnchor, constant: -16)
        ])
        
        self.dateToLabel.font = UIFont.systemFont(ofSize: 17)
        self.datesView.addSubview(self.dateToLabel)
        self.dateToLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0x2D2D31)
        self.dateToLabel.textColor = CSS.shared.displayMode().main_textColor
        self.dateToLabel.activateConstraints([
            self.dateToLabel.leadingAnchor.constraint(equalTo: self.dateToPicker.leadingAnchor),
            self.dateToLabel.topAnchor.constraint(equalTo: self.dateToPicker.topAnchor, constant: 0),
            self.dateToLabel.trailingAnchor.constraint(equalTo: self.dateToPicker.trailingAnchor, constant: 0),
            self.dateToLabel.bottomAnchor.constraint(equalTo: self.dateToPicker.bottomAnchor)
        ])
        self.dateToLabel.textAlignment = .center
        self.dateToLabel.text = "ABC DEF"
        self.dateToLabel.layer.cornerRadius = 8
        self.dateToLabel.clipsToBounds = true
        self.dateToLabel.isUserInteractionEnabled = false
        
        let buttonsContainer = UIView()
        buttonsContainer.backgroundColor = .clear
        self.datesView.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.heightAnchor.constraint(equalToConstant: 30),
            buttonsContainer.topAnchor.constraint(equalTo: self.dateToPicker.bottomAnchor, constant: 20),
            buttonsContainer.centerXAnchor.constraint(equalTo: self.datesView.centerXAnchor),
            buttonsContainer.widthAnchor.constraint(equalToConstant: 70 + 10 + 70)
        ])
        
        let datesButton = UIButton(type: .custom)
        datesButton.layer.cornerRadius = 8
        datesButton.setTitle("Set", for: .normal)
        datesButton.titleLabel?.font = AILERON(15)
        datesButton.setTitleColor(.white, for: .normal)
        datesButton.backgroundColor = CSS.shared.orange
        buttonsContainer.addSubview(datesButton)
        datesButton.activateConstraints([
            datesButton.widthAnchor.constraint(equalToConstant: 70),
            datesButton.heightAnchor.constraint(equalToConstant: 30),
            datesButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            datesButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor)
        ])
        datesButton.addTarget(self, action: #selector(datesSetOnTap(_:)), for: .touchUpInside)
        self.datesView.hide()
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.layer.cornerRadius = 8
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = AILERON(15)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = CSS.shared.orange
        buttonsContainer.addSubview(cancelButton)
        cancelButton.activateConstraints([
            cancelButton.widthAnchor.constraint(equalToConstant: 70),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor)
        ])
        cancelButton.addTarget(self, action: #selector(datesCancelOnTap(_:)), for: .touchUpInside)
        
        self.datesView.hide()
        
        // LINE ---------------------------------------
        let sepLine = UIView()
        sepLine.backgroundColor = .red
        self.vStack.addArrangedSubview(sepLine)
        sepLine.activateConstraints([
            sepLine.heightAnchor.constraint(equalToConstant: 3)
        ])
        ADD_HDASHES(to: sepLine)
        
        // STORIES ---------------------------------------
        ADD_SPACER(to: self.vStack, height: margin)
        
        self.storiesVStack = VSTACK(into: self.vStack)
        self.storiesVStack.backgroundColor = self.view.backgroundColor
        
        // MISC ---------------------------------------
        self.darkView.buildInto(self.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(darkViewOnTap(sender:)))
        self.darkView.addGestureRecognizer(tapGesture)
        
        self.view.bringSubviewToFront(self.viewPicker)
        self.view.bringSubviewToFront(self.datePicker)
        self.view.bringSubviewToFront(viewPickerButton)
        self.view.bringSubviewToFront(datePickerButton)
        
        self.refreshContent(index: 1)
        self.refreshContent(index: 2)
        
        self.view.bringSubviewToFront(self.datesView)
        
        DELAY(0.5) {
            self.loadData()
        }
    }
    
    @objc func dateFromOnChange(_ sender: UIDatePicker) {
        self.dateFromLabel.text = FORMAT(sender.date)
    }
    
    @objc func dateToOnChange(_ sender: UIDatePicker) {
        self.dateToLabel.text = FORMAT(sender.date)
    }
    
    @objc func datesCancelOnTap(_ sender: UIButton) {
        self.datesView.hide()
        UIView.animate(withDuration: 0.3) {
            self.darkView.alpha = 0
        } completion: { _ in
            self.darkView.hide()
        }
    }
    
    @objc func datesSetOnTap(_ sender: UIButton) {
        let dateFrom = DATE_ZERO_HOUR(input: self.dateFromPicker.date)
        let dateTo = DATE_ZERO_HOUR(input: self.dateToPicker.date)
        
        // validate
        if(dateTo < dateFrom) {
            CustomNavController.shared.infoAlert(message: "The end date must be after or equal to the start date")
        } else {
            UIView.animate(withDuration: 0.3) {
                self.darkView.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.darkView.hide()
                self.datesView.hide()
            }
            
            self.loadData()
        }
    }
    
    @objc func viewSelectorOnSelect(_ sender: UIButton) {
        self.darkViewOnTap(sender: nil)
        self.currentView = self.viewPicker.selectedRow(inComponent: 0)
        self.refreshContent(index: 1)
        
        self.loadData()
    }
    
    @objc func dateSelectorOnSelect(_ sender: UIButton) {
        self.currentDate = self.datePicker.selectedRow(inComponent: 0)
        self.refreshContent(index: 2)
        
        DELAY(0.1) {
            self.dateSelectorOnSelect_partB()
        }
    }
    
    private func dateSelectorOnSelect_partB() {
        if(self.currentDate == 3) {
            // Select date(s)
            self.dateFromLabel.text = FORMAT(self.dateFromPicker.date)
            self.dateToLabel.text = FORMAT(self.dateToPicker.date)
            
            self.datePickerTopConstraint.constant = 0
            self.datePickerButton.hide()

            self.datesView.alpha = 0
            self.datesView.show()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.datesView.alpha = 1
            } completion: { _ in
            }
        } else {
            self.darkViewOnTap(sender: nil)
            self.loadData()
        }
    }
    
    @objc func darkViewOnTap(sender: UITapGestureRecognizer?) {
        if(self.datesView.isHidden) {
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
        
        if(IPAD()) {
            rect.widthAnchor.constraint(equalToConstant: 410).isActive = true
        }
        
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
        optionView.backgroundColor = self.view.backgroundColor //.white
        
        let text = UILabel()
        text.textColor = CSS.shared.displayMode().main_textColor // UIColor(hex: 0x19191C)
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
        optionView.backgroundColor = self.view.backgroundColor //.white
        
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
            text.textColor = CSS.shared.displayMode().main_textColor //DARK_MODE() ? UIColor(hex: 0x19191C)
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

extension NewsLetterArchiveViewController {

    private func getType() -> String {
        switch(self.currentView) {
            case 0:
                return "daily"
            case 1:
                return "weekly"
            default:
                return "all"
        }
    }
    
    private func getRange() -> String {
        if(self.currentDate == 3) {
            let dateFrom = DATE_ZERO_HOUR(input: self.dateFromPicker.date)
            let dateTo = DATE_ZERO_HOUR(input: self.dateToPicker.date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        
            return formatter.string(from: dateFrom) + ":" + formatter.string(from: dateTo)
        } else {
            let DAY: TimeInterval = 60 * 60 * 24
            let MONTH: TimeInterval = DAY * 30
        
            let endDate = Date()
            var startDate = Date()
            switch(self.currentDate) {
                case 0:
                    startDate = endDate - MONTH
                case 1:
                    startDate = endDate - (MONTH * 3)
                case 2:
                    startDate = endDate - (MONTH * 6)
                
                default:
                    NOTHING()
            }
        
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        
            return formatter.string(from: startDate) + ":" + formatter.string(from: endDate)
        }
    }
    
    func loadData() {
        self.showLoading()
        NewsLetterData.shared.loadData(range: self.getRange(),
            type: self.getType(), offset: 1) { (error, stories) in
            
            self.hideLoading()
            
            if let _ = error {
                CustomNavController.shared.infoAlert(message: "Trouble loading the newsletter,\nplease try again later.")
            } else {
                MAIN_THREAD {
                    self.add(stories: stories)
                }
            }
        }
    }
    
    private func add(stories: [NewsLetterStory]) {
        self.storiesVStack.removeAllArrangedSubviews()
        
        if(stories.count == 0) {
            ADD_SPACER(to: self.storiesVStack, height: 16)
        
            let infoLabel = UILabel()
            infoLabel.text = "No result found"
            infoLabel.textColor = CSS.shared.displayMode().main_textColor
            infoLabel.font = AILERON(16)
            infoLabel.textAlignment = .center
            
            self.storiesVStack.addArrangedSubview(infoLabel)
        } else {
            for ST in stories {
                let newItem = self.createStoryView(ST)
                self.storiesVStack.addArrangedSubview(newItem)
                
                if(IPHONE()) {
                    ADD_SPACER(to: self.storiesVStack, height: 15)
                } else {
                    ADD_SPACER(to: self.storiesVStack, height: 25)
                }
            }
        }
    }
    
    private func createStoryView(_ data: NewsLetterStory) -> UIView {
        var H: CGFloat = 100
        if(IPAD()){ H = 150 }
        let W = (16 * H)/9
    
        let storyView = UIView()
        storyView.backgroundColor = self.view.backgroundColor

        // DATE --------------------------
        let dateLabel = UILabel()
        dateLabel.textColor = CSS.shared.displayMode().sec_textColor
        dateLabel.font = AILERON(14)
        dateLabel.backgroundColor = .clear
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let _date = formatter.date(from: data.date) {
            formatter.dateFormat = "dd MMMM yyyy"
            dateLabel.text = formatter.string(from: _date)
        } else {
            dateLabel.text = data.date
        }
        dateLabel.text = dateLabel.text?.uppercased()
        
        storyView.addSubview(dateLabel)
        dateLabel.activateConstraints([
            dateLabel.leadingAnchor.constraint(equalTo: storyView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: storyView.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // IMAGE --------------------------
        let imageView = CustomImageView()
        imageView.showCorners(false)
        storyView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.leadingAnchor.constraint(equalTo: storyView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: W),
            imageView.heightAnchor.constraint(equalToConstant: H)
        ])
        imageView.load(url: data.image_url)
        
        // CIRCLE --------------------------
        let circle = UIView()
                
        var circleBgColor = CSS.shared.cyan
        if(data.type==2){ circleBgColor = CSS.shared.orange }
        
        var circleTextColor = UIColor(hex: 0x19191C)
        if(data.type==2){ circleTextColor = .white }
        
        var itemText = "D"
        if(data.type==2){ itemText = "W" }
        
        circle.backgroundColor = circleBgColor
        storyView.addSubview(circle)
        circle.activateConstraints([
            circle.widthAnchor.constraint(equalToConstant: 26),
            circle.heightAnchor.constraint(equalToConstant: 26),
            circle.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            circle.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10)
        ])
        circle.layer.cornerRadius = 13
        
        let letter = UILabel()
        letter.text = itemText
        letter.font = DM_SERIF_DISPLAY(16)
        letter.textColor = circleTextColor
        circle.addSubview(letter)
        letter.activateConstraints([
            letter.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            letter.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
        
        // TEXT --------------------------
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = data.title
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.font = IPHONE() ? DM_SERIF_DISPLAY(16) : DM_SERIF_DISPLAY(26)
        storyView.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: storyView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor)
        ])
        
        var totalH = H
        let textW = SCREEN_SIZE().width - (16*4) - W
        let textH: CGFloat = titleLabel.calculateHeightFor(width: textW) + 16
        if(textH > H) {
            totalH = textH
        }
        
        storyView.activateConstraints([
            storyView.heightAnchor.constraint(equalToConstant: totalH + 20 + 10)
        ])
        
        storyView.bringSubviewToFront(dateLabel)
        return storyView
    }

    func FORMAT(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
    
        return formatter.string(from: date)
    }

}
