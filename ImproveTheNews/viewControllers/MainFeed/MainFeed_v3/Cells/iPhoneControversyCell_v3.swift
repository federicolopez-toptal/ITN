//
//  iPhoneControversyCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/04/2024.
//

import UIKit

class iPhoneControversyCell_v3: UITableViewCell {

    static let identifier = "iPhoneControversyCell_v3"
    
    var subViews = [ControversyCellView]()
    var view1_heightConstraint: NSLayoutConstraint!
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.subViews = [ControversyCellView]()

        let view1 = ControversyCellView(width: SCREEN_SIZE().width)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        self.refreshDisplayMode()
    }
    
    func populate(item: ControversyListItem, remark: String? = nil) {
        let view1 = self.subViews[0]
        view1.populate(with: item, remark: remark)
        view1_heightConstraint.constant = view1.calculateHeight()
            
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    func calculateHeight() -> CGFloat {
        let view1 = self.subViews[0]
        return view1.calculateHeight()
    }
    
}
