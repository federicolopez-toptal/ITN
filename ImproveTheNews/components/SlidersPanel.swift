//
//  SlidersPanel.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/09/2022.
//

import UIKit

class SlidersPanel: UIView {

    private let height: CGFloat = 615
    private var bottomConstraint: NSLayoutConstraint?

    private let titles = ["Political stance", "Establishment stance",
        "Writing style", "Depth", "Shelf-life", "Recency"]
    private let legends = [("Left", "Right"), ("Critical", "Pro"), ("Provocative", "Nuanced"),
        ("Breezy", "Detailed"), ("Short", "Long"), ("Evergreen", "Latest")]

    private var rowsShown: Int = 0
    private var split: Int = 0
    private var coverView = UIView()

    var displayModeComponents = [Any]()


    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView) {
        // Panel (self)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
    self.bottomConstraint = self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        //Handle
        let handle = UIImageView(image: UIImage(named: "slidersPanel.handle.bright"))
        self.addSubview(handle)
        handle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handle.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            handle.widthAnchor.constraint(equalToConstant: 50),
            handle.heightAnchor.constraint(equalToConstant: 5),
        ])
        self.displayModeComponents.append(handle)
        
        // Rows container
        let rowsVStack = VSTACK(into: self, spacing: 5.0)
        rowsVStack.backgroundColor = .clear
        rowsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rowsVStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 55),
            rowsVStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            rowsVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27)
        ])
        
        let roboto_bold = UIFont(name: "Roboto-Bold", size: 13)
        let characterSpacing: Double = 1.5
        
        for i in 1...6 {
            // Each row
            let titleHStack = HSTACK(into: rowsVStack)
            titleHStack.backgroundColor = .clear
            
                let titleLabel = UILabel()
                titleLabel.text = self.titles[i-1].uppercased()
                titleLabel.font = roboto_bold
                titleLabel.textColor = UIColor(hex: 0x1D242F)
                titleLabel.addCharacterSpacing(kernValue: characterSpacing)
                titleHStack.addArrangedSubview(titleLabel)
                titleLabel.tag = 3
                self.displayModeComponents.append(titleLabel)
                
                ADD_SPACER(to: titleHStack)
                
                if(i<3) {
                    var topValue: CGFloat = 54
                    if(i==2){ topValue += 86 }
                
                    let square = UIImageView(image: UIImage(named: "slidersPanel.split.square"))
                    self.addSubview(square)
                    square.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        square.widthAnchor.constraint(equalToConstant: 15),
                        square.heightAnchor.constraint(equalToConstant: 15),
                        square.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -76),
                        square.topAnchor.constraint(equalTo: self.topAnchor, constant: topValue),
                    ])
                    
                    let check = UIImageView(image: UIImage(named: "slidersPanel.split.check"))
                    self.addSubview(check)
                    check.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        check.widthAnchor.constraint(equalToConstant: 18),
                        check.heightAnchor.constraint(equalToConstant: 14),
                        check.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -71),
                        check.topAnchor.constraint(equalTo: self.topAnchor, constant: topValue-3),
                    ])
                    check.tag = 40 + i
                    check.hide()
                    
                    let checkButton = UIButton(type: .system)
                    checkButton.backgroundColor = .clear
                    checkButton.alpha = 0.5
                    self.addSubview(checkButton)
                    checkButton.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        checkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: topValue-10),
                        checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
                        checkButton.widthAnchor.constraint(equalToConstant: 100),
                        checkButton.heightAnchor.constraint(equalToConstant: 35),
                    ])
                    checkButton.tag = 30 + i
                    checkButton.addTarget(self, action: #selector(onSplitButtonTap(_:)), for: .touchUpInside)
                
                    let splitLabel = UILabel()
                    splitLabel.text = "SPLIT"
                    splitLabel.font = roboto_bold
                    splitLabel.textColor = UIColor(hex: 0x1D242F)
                    splitLabel.addCharacterSpacing(kernValue: characterSpacing)
                    titleHStack.addArrangedSubview(splitLabel)
                    splitLabel.tag = 3
                    self.displayModeComponents.append(splitLabel)
                    
                    let hLine = UIView()
                    hLine.backgroundColor = UIColor(hex: 0xFF643C)
                    self.addSubview(hLine)
                    hLine.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hLine.widthAnchor.constraint(equalToConstant: 6),
                        hLine.heightAnchor.constraint(equalToConstant: 20),
                        hLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        hLine.topAnchor.constraint(equalTo: self.topAnchor, constant: topValue + 52),
                    ])
                    hLine.layer.cornerRadius = 3.0
                    hLine.tag = 50 + i
                    hLine.hide()
                }
            
            ADD_SPACER(to: rowsVStack, height: 6)
            
            let legendsHStack = HSTACK(into: rowsVStack)
            legendsHStack.backgroundColor = .clear
            
            let _legends = self.legends[i-1]
            
                let leftLabel = UILabel()
                leftLabel.text = _legends.0.uppercased()
                leftLabel.font = roboto_bold
                leftLabel.textColor = UIColor(hex: 0x93A0B4)
                leftLabel.addCharacterSpacing(kernValue: characterSpacing)
                legendsHStack.addArrangedSubview(leftLabel)
                leftLabel.tag = 4
                self.displayModeComponents.append(leftLabel)
                
                ADD_SPACER(to: legendsHStack)
                
                let rightLabel = UILabel()
                rightLabel.text = _legends.1.uppercased()
                rightLabel.font = roboto_bold
                rightLabel.textColor = UIColor(hex: 0x93A0B4)
                rightLabel.addCharacterSpacing(kernValue: characterSpacing)
                legendsHStack.addArrangedSubview(rightLabel)
                rightLabel.tag = 4
                self.displayModeComponents.append(rightLabel)
            
            var sliderValue = LocalKeys.sliders.defaultValues[i-1]
            if let _value = READ(LocalKeys.sliders.allKeys[i-1]) {
                sliderValue = Int(_value)!
            }
            
            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 99
            slider.isContinuous = false
            slider.minimumTrackTintColor = UIColor(hex: 0xD9DCDF)
            slider.maximumTrackTintColor = UIColor(hex: 0xD9DCDF)
            slider.setThumbImage(UIImage(named: "slidersThumb"), for: .normal)
