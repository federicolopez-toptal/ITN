//
//  SourceIcons.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import Foundation
import UIKit


func ADD_SOURCE_ICONS(data sources: [String], to container: UIStackView, limit: Int = 6) {
    
    //container.backgroundColor = .clear //.yellow
    container.axis = .horizontal
    container.spacing = 5
    container.hide()
    REMOVE_ALL_SUBVIEWS(from: container)
    
    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        container.heightAnchor.constraint(equalToConstant: 18)
    ])
    
    var count = 0
    for S in sources {
        if let _icon = Sources.shared.search(identifier: S), _icon.url != nil {
            let iconContainer = UIView()
            iconContainer.backgroundColor = .clear //.blue
            container.addArrangedSubview(iconContainer)
            NSLayoutConstraint.activate([
                iconContainer.widthAnchor.constraint(equalToConstant: 18)
            ])
            
            let newIcon = UIImageView()
            newIcon.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
            iconContainer.addSubview(newIcon)
            newIcon.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newIcon.widthAnchor.constraint(equalToConstant: 18),
                newIcon.heightAnchor.constraint(equalToConstant: 18),
                newIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            
            if(!_icon.url!.contains(".svg")) {
                newIcon.sd_setImage(with: URL(string: _icon.url!))
            } else {
                newIcon.image = UIImage(named: _icon.identifier + ".png")
            }
            
            count += 1
            if(count==limit){ break }
        }
    }
        
    if(container.arrangedSubviews.count>0) {
        ADD_SPACER(to: container, width: 5)
        container.show()
    }
}
