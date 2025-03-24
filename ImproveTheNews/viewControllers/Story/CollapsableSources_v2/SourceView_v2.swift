//
//  SourceView_v2.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 24/03/2025.
//

import Foundation
import UIKit

class SourceView_v2: UIView {

    static let height: CGFloat = 31.0
    private var url: String? = nil

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(source: SourceForGraph, showName: Bool = true) {
        super.init(frame: CGRect.zero)
        self.url = source.url

        let icon = SourceIcon_v2(source: source)
        self.addSubview(icon)
        icon.activateConstraints([
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icon.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        if(showName) {
            let nameLabel = UILabel()
            nameLabel.font = AILERON(14)
            nameLabel.textColor = CSS.shared.displayMode().main_textColor
            nameLabel.text = source.name
            self.addSubview(nameLabel)
            nameLabel.activateConstraints([
                nameLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 6),
                nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
            let openIcon = UIImageView(image: UIImage(named: "openArticleIcon")?.withRenderingMode(.alwaysTemplate))
            self.addSubview(openIcon)
            openIcon.activateConstraints([
                openIcon.widthAnchor.constraint(equalToConstant: 12),
                openIcon.heightAnchor.constraint(equalToConstant: 12),
                openIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 6),
                openIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            openIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x19191C)
            
            self.activateConstraints([
                self.heightAnchor.constraint(equalToConstant: SourceView_v2.height),
                self.widthAnchor.constraint(equalToConstant: icon.size()+6+nameLabel.calculateWidthFor(height: 17.0)+6+12+8),
            ])
            
            let buttonArea = UIButton(type: .custom)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            self.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                buttonArea.topAnchor.constraint(equalTo: self.topAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            buttonArea.addTarget(self, action: #selector(self.sourceOnTap(_:)), for: .touchUpInside)
        } else {
            self.activateConstraints([
                self.heightAnchor.constraint(equalToConstant: SourceView_v2.height),
                self.widthAnchor.constraint(equalToConstant: icon.size()),
            ])
        }
        
        self.backgroundColor = .clear
    }
    
    @objc func sourceOnTap(_ sender: UIButton?) {
        let article = MainFeedArticle(url: self.url!)
        let vc = ArticleViewController()
        vc.article = article
        CustomNavController.shared.pushViewController(vc, animated: true)
    }

}

// ------------------------------------------------------------------------------------
class SourceIcon_v2: UIView {
    
    let imageView = UIImageView()
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let _borderWidth: CGFloat = 2
    
    init(source: SourceForGraph) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: SourceView_v2.height),
            self.heightAnchor.constraint(equalToConstant: SourceView_v2.height)
        ])
        
    // image
        self.addSubview(imageView)
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: SourceView_v2.height),
            imageView.heightAnchor.constraint(equalToConstant: SourceView_v2.height),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        imageView.layer.cornerRadius = SourceView_v2.height/2
        imageView.clipsToBounds = true
        self.loadImage(id: source.id)
        
    // borders
        let borders = UIView()
        borders.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.addSubview(borders)
        borders.activateConstraints([
            borders.widthAnchor.constraint(equalToConstant: self.size()),
            borders.heightAnchor.constraint(equalToConstant: self.size()),
            borders.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            borders.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        borders.layer.cornerRadius = self.size()/2
        self.sendSubviewToBack(borders)
    }
    
    func size() -> CGFloat {
        return SourceView_v2.height+(self._borderWidth*2)
    }
    
    // ---------------------------------------------
    func loadImage(id: String) {
        if let _icon = Sources.shared.search(identifier: id), _icon.url != nil {
            if(!_icon.url!.contains(".svg")) {
                self.imageView.sd_setImage(with: URL(string: _icon.url!)) { (image, error, cacheType, url) in
                    if let _ = error {
                        self.imageView.image = UIImage(named: "LINK64.png")
                    }
                }
            } else {
                self.imageView.image = UIImage(named: _icon.identifier + ".png")
            }
        } else {
            let url = self.buildLogoUrl(id: id)
            
            self.imageView.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
                if let _ = error {
                    self.imageView.image = UIImage(named: "LINK64.png")
                }
            }
        }
    }
    
    func buildLogoUrl(id: String) -> String {
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
}

// ------------------------------------------------------------------------------------
