//
//  iPhoneHeaderLineCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/04/2024.
//

import UIKit

class iPhoneHeaderLineCell_v3: UITableViewCell {

    static let identifier = "iPhoneHeaderLineCell_v3"

    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildContent() {
        let lineView = UIView()
        self.contentView.addSubview(lineView)
        lineView.activateConstraints([
            lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        ADD_HDASHES(to: lineView)
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    func getHeight() -> CGFloat {
        return 20
    }

}
