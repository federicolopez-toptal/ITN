//
//  NewsLetterArchiveViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/03/2024.
//

import UIKit
import EventsCalendar


class NewsLetterArchiveViewController: BaseViewController {

    let navBar = NavBarView()
    var vStack: UIStackView!
    let darkView = DarkView()
    
    var viewSelector: UIView!
        var viewPicker = UIPickerView()
        var viewPickerTopConstraint: NSLayoutConstraint!
        var currentView: Int = 2
        let viewPickerButton = UIButton()
        
    var dateSelector: UIView!
        var dateOptions = ["Last month", "Last 3 months", "Last 6 months", "Specific dates"]
        var datePicker = UIPickerView()
        var datePickerTopConstraint: NSLayoutConstraint!
        var currentDate: Int = 2
        let datePickerButton = UIButton()
        
        let datesView = UIView()
        let dateFromPicker = UIDatePicker()
        let dateToPicker = UIDatePicker()
        let dateFromLabel = UILabel()
        let dateToLabel = UILabel()
        
        let calendarsContainerView = UIView()
        
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    var storiesVStack: UIStackView!
        
    var stories: [NewsLetterStory]!
    var offset: Int = 1
        
    // MARK: - Init
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        self.showCalendar(date: Date())
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        if(DARK_MODE()) {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Newsletter archive")
            self.navBar.addBottomLine()

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
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
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
        searchText.font = DM_SERIF_DISPLAY_resize(20)
        searchText.text = "Search our newsletter"
        searchText.textColor = CSS.shared.displayMode().main_textColor
        self.vStack.addArrangedSubview(searchText)
        ADD_SPACER(to: self.vStack, height: margin)

        //self.addCopyButton() //!!!
        
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
            self.viewPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
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
            self.datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
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
        
        // DATE(s) VIEW(s) -------------------------------------
        self.datesView.backgroundColor = self.view.backgroundColor
        self.datesView.layer.cornerRadius = 8
        self.view.addSubview(self.datesView)
        self.datesView.activateConstraints([
            self.datesView.widthAnchor.constraint(equalToConstant: 330),
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

        self.dateFromLabel.font = UIFont.systemFont(ofSize: 17)
        self.datesView.addSubview(self.dateFromLabel)
        self.dateFromLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xe3e3e3)
        self.dateFromLabel.textColor = CSS.shared.displayMode().main_textColor
        self.dateFromLabel.activateConstraints([
            self.dateFromLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor),
            self.dateFromLabel.trailingAnchor.constraint(equalTo: self.datesView.trailingAnchor, constant: -16),
            self.dateFromLabel.widthAnchor.constraint(equalToConstant: 150),
            self.dateFromLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        self.dateFromLabel.textAlignment = .center
        self.dateFromLabel.text = "ABC DEF"
        self.dateFromLabel.layer.cornerRadius = 8
        self.dateFromLabel.clipsToBounds = true
        self.dateFromLabel.isUserInteractionEnabled = false
        
        let dateFromButton = UIButton(type: .custom)
        dateFromButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.datesView.addSubview(dateFromButton)
        dateFromButton.activateConstraints([
            dateFromButton.leadingAnchor.constraint(equalTo: self.dateFromLabel.leadingAnchor),
            dateFromButton.trailingAnchor.constraint(equalTo: self.dateFromLabel.trailingAnchor),
            dateFromButton.topAnchor.constraint(equalTo: self.dateFromLabel.topAnchor),
            dateFromButton.bottomAnchor.constraint(equalTo: self.dateFromLabel.bottomAnchor)
        ])
        dateFromButton.addTarget(self, action: #selector(dateFromButtonOnTap(_:)), for: .touchUpInside)
        
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
        
        self.dateToLabel.font = UIFont.systemFont(ofSize: 17)
        self.datesView.addSubview(self.dateToLabel)
        self.dateToLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xe3e3e3)
        self.dateToLabel.textColor = CSS.shared.displayMode().main_textColor
        self.dateToLabel.activateConstraints([
            self.dateToLabel.centerYAnchor.constraint(equalTo: endLabel.centerYAnchor),
            self.dateToLabel.trailingAnchor.constraint(equalTo: self.datesView.trailingAnchor, constant: -16),
            self.dateToLabel.widthAnchor.constraint(equalToConstant: 150),
            self.dateToLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        self.dateToLabel.textAlignment = .center
        self.dateToLabel.text = "ABC DEF"
        self.dateToLabel.layer.cornerRadius = 8
        self.dateToLabel.clipsToBounds = true
        self.dateToLabel.isUserInteractionEnabled = false
        
        let dateToButton = UIButton(type: .custom)
        dateToButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.datesView.addSubview(dateToButton)
        dateToButton.activateConstraints([
            dateToButton.leadingAnchor.constraint(equalTo: self.dateToLabel.leadingAnchor),
            dateToButton.trailingAnchor.constraint(equalTo: self.dateToLabel.trailingAnchor),
            dateToButton.topAnchor.constraint(equalTo: self.dateToLabel.topAnchor),
            dateToButton.bottomAnchor.constraint(equalTo: self.dateToLabel.bottomAnchor)
        ])
        dateToButton.addTarget(self, action: #selector(dateToButtonOnTap(_:)), for: .touchUpInside)
        
        let buttonsContainer = UIView()
        buttonsContainer.backgroundColor = .clear
        self.datesView.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.heightAnchor.constraint(equalToConstant: 30),
            buttonsContainer.topAnchor.constraint(equalTo: self.dateToLabel.bottomAnchor, constant: 20),
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
        
        // CALENDAR COMPONENTS ---------------------------------------
        self.view.addSubview(self.calendarsContainerView)
        self.calendarsContainerView.layer.cornerRadius = 10
        self.calendarsContainerView.backgroundColor = self.view.backgroundColor
        self.calendarsContainerView.activateConstraints([
            self.calendarsContainerView.widthAnchor.constraint(equalToConstant: 330),
            self.calendarsContainerView.heightAnchor.constraint(equalToConstant: 336),
            self.calendarsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.calendarsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.dateFromPicker.date = Date()
        self.calendarsContainerView.addSubview(self.dateFromPicker)
        self.dateFromPicker.datePickerMode = .date
        self.dateFromPicker.preferredDatePickerStyle = .inline
        self.dateFromPicker.addTarget(self, action: #selector(dateFromOnChange(_:)), for: .valueChanged)
        self.dateFromPicker.backgroundColor = self.view.backgroundColor
        self.dateFromPicker.tintColor = CSS.shared.orange
        self.dateFromPicker.activateConstraints([
            self.dateFromPicker.centerXAnchor.constraint(equalTo: self.calendarsContainerView.centerXAnchor),
            self.dateFromPicker.centerYAnchor.constraint(equalTo: self.calendarsContainerView.centerYAnchor)
        ])
        
        let DAY: TimeInterval = 60 * 60 * 24
        self.dateToPicker.date = Date() + DAY
        self.calendarsContainerView.addSubview(self.dateToPicker)
        self.dateToPicker.datePickerMode = .date
        self.dateToPicker.preferredDatePickerStyle = .inline
        self.dateToPicker.addTarget(self, action: #selector(dateToOnChange(_:)), for: .valueChanged)
        self.dateToPicker.backgroundColor = self.view.backgroundColor
        self.dateToPicker.tintColor = CSS.shared.orange
        self.dateToPicker.activateConstraints([
            self.dateToPicker.centerXAnchor.constraint(equalTo: self.calendarsContainerView.centerXAnchor),
            self.dateToPicker.centerYAnchor.constraint(equalTo: self.calendarsContainerView.centerYAnchor)
        ])
        
        self.calendarsContainerView.hide()
        
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
        self.view.bringSubviewToFront(self.calendarsContainerView)
        
        DELAY(0.5) {
            self.loadData()
        }
    }
    
    @objc func dateFromButtonOnTap(_ sender: UIButton?) {
        self.dateFromPicker.show()
        self.dateToPicker.hide()
            self.calendarsContainerView.show()
    }
    @objc func dateToButtonOnTap(_ sender: UIButton?) {
        self.dateFromPicker.hide()
        self.dateToPicker.show()
            self.calendarsContainerView.show()
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
        } else {
            if(!self.calendarsContainerView.isHidden) {
                UIView.animate(withDuration: 0.3) {
                    self.calendarsContainerView.alpha = 0
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.calendarsContainerView.hide()
                    self.calendarsContainerView.alpha = 1
                }
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
            formatter.calendar = Calendar(identifier: .gregorian)
        
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
            formatter.calendar = Calendar(identifier: .gregorian)
        
            return formatter.string(from: startDate) + ":" + formatter.string(from: endDate)
        }
    }
    
    func loadData() {
        self.offset = 1
    
        self.showLoading()
        NewsLetterData.shared.loadData(range: self.getRange(),
            type: self.getType(), offset: self.offset) { (error, stories, current, total) in
            
            self.hideLoading()
            
            if let _ = error {
                CustomNavController.shared.infoAlert(message: "Trouble loading the newsletter,\nplease try again later.")
            } else {
                MAIN_THREAD {
                    self.add(stories: stories, current, total)
                }
            }
        }
    }
    
    func loadMoreData() {
        self.offset += 1
    
        self.showLoading()
        NewsLetterData.shared.loadData(range: self.getRange(),
            type: self.getType(), offset: self.offset) { (error, stories, current, total) in
            
            self.hideLoading()
            
            if let _ = error {
                CustomNavController.shared.infoAlert(message: "Trouble loading the newsletter,\nplease try again later.")
            } else {
                MAIN_THREAD {
                    self.add(clean: false, stories: stories, current, total)
                }
            }
        }
    }
    
    private func add(clean: Bool = true, stories: [NewsLetterStory], _ current: Int, _ total: Int) {
        print("current", current, "total", total)
        
        if(clean) {
            self.stories = stories
            self.storiesVStack.removeAllArrangedSubviews()
        } else {
            for ST in stories {
                self.stories.append(ST)
            }
        
            let last = self.storiesVStack.arrangedSubviews.last!
            last.removeFromSuperview()
            //self.storiesVStack.removeArrangedSubview(last)
        }
        
        if(stories.count == 0) {
            ADD_SPACER(to: self.storiesVStack, height: 16)
        
            let infoLabel = UILabel()
            infoLabel.text = "No result found"
            infoLabel.textColor = CSS.shared.displayMode().main_textColor
            infoLabel.font = AILERON(16)
            infoLabel.textAlignment = .center
            
            self.storiesVStack.addArrangedSubview(infoLabel)
        } else {
            for (i, ST) in stories.enumerated() {
                let newItem = self.createStoryView(i, ST)
                self.storiesVStack.addArrangedSubview(newItem)
                
                if(IPHONE()) {
                    ADD_SPACER(to: self.storiesVStack, height: 15)
                } else {
                    ADD_SPACER(to: self.storiesVStack, height: 25)
                }
            }
            
            if(total>0 && current<total) {
                let newItem = self.createLoadMore()
                self.storiesVStack.addArrangedSubview(newItem)
            }
        }
    }
    
    private func createLoadMore() -> UIView {
        let loadMoreView = UIView()
        loadMoreView.backgroundColor = self.view.backgroundColor
        loadMoreView.activateConstraints([
            loadMoreView.heightAnchor.constraint(equalToConstant: 88)
        ])
        
        let button = UIButton(type: .custom)
        loadMoreView.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: loadMoreView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: loadMoreView.centerYAnchor)
        ])
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        button.titleLabel?.font = AILERON(15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        button.addTarget(self, action: #selector(loadMoreOnTap(_:)), for: .touchUpInside)
        
        return loadMoreView
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.loadMoreData()
    }
    
    private func createStoryView(_ index: Int, _ data: NewsLetterStory) -> UIView {
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
        
        if(IPHONE()) {
            let limit: CGFloat = 25
            var iphoneFont = DM_SERIF_DISPLAY_resize(16)
            if(iphoneFont.pointSize > limit) {
                iphoneFont = DM_SERIF_DISPLAY(limit)
            }
            
            titleLabel.font = iphoneFont
        } else {
            titleLabel.font = DM_SERIF_DISPLAY_resize(26)
        }
        
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
        
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        storyView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: storyView.leadingAnchor, constant: 0),
            buttonArea.topAnchor.constraint(equalTo: storyView.topAnchor, constant: 0),
            buttonArea.trailingAnchor.constraint(equalTo: storyView.trailingAnchor, constant: 0),
            buttonArea.bottomAnchor.constraint(equalTo: storyView.bottomAnchor, constant: 0)
        ])
        buttonArea.tag = index
        buttonArea.addTarget(self, action: #selector(storyOnTap(_:)), for: .touchUpInside)
        
        return storyView
    }

    func FORMAT(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
    
        return formatter.string(from: date)
    }

//    @objc func storyOnTap(_ sender: UIButton) { // Open content in web browser
//        let i = sender.tag
//        let ST = self.stories[i]
//        
//        var url = ""
//        if(ST.type==1) {
//            url = "https://www.improvethenews.org/daily-newsletter?date=" + ST.date
//        } else {
//            url = "https://www.improvethenews.org/weekly-newsletters?date=" + ST.date
//        }
//        
//        if(!url.isEmpty) {
//            OPEN_URL(url)
//        }
//    }

    @objc func storyOnTap(_ sender: UIButton) {
        let i = sender.tag
        let ST = self.stories[i]
        
//        print(ST)
        let vc = NewsLetterContentViewController()
        vc.refData = ST
        CustomNavController.shared.pushViewController(vc, animated: true)
        
        //NewsLetterData.shared.loadNewsletter(ST)
        
//        print( ST.date )
//        print( ST.type )
//
//        if(ST.type == 1) {
//            FUTURE_IMPLEMENTATION("Open Daily story")
//        } else {
//            FUTURE_IMPLEMENTATION("Open Weekly story")
//        }
    }
    
}

extension NewsLetterArchiveViewController: CalendarViewDelegate {

    func showCalendar(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let startDate = formatter.date(from: "2000/01/01")!
        let endDate = formatter.date(from: "2030/12/01")!
        
        let calendarView = MonthCalendarView(startDate: startDate, endDate: endDate)
        calendarView.allowsDateSelection = true
        calendarView.isPagingEnabled = true
        calendarView.scrollDirection = .horizontal
        calendarView.selectedDate = date // Today!
        calendarView.viewConfiguration = self.calendarConfigObj()
        calendarView.delegate = self
        
        self.view.addSubview(calendarView)
        calendarView.activateConstraints([
            calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 400),
            calendarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            calendarView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        DELAY(0.1) {
            calendarView.scroll(to: date, animated: false)
        }
    }
    
    func calendarConfigObj() -> CalendarConfig {
        var result = CalendarConfig()
        
//        result.backgroundColor = .yellow
//        result.weekdayTitlesBackgroundColor = .yellow
//        result.monthTitleBackgroundColor = .yellow
//        
//        result.dotColor = CSS.shared.orange

        result.backgroundColor = .black
        result.selectionColor = .red
        result.dotColor = .red
        result.selectedDotColor = .white
        result.weekendLabelColor = .gray
        result.validLabelColor = .white
        result.invalidLabelColor = .lightGray
        result.todayLabelColor = .red
        result.otherMonthLabelColor = .lightGray
        result.dateLabelFont = UIFont.systemFont(ofSize: 11, weight: .medium)
        result.invalidatePastDates = false
        result.monthTitleFont = UIFont.systemFont(ofSize: 16, weight: .heavy)
        result.monthTitleHeight = 18
        result.monthTitleTextColor = .white
        result.monthTitleAlignment = .left
        result.monthTitleBackgroundColor = .black
        result.monthTitleStyle = .short
        result.monthTitleIncludesYear = false
        result.weekdayTitleFont = UIFont.systemFont(ofSize: 11, weight: .bold)
        result.weekdayTitleColor = .red
        result.weekdayTitleHeight = 13
        result.weekdayTitlesBackgroundColor = .black
        
        return result
    }
    
    // ------------------------
    func calendarView(_ calendarView: any CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath) {
        print("NEW DATE", date)
    }

}

extension NewsLetterArchiveViewController {
    
    func addCopyButton() {
        let copyButton = UIButton(type: .custom)
        copyButton.setTitle("Copy", for: .normal)
        copyButton.titleLabel?.font = AILERON(14)
        copyButton.backgroundColor = CSS.shared.cyan
        copyButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        copyButton.layer.cornerRadius = 4.0
        self.mainContentView.addSubview(copyButton)
        copyButton.activateConstraints([
            copyButton.widthAnchor.constraint(equalToConstant: 75),
            copyButton.heightAnchor.constraint(equalToConstant: 40),
            copyButton.topAnchor.constraint(equalTo: self.mainContentView.topAnchor, constant: 16),
            copyButton.trailingAnchor.constraint(equalTo: self.mainContentView.trailingAnchor, constant: -16)
        ])
        copyButton.addTarget(self, action: #selector(self.onCopyButtonTap(_:)), for: .touchUpInside)
    }
    
    @objc func onCopyButtonTap(_ sender: UIButton?) {
        let toCopy = "Date range: " + self.getRange() + " (" +
                        self.dateOptions[self.currentDate] + ") - Filter: " + self.getType()
        
        print(toCopy)
        UIPasteboard.general.string = toCopy
        CustomNavController.shared.infoAlert(message: "Text copied!")
    }
    
}
