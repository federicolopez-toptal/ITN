//
//  SlidersPanel.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/09/2022.
//

import UIKit

class SlidersPanel: UIView {

    private let height: CGFloat = 600
    private var bottomConstraint: NSLayoutConstraint?

    private let titles = ["Political stance", "Establishment stance", "Writing style", "Depth", "Shelf-life", "Recency"]
    private let defaultValues = [50, 50, 70, 70, 70, 70]
    private let legends = [("Left", "Right"), ("Critical", "Pro"), ("Provocative", "Nuanced"), ("Breezy", "Detailed"),
                            ("Short", "Long"), ("Evergreen", "Latest")]

    private var rowsShown: Int = 0

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func insertInto(_ container: UIView) {
        // Panel (self)
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
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
        
        // Rows container
        let rowsVStack = UIStackView()
        rowsVStack.axis = .vertical
        rowsVStack.spacing = 5.0
        rowsVStack.backgroundColor = .clear
        self.addSubview(rowsVStack)
        rowsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rowsVStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            rowsVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            rowsVStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
        
        for i in 1...6 {
            // Each row
            let titleHStack = UIStackView()
            titleHStack.axis = .horizontal
            titleHStack.spacing = 0
            titleHStack.backgroundColor = .clear
            rowsVStack.addArrangedSubview(titleHStack)
            
                let titleLabel = UILabel()
                titleLabel.text = self.titles[i-1]
                titleHStack.addArrangedSubview(titleLabel)
                
                self.addSpacer(to: titleHStack)
                
                if(i<3) {
                    let splitLabel = UILabel()
                    splitLabel.text = "SPLIT"
                    titleHStack.addArrangedSubview(splitLabel)
                }
            
            let legendsHStack = UIStackView()
            legendsHStack.axis = .horizontal
            legendsHStack.spacing = 0
            legendsHStack.backgroundColor = .clear
            rowsVStack.addArrangedSubview(legendsHStack)
            
            let _legends = self.legends[i-1]
            
                let leftLabel = UILabel()
                leftLabel.text = _legends.0
                legendsHStack.addArrangedSubview(leftLabel)
                
                self.addSpacer(to: legendsHStack)
                
                let rightLabel = UILabel()
                rightLabel.text = _legends.1
                legendsHStack.addArrangedSubview(rightLabel)
            
            var sliderValue = self.defaultValues[i-1]
            if let _value = READ(LocalKeys.sliders.allKeys[i-1]) {
                sliderValue = Int(_value)!
            }
            
            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 99
            slider.isContinuous = false
            slider.minimumTrackTintColor = .orange
            slider.maximumTrackTintColor = .gray
            slider.thumbTintColor = .systemPink
            slider.tag = 20 + i
            slider.setValue(Float(sliderValue), animated: false)
            slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
            rowsVStack.addArrangedSubview(slider)
        }
        
        self.addSwipeGesture()
        self.show(rows: 0)
    }
    
    private func addSpacer(to container: UIStackView, backgroundColor: UIColor = .clear, width: CGFloat? = nil) {
        let spacer = UIView()
        spacer.backgroundColor = backgroundColor
        container.addArrangedSubview(spacer)
        
        if let _width = width {
            spacer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                spacer.widthAnchor.constraint(equalToConstant: _width)
            ])
        }
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
                constant = self.height - 250
                
            default:
                constant = 0
        }
        
        self.bottomConstraint?.constant = constant
        if(animated) {
            UIView.animate(withDuration: 0.4) {
                self.superview!.layoutIfNeeded()
            } completion: { (succeed) in
            }
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
    }
    
    @objc func onViewSwipe(_ gesture: UISwipeGestureRecognizer) {
        if(gesture.direction == .up) {
            if(self.rowsShown == 2) {
                self.show(rows: 6, animated: true)
            }
        } else if(gesture.direction == .down) {
            self.show(rows: 0, animated: true)
        }
    }
    
}
