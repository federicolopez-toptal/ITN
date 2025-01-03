//
//  CollapsableSingleSourceView.swift.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/01/2025.
//

import Foundation
import UIKit

class CollapsableSingleSourceView: UIView {
    
    var widthConstraint: NSLayoutConstraint? = nil
    let nameLabel = UILabel()
    let actionButton = UIButton(type: .system)
    var url: String = ""
    var widthLimit: CGFloat = -1
    
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIStackView, source S: SourceForGraph) {
        container.addArrangedSubview(self)
        
        self.backgroundColor = .clear
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 25)
        self.activateConstraints([
            self.heightAnchor.constraint(equalToConstant: 31),
            self.widthConstraint!
        ])
    
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: 31),
            imageView.heightAnchor.constraint(equalToConstant: 31),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        if let _icon = Sources.shared.search(identifier: S.id), _icon.url != nil {
            if(!_icon.url!.contains(".svg")) {
                imageView.sd_setImage(with: URL(string: _icon.url!))
            } else {
                imageView.image = UIImage(named: _icon.identifier + ".png")
            }
        } else {
            let url = BUILD_LOGO_URL(id: S.name)
            
            imageView.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
                if let _ = error {
                    imageView.image = UIImage(named: "LINK64.png")
                }
            }
        }
        imageView.layer.cornerRadius = 28/2
        imageView.clipsToBounds = true
        
        let borderWidth: CGFloat = 2
        let borders = UIView()
        borders.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(borders)
        borders.activateConstraints([
            borders.widthAnchor.constraint(equalToConstant: 31+borderWidth+borderWidth),
            borders.heightAnchor.constraint(equalToConstant: 31+borderWidth+borderWidth),
            borders.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            borders.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        borders.layer.cornerRadius = (31+(borderWidth*2))/2
        self.sendSubviewToBack(borders)
        
        self.nameLabel.text = S.name
        self.nameLabel.font = AILERON(14)
        self.nameLabel.textColor = CSS.shared.displayMode().main_textColor
        self.addSubview(self.nameLabel)
        self.nameLabel.activateConstraints([
            self.nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 7),
            self.nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        if(self.widthLimit != -1) {
            let limit = self.widthLimit-31-7
            let currentWidth = self.nameLabel.calculateWidthFor(height: 17)
            
            if(currentWidth > limit) {
                //self.nameLabel.backgroundColor = .red.withAlphaComponent(0.25)
                self.nameLabel.numberOfLines = 1
                self.nameLabel.widthAnchor.constraint(equalToConstant: limit).isActive = true
            }
        }
        
        self.nameLabel.hide()
        
        self.actionButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(self.actionButton)
        self.actionButton.activateConstraints([
            self.actionButton.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.actionButton.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),
            self.actionButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.actionButton.addTarget(self, action: #selector(self.onActionButtonTap(_:)), for: .touchUpInside)
        
        self.close()
    }
    
    func fullWidth() -> CGFloat {
        return 31+7+self.nameLabel.calculateWidthFor(height: 17)+10
    }
    
    func open(animated: Bool = false) {
        var w: CGFloat = 31+7
        if(self.widthLimit == -1) {
            w += self.nameLabel.calculateWidthFor(height: 17)+10
        } else {
            let limit = self.widthLimit-31-7
            let currentWidth = self.nameLabel.calculateWidthFor(height: 17)
            
            if(currentWidth > limit) {
                w += limit
            } else {
                w += self.nameLabel.calculateWidthFor(height: 17)+10
            }
        }
        
        self.widthConstraint?.constant = w
        self.nameLabel.show()
        self.actionButton.show()
        
//        if(animated) {
//            self.nameLabel.alpha = 0
//            UIView.animate(withDuration: 0.3) {
//                self.nameLabel.alpha = 1
//                self.superview!.layoutIfNeeded()
//            }
//        } else {
//            self.nameLabel.alpha = 1
//        }
    }
    
    func close(animated: Bool = false) {
        self.widthConstraint?.constant = 21
//        self.nameLabel.alpha = 1
        self.actionButton.hide()
        self.nameLabel.hide()
        
//        if(animated) {
//            UIView.animate(withDuration: 0.3) {
//                self.nameLabel.alpha = 0
//                self.superview!.layoutIfNeeded()
//            } completion: { _ in
//                self.nameLabel.hide()
//            }
//        } else {
//            self.nameLabel.hide()
//        }
    }
    
    @objc func onActionButtonTap(_ sender: UIButton?) {
        var article = MainFeedArticle(url: url)
        let vc = ArticleViewController()
        vc.article = article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
}


// -----------------------------------------------------
// ------------------------------------------------
// -------------------------------------------
func BUILD_LOGO_URL(id: String) -> String {
    var _id = id
        switch(_id) {
            case "Dw.Com":
                _id = "DW"
            case "The Economic Times":
                _id = "The%20Economic%20Times"
            case "Barrons":
                _id = "Barron_s"
            case "Firstpost":
                _id = "Firstpost"
                
            default:
                print("Could not find logo for id:", id)
                NOTHING()
        }
        
        var domainParam = ITN_URL()
        domainParam = domainParam.replacingOccurrences(of: ":", with: "%3A")
        domainParam = domainParam.replacingOccurrences(of: "/", with: "%2F")
    
    
        let result = ITN_URL() + "/_next/image?url=" + domainParam + "%2Fnon-verity-favicons%2F" + _id + ".png&w=32&q=75"
        return result
}
