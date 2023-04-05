//
//  RatingView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/01/2023.
//

import UIKit

class RatingView: UIView {

    var url: String = ""
    var HEIGHT: CGFloat = 64
    var currentRating: Int = 0
    
    let label = UILabel()
    let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("popup.close")))
    let buttonLabel = UILabel()
    let starsContainer = UIView()
    let loading = UIActivityIndicatorView(style: .medium)
    let thanksLabel = UILabel()
    
    var bottomConstraint: NSLayoutConstraint? = nil
    


    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    func buildInto(viewController: UIViewController, url: String) {
        self.url = url
    
        if(SAFE_AREA()!.bottom > 0) {
            self.HEIGHT += 15
        }
    
        viewController.view.addSubview(self)
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: self.HEIGHT),
            self.bottomConstraint!
        ])
    
        let line = UIView()
        line.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.2) : UIColor(hex: 0xE2E3E3)
        self.addSubview(line)
        line.activateConstraints([
            line.topAnchor.constraint(equalTo: self.topAnchor),
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
        ])
    
        self.label.text = "Rate article"
        self.label.font = MERRIWEATHER_BOLD(15)
        self.label.textColor = .white
        self.addSubview(self.label)
        self.label.activateConstraints([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: 22)
        ])
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: 0xFF643C)
        button.layer.cornerRadius = 4
        self.addSubview(button)
        button.activateConstraints([
            button.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -46),
            button.widthAnchor.constraint(equalToConstant: 74),
            button.heightAnchor.constraint(equalToConstant: 35)
        ])
        button.addTarget(self, action: #selector(rateButtonOnTap(_:)), for: .touchUpInside)
                
        self.buttonLabel.textColor = .white
        self.buttonLabel.font = ROBOTO_BOLD(12)
        self.buttonLabel.text = "RATE"
        self.addSubview(self.buttonLabel)
        self.buttonLabel.activateConstraints([
            self.buttonLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            self.buttonLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        ])
        
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let closeButton = UIButton(type: .custom)
        closeButton.backgroundColor = .clear
        self.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5)
        ])
        closeButton.addTarget(self, action: #selector(closeButtonOnTap(_:)), for: .touchUpInside)
        
        self.loading.color = .white
        self.addSubview(self.loading)
        self.loading.activateConstraints([
            self.loading.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            self.loading.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        self.loading.startAnimating()
        self.loading.hide()
        
        self.thanksLabel.text = "Thank you!"
        self.thanksLabel.font = MERRIWEATHER_BOLD(13)
        self.thanksLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.thanksLabel.textAlignment = .center
        self.addSubview(self.thanksLabel)
        self.thanksLabel.activateConstraints([
            self.thanksLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            self.thanksLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        self.thanksLabel.hide()
        
        self.starsContainer.backgroundColor = .clear //.green
        self.addSubview(self.starsContainer)
        self.starsContainer.activateConstraints([
            self.starsContainer.leadingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: 14),
            self.starsContainer.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            self.starsContainer.heightAnchor.constraint(equalToConstant: 20),
            self.starsContainer.widthAnchor.constraint(equalToConstant: 120)
        ])
        self.starsContainer.isUserInteractionEnabled = true
        
        var valX: CGFloat = 0
        for i in 1...5 {
            //let star = UIImageView(image: UIImage(named: DisplayMode.imageName("star")))
            let star = UIImageView(image: UIImage(named: "starFilled"))
            self.starsContainer.addSubview(star)
            star.activateConstraints([
                star.widthAnchor.constraint(equalToConstant: 20),
                star.heightAnchor.constraint(equalToConstant: 20),
                star.leadingAnchor.constraint(equalTo: self.starsContainer.leadingAnchor, constant: valX),
                star.topAnchor.constraint(equalTo: self.starsContainer.topAnchor)
            ])
            star.isUserInteractionEnabled = false
            star.tag = 30 + i
            
            valX += 20 + 5
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onStarsPan(_:)))
        starsContainer.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onStarsTap(_:)))
        starsContainer.addGestureRecognizer(tapGesture)
        
        self.refreshDisplayMode()
        self.setValue(0)
        
        if(self.articleWasRated()) {
            self.bottomConstraint?.constant = self.HEIGHT
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : .white
        self.label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.closeIcon.image = UIImage(named: DisplayMode.imageName("popup.close"))
    }

}


