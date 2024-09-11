//
//  iPhoneLineSeparatorCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/09/2024.
//

import UIKit

class iPhoneLineSeparatorCell_v3: UITableViewCell {

    static let identifier = "iPhoneLineSeparatorCell_v3"

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.refreshDisplayMode()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLineWith(type: Int) {
        self.refreshDisplayMode()
        REMOVE_ALL_SUBVIEWS(from: self.contentView)
    
        if(type==1) {
            let lineView = UIView()
            self.contentView.addSubview(lineView)
            lineView.activateConstraints([
                lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                lineView.heightAnchor.constraint(equalToConstant: 2)
            ])
            ADD_HDASHES(to: lineView)
        } else if(type==2) {
            var posX: CGFloat = 16
            let width: CGFloat = (SCREEN_SIZE().width - (16*3))/2
        
            for _ in 1...2 {
                let lineView = UIView()
                self.contentView.addSubview(lineView)
                lineView.activateConstraints([
                    lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: posX),
                    lineView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                    lineView.heightAnchor.constraint(equalToConstant: 2),
                    lineView.widthAnchor.constraint(equalToConstant: width),
                ])
                ADD_HDASHES(to: lineView)
                
                posX += width + 16
            }
        }
    }
    
    func refreshDisplayMode(addLine: Bool = true) {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        //self.contentView.backgroundColor = .red.withAlphaComponent(0.1)
    }
    
    static func getHeight() -> CGFloat {
        return 15
    }

}
