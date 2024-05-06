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
        self.addLine()
        self.refreshDisplayMode(addLine: false)
    }
    
    func addLine() {
        REMOVE_ALL_SUBVIEWS(from: self.contentView)
    
        let lineView = UIView()
        self.contentView.addSubview(lineView)
        lineView.activateConstraints([
            lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        ADD_HDASHES(to: lineView)
    }
    
    func refreshDisplayMode(addLine: Bool = true) {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        if(addLine){ self.addLine() }
    }
    
    static func getHeight() -> CGFloat {
        return 20
    }

}
