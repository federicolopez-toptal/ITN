//
//  SubViewComponents_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 26/10/2023.
//

import Foundation
import UIKit
import SDWebImage


/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class ImageViewWithCorners: UIImageView {
    
    let imgIcon = UIImageView(image: UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate))
    
    // MARK: - Start
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .lightGray
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        let border1 = UIView()
        border1.backgroundColor = .white
        self.addSubview(border1)
        border1.activateConstraints([
            border1.widthAnchor.constraint(equalToConstant: 16),
            border1.heightAnchor.constraint(equalToConstant: 3),
            border1.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            border1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let border2 = UIView()
        border2.backgroundColor = .white
        self.addSubview(border2)
        border2.activateConstraints([
            border2.widthAnchor.constraint(equalToConstant: 3),
            border2.heightAnchor.constraint(equalToConstant: 16),
            border2.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            border2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let border3 = UIView()
        border3.backgroundColor = .white
        self.addSubview(border3)
        border3.activateConstraints([
            border3.widthAnchor.constraint(equalToConstant: 3),
            border3.heightAnchor.constraint(equalToConstant: 16),
            border3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            border3.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        let border4 = UIView()
        border4.backgroundColor = .white
        self.addSubview(border4)
        border4.activateConstraints([
            border4.widthAnchor.constraint(equalToConstant: 16),
            border4.heightAnchor.constraint(equalToConstant: 3),
            border4.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            border4.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        self.imgIcon.tintColor = UIColor.black
        self.imgIcon.alpha = 0.2
        self.addSubview(self.imgIcon)
        self.imgIcon.activateConstraints([
            self.imgIcon.widthAnchor.constraint(equalToConstant: 32 * 1.6),
            self.imgIcon.heightAnchor.constraint(equalToConstant: 26 * 1.6),
            self.imgIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imgIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.imgIcon.hide()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(url: String) {
        self.image = nil
        self.imgIcon.show()
        
        if let _url = URL(string: url) {
            self.sd_setImage(with: _url) { (img, error, cacheType, url) in
                if(img != nil) {
                    self.imgIcon.hide()
                }
            }
        }

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
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: 59),
            self.heightAnchor.constraint(equalToConstant: 24)
        ])
        self.layer.cornerRadius = 12
        
        self.label.text = "STORY"
        self.label.textAlignment = .center
        self.label.font = AILERON(11)
        self.addSubview(self.label)
        self.label.activateConstraints([
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0xDA4933).withAlphaComponent(0.2) : CSS.shared.orange
        self.label.textColor = DARK_MODE() ? CSS.shared.orange : .white
    }
    
}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
class SourceIconsView: UIView {
    
    let imgs = [UIImageView(), UIImageView(), UIImageView()]
    var widthConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 80)
        self.activateConstraints([
            self.heightAnchor.constraint(equalToConstant: 30),
            self.widthConstraint!
        ])
        
        self.initImage(self.imgs[0], leading: 0)
        self.initImage(self.imgs[1], leading: 20)
        self.initImage(self.imgs[2], leading: 40)
        
        self.imgs[1].superview?.bringSubviewToFront(self.imgs[1])
        self.imgs[0].superview?.bringSubviewToFront(self.imgs[0])
    }
    
    private func initImage(_ img: UIImageView, leading: CGFloat) {
        self.addSubview(img)
        img.activateConstraints([
            img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading),
            img.topAnchor.constraint(equalTo: self.topAnchor),
            img.widthAnchor.constraint(equalToConstant: 30),
            img.heightAnchor.constraint(equalToConstant: 30)
        ])
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.backgroundColor = .lightGray
        
        img.layer.borderColor = UIColor.red.cgColor
        img.layer.borderWidth = 3.0
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
                    self.widthConstraint?.constant = 30
                    
                    case 2:
                    self.widthConstraint?.constant = 30 + 20
                    
                    case 3:
                    self.widthConstraint?.constant = 30 + 20 + 20
                    
                    default:
                    self.widthConstraint?.constant = 30
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
    
}