//            slider.thumbTintColor = UIColor(hex: 0xFF643C)
            slider.tag = 20 + i
            slider.setValue(Float(sliderValue), animated: false)
            slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
            rowsVStack.addArrangedSubview(slider)
            
            ADD_SPACER(to: rowsVStack, height: 8)
        }
        
        self.coverView.backgroundColor = self.backgroundColor
        self.addSubview(self.coverView)
        self.coverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coverView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.coverView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.coverView.topAnchor.constraint(equalTo: self.topAnchor, constant: 228),
            self.coverView.heightAnchor.constraint(equalToConstant: 400)
        ])
        self.coverView.isUserInteractionEnabled = false
        self.coverView.hide()
        
        self.addSwipeGesture()
        self.show(rows: 0)
        
        // split value
        if let _split = READ(LocalKeys.sliders.split) {
            self.split = Int(_split)!
            self.checkSplitComponents()
        }
        
        ADD_SHADOW(to: self, offset: CGSize(width: 0, height: -3))
        self.refreshDisplayMode()
    }
    
    private func addSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.onViewSwipe(_:)))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.onViewSwipe(_:)))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)
    }
    
    func show(rows: Int, animated: Bool = false) {
        self.rowsShown = rows
        var constant: CGFloat = 0
        
        switch(rows) {
            case 0:
                constant = self.height
            case 2:
                constant = self.height - 275
                
            default:
                constant = 0
        }
        
        var alphaTo: CGFloat = 0.0
        
        self.coverView.show()
        if(rows == 2) {
            alphaTo = 1.0
        }
        
        self.bottomConstraint?.constant = constant
        if(animated) {
            UIView.animate(withDuration: 0.4) {
                self.coverView.alpha = alphaTo
                self.superview!.layoutIfNeeded()
            } completion: { (succeed) in
            }
        }
           
        var panelState = "0"
        if(rows == 2){ panelState = "1" }
        else if(rows == 6){ panelState = "2" }
        WRITE(LocalKeys.sliders.panelState, value: panelState)
    }
    
    private func checkSplitComponents() {
        for i in 1...2 {
            // update check
            if(i==self.split) {
                self.viewWithTag(40+i)?.show()
            } else {
                self.viewWithTag(40+i)?.hide()
            }
            
            // update slider thumb
            var imageAlpha = 1.0
            let slider = self.viewWithTag(20 + i) as! UISlider
            let hLine = self.viewWithTag(50 + i)!
            
            if(i==self.split) {
                imageAlpha = 0.0
                slider.isUserInteractionEnabled = false
                hLine.show()
            } else {
                slider.isUserInteractionEnabled = true
                hLine.hide()
            }
            
            let alphaImage = UIImage(named: "slidersThumb")?.image(alpha: imageAlpha)
            slider.setThumbImage(alphaImage, for: .normal)
        }
    }
    
}