// PRAGMA MARK: - Event(s)
extension RatingView {
    
    @objc func rateButtonOnTap(_ sender: UIButton) {
        self.isUserInteractionEnabled = false
        
        sender.alpha = 0.5
        self.buttonLabel.text = ""
        self.loading.show()
        
        self.submitRating { (error, success) in
            MAIN_THREAD {
                self.loading.hide()
                self.isUserInteractionEnabled = true
            }
            
            if(success) {
                MAIN_THREAD {
                    sender.hide()
                    self.setArticleAsRated()
                    self.thanksLabel.show()
                    
                    DELAY(2.0) {
                        self.close()
                    }
                }
            } else {
                MAIN_THREAD {
                    sender.alpha = 1.0
                    self.buttonLabel.text = "RATE"
                }
            }
            
        }
    }
    
    @objc func closeButtonOnTap(_ sender: UIButton) {
        self.close()
    }
    
    func close() {
        self.bottomConstraint?.constant = self.HEIGHT
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    @objc func onStarsPan(_ gesture: UIPanGestureRecognizer) {
        let currentX = gesture.location(in: self.starsContainer).x
        
        var val_X: CGFloat = 0
        var starsCount = 0
        for _ in 1...5 {
            val_X += 20
            if(currentX >= val_X) {
                starsCount += 1
            }
            val_X += 5
        }
        
        self.setValue(starsCount)
    }
    
    @objc func onStarsTap(_ gesture: UITapGestureRecognizer) {
        let currentX = gesture.location(in: self.starsContainer).x
        
        var val_X: CGFloat = 0
        var starsCount = 0
        for _ in 1...5 {
            if(currentX >= val_X) {
                starsCount += 1
            }
            
            val_X += 20
            val_X += 5
        }
        
        self.setValue(starsCount)
    }
    
    
    
}

// PRAGMA MARK: - misc
extension RatingView {
    
    func setValue(_ value: Int) {
        for i in 1...5 {
            let tag = 30 + i
            if let star = self.starsContainer.viewWithTag(tag) as? UIImageView {
                if(i <= value) {
                    star.alpha = 1
                } else {
                    star.alpha = 0.4
                }
            }
        }
        
        self.currentRating = value
    }
    
    func articleWasRated() -> Bool {
        let key = keyName(self.url)
        if let _ = READ(key) {
            return true
        }
        return false
    }
    
    func setArticleAsRated() {
        let key = keyName(self.url)
        WRITE(key, value: "rated!")
    }
    
    func keyName(_ url: String) -> String {
        var result = url
        result = result.replacingOccurrences(of: ":", with: "")
        result = result.replacingOccurrences(of: ".", with: "")
        result = result.replacingOccurrences(of: "/", with: "")
        result = result.replacingOccurrences(of: "-", with: "")
        return result
    }
    
    func submitRating(callback: @escaping (Error?, Bool) -> ()) {
        let parsedUrl = self.url.replacingOccurrences(of: "//", with: "")
        let url = API_BASE_URL() + "/srating.php?uid=" + UUID.shared.getValue() +
            "&url=" + parsedUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! +
            "&rating=" + String(self.currentRating) + "&pwd=31415926535"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
            }
                
            if let _error = error {
                print(_error.localizedDescription)
                callback(_error, false)
            } else {
                if let _json = JSON(fromData: data) {
                    if let _status = _json["status"] as? Int, _status==200 {
                        callback(nil, true)
                    }
                } else {
                    let _error = CustomError.jsonParseError
                    callback(_error, false)
                }
            }
        }
        
        task.resume()
    }
    
}
