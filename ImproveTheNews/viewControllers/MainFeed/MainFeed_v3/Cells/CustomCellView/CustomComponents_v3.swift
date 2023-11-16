//
//  CustomComponents_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import Foundation
import UIKit
import SDWebImage


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class CustomImageView: UIImageView {
    
    let cornerTag = 5
    let imgIcon = UIImageView()
    let loading = UIActivityIndicatorView(style: .large)
    
    // MARK: - Start
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = CSS.shared.displayMode().imageView_bgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        // Corners
            let corner1_A = UIView()
            corner1_A.backgroundColor = .white
            self.addSubview(corner1_A)
            corner1_A.activateConstraints([
                corner1_A.widthAnchor.constraint(equalToConstant: 16),
                corner1_A.heightAnchor.constraint(equalToConstant: 3),
                corner1_A.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                corner1_A.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            ])
            corner1_A.tag = self.cornerTag
            
            let corner1_B = UIView()
            corner1_B.backgroundColor = .white
            self.addSubview(corner1_B)
            corner1_B.activateConstraints([
                corner1_B.widthAnchor.constraint(equalToConstant: 3),
                corner1_B.heightAnchor.constraint(equalToConstant: 16),
                corner1_B.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                corner1_B.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            ])
            corner1_B.tag = self.cornerTag
            
            let corner2_A = UIView()
            corner2_A.backgroundColor = .white
            self.addSubview(corner2_A)
            corner2_A.activateConstraints([
                corner2_A.widthAnchor.constraint(equalToConstant: 3),
                corner2_A.heightAnchor.constraint(equalToConstant: 16),
                corner2_A.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                corner2_A.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
            corner2_A.tag = self.cornerTag
            
            let corner2_B = UIView()
            corner2_B.backgroundColor = .white
            self.addSubview(corner2_B)
            corner2_B.activateConstraints([
                corner2_B.widthAnchor.constraint(equalToConstant: 16),
                corner2_B.heightAnchor.constraint(equalToConstant: 3),
                corner2_B.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                corner2_B.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
            corner2_B.tag = self.cornerTag
        // Corners
        
        self.imgIcon.image = UIImage(named: "noImageIcon")?.withRenderingMode(.alwaysTemplate)
        self.addSubview(self.imgIcon)
        self.imgIcon.activateConstraints([
            self.imgIcon.widthAnchor.constraint(equalToConstant: 72 * 0.7),
            self.imgIcon.heightAnchor.constraint(equalToConstant: 63 * 0.7),
            self.imgIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.imgIcon.hide()
        
        self.loading.hidesWhenStopped = true
        self.addSubview(self.loading)
        self.loading.activateConstraints([
            self.loading.centerXAnchor.constraint(equalTo: self.imgIcon.centerXAnchor, constant: 0),
            self.loading.centerYAnchor.constraint(equalTo: self.imgIcon.centerYAnchor, constant: 0)
        ])
        self.loading.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(url: String) {
        self.image = nil
        self.loading.startAnimating()
        self.imgIcon.hide()
        
        if let _url = URL(string: FIX_URL(url)) {
            self.sd_setImage(with: _url) { (img, error, cacheType, url) in
                self.loading.stopAnimating()
                if(img == nil) {
                    self.imgIcon.show()
                }
            }
        }
    }
    
    func load(url: String, callback: @escaping (Bool, CGSize?) -> ()) {
        self.image = nil
        self.loading.startAnimating()
        self.imgIcon.hide()
        
        if let _url = URL(string: FIX_URL(url)) {
            self.sd_setImage(with: _url) { (img, error, cacheType, url) in
                self.loading.stopAnimating()
                if(img != nil) {
                    self.imgIcon.hide()
                    callback(true, img?.size)
                } else {
                    self.imgIcon.show()
                    callback(false, nil)
                }
            }
        } else {
            self.loading.stopAnimating()
            callback(false, nil)
        }
    }
    
    func showCorners(_ state: Bool) {
        for V in self.subviews {
            if(V.tag == self.cornerTag) {
                if(state){ V.show() }
                else{ V.hide() }
            }
        }
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().imageView_bgColor
        self.imgIcon.image = UIImage(named: "noImageIcon")?.withRenderingMode(.alwaysTemplate)
        self.imgIcon.tintColor = CSS.shared.displayMode().imageView_iconColor
        self.loading.color = CSS.shared.displayMode().loading_color
    }
    
}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class StoryPillView: UIView {
    
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ container: UIView) {
        let W: CGFloat = 59
        let H: CGFloat = 24
        let F: CGFloat = 11
        
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: W),
            self.heightAnchor.constraint(equalToConstant: H)
        ])
        self.layer.cornerRadius = H/2
        
        self.label.text = "STORY"
        self.label.textAlignment = .center
        self.label.font = AILERON_SEMIBOLD(F)
        self.addSubview(self.label)
        self.label.activateConstraints([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? CSS.shared.orange.withAlphaComponent(0.2) : CSS.shared.orange
        self.label.textColor = DARK_MODE() ? CSS.shared.orange : .white
    }
    
}

// ------------------------------------
class StoryPillMiniView: UIView {
    
    let label = UILabel()
    
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ container: UIView) {
        let W: CGFloat = 43
        let H: CGFloat = 18
        let F: CGFloat = 8
        
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: W),
            self.heightAnchor.constraint(equalToConstant: H)
        ])
        self.layer.cornerRadius = H/2
        
        self.label.text = "STORY"
        self.label.textAlignment = .center
        self.label.font = AILERON_SEMIBOLD(F)
        self.addSubview(self.label)
        self.label.activateConstraints([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? CSS.shared.orange.withAlphaComponent(0.2) : CSS.shared.orange
        self.label.textColor = DARK_MODE() ? CSS.shared.orange : .white
    }
    
}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class SourceIconsView: UIView {
    
    let imgs = [UIImageView(), UIImageView(), UIImageView()]
    var widthConstraint: NSLayoutConstraint?

    private var SIZE: CGFloat
    private var BORDER: CGFloat
    private var SEPARATION: CGFloat

    init(size: CGFloat = 24, border: CGFloat = 3, separation: CGFloat = 20) {
        self.SIZE = size
        self.BORDER = border
        self.SEPARATION = separation
    
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func size() -> CGFloat {
        return self.SIZE + (self.BORDER * 2)
    }
    
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: self.size() * 3)
        self.activateConstraints([
            self.heightAnchor.constraint(equalToConstant: self.size()),
            self.widthConstraint!
        ])
        
        self.initImage(self.imgs[0], leading: 0)
        self.initImage(self.imgs[1], leading: self.SEPARATION)
        self.initImage(self.imgs[2], leading: self.SEPARATION*2)
        
        self.imgs[1].superview?.bringSubviewToFront(self.imgs[1])
        self.imgs[0].superview?.bringSubviewToFront(self.imgs[0])
    }
    
    private func initImage(_ img: UIImageView, leading: CGFloat) {
        self.addSubview(img)
        img.activateConstraints([
            img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading),
            img.topAnchor.constraint(equalTo: self.topAnchor),
            img.widthAnchor.constraint(equalToConstant: self.size()),
            img.heightAnchor.constraint(equalToConstant: self.size())
        ])
        img.layer.cornerRadius = self.size()/2
        img.clipsToBounds = true
        img.backgroundColor = .lightGray
        
        img.layer.borderColor = UIColor.red.cgColor
        img.layer.borderWidth = self.BORDER
    }
    
    func load(_ sources: [String]) {
        for I in self.imgs {
            I.hide()
        }
        self.widthConstraint?.constant = 0
        
        var num = 1
        for S in sources {
            if let _icon = Sources.shared.search(identifier: S), _icon.url != nil {
                let img = self.imgs[num-1]
                img.show()
                
                if(!_icon.url!.contains(".svg")) {
                    img.sd_setImage(with: URL(string: _icon.url!))
                } else {
                    img.image = UIImage(named: _icon.identifier + ".png")
                }

                switch(num) {
                    case 1:
                    self.widthConstraint?.constant = self.size()
                    
                    case 2:
                    self.widthConstraint?.constant = self.size() + self.SEPARATION
                    
                    case 3:
                    self.widthConstraint?.constant = self.size() + (self.SEPARATION * 2)
                    
                    default:
                    NOTHING()
                }

                num += 1
                if(num==4) {
                    break
                }
            }
        }
    }
    
    func refreshDisplayMode() {
        for I in self.imgs {
            I.layer.borderColor = CSS.shared.displayMode().main_bgColor.cgColor
        }
    }
    
    func customHide() {
        self.hide()
        self.widthConstraint?.constant = 0
    }
    
}