// MARK: - Event(s)
extension SlidersPanel {
    
    @objc func sliderOnValueChange(_ sender: UISlider) {
        let tag = sender.tag - 20
        let newValue = Int(round(sender.value))
        let strValue = String(format: "%02d", newValue)
        let key = LocalKeys.sliders.allKeys[tag-1]
        
        WRITE(key, value: strValue)
        NOTIFY(Notification_reloadMainFeed)
    }
    
    @objc func onViewSwipe(_ gesture: UISwipeGestureRecognizer) {
        if(gesture.direction == .up) {
            if(self.rowsShown == 2) {
                self.show(rows: 6, animated: true)
            }
        } else if(gesture.direction == .down) {
            if(self.rowsShown == 2) {
                self.show(rows: 0, animated: true)
            } else if(self.rowsShown == 6) {
                self.show(rows: 2, animated: true)
            }
        }
    }
    
    @objc func onSplitButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 30
        if(self.split == tag) {
            self.split = 0
        } else {
            self.split = tag
        }
        
        self.checkSplitComponents()
//        print("SPLIT", self.split)
        WRITE(LocalKeys.sliders.split, value: String(self.split))
        NOTIFY(Notification_reloadMainFeed)
    }
    
    func floatingButtonOnTap() {
        if(self.rowsShown == 0) {
            self.show(rows: 2, animated: true)
        } else if(self.rowsShown==2) {
            self.show(rows: 0, animated: true)
        } else if(self.rowsShown==6) {
            self.show(rows: 2, animated: true)
        }
    }
    
}

// MARK: - Display mode(s)
extension SlidersPanel {

    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : .white
        self.coverView.backgroundColor = self.backgroundColor
        
        for C in self.displayModeComponents {
            if(C is UILabel) {
                let label = (C as! UILabel)
                if(label.tag == 3) { // title & split
                    label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
                } else if(label.tag == 4) { // left & right legends
                    label.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x93A0B4)
                }
            }
            
            // handle
            if(C is UIImageView) {
                let handle = (C as! UIImageView)
                handle.image = UIImage(named: DisplayMode.imageName("slidersPanel.handle"))
            }
        }
        
        // sliders
        for i in 1...6 {
            let slider = self.viewWithTag(20 + i) as! UISlider
            
            if(DARK_MODE()) {
                slider.minimumTrackTintColor = UIColor(hex: 0x545B67)
                slider.maximumTrackTintColor = UIColor(hex: 0x545B67)
            } else {
                slider.minimumTrackTintColor = UIColor(hex: 0xD9DCDF)
                slider.maximumTrackTintColor = UIColor(hex: 0xD9DCDF)
            }
        }
    }
    
}
