//
//  iPadControversyCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/04/2024.
//

import UIKit

class iPadControversyCell_v3: UITableViewCell {

    static let identifier = "iPadControversyCell_v3"
    let M: CGFloat = CSS.shared.iPhoneSide_padding
    
    var subViews = [ControversyCellView]()
    var view1_heightConstraint: NSLayoutConstraint!
    var view2_heightConstraint: NSLayoutConstraint!
    
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

        let W = (SCREEN_SIZE_iPadSideTab().width - (M*3))/2
    
        let view1 = ControversyCellView(width: W)
        self.contentView.addSubview(view1)
        view1.activateConstraints([
            view1.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: M),
            view1.widthAnchor.constraint(equalToConstant: W)
        ])
        self.view1_heightConstraint = view1.heightAnchor.constraint(equalToConstant: 1)
        self.view1_heightConstraint.isActive = true
        self.subViews.append(view1)
        
        let view2 = ControversyCellView(width: W)
        self.contentView.addSubview(view2)
        view2.activateConstraints([
            view2.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -M),
            view2.widthAnchor.constraint(equalToConstant: W)
        ])
        self.view2_heightConstraint = view2.heightAnchor.constraint(equalToConstant: 1)
        self.view2_heightConstraint.isActive = true
        self.subViews.append(view2)
        
        self.refreshDisplayMode()
    }
    
    func populate(item1: ControversyListItem, item2: ControversyListItem?) {
        let view1 = self.subViews[0]
        view1.populate(with: item1)
        view1_heightConstraint.constant = view1.calculateHeight()
        
        let view2 = self.subViews[1]
        if let _item2 = item2 {
            view2.populate(with: _item2)
            view2_heightConstraint.constant = view2.calculateHeight()
            view2.show()
        } else {
            view2.hide()
        }
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    func calculateHeight() -> CGFloat {
        let view1 = self.subViews[0]
        let H1 = view1.calculateHeight()
        
        let view2 = self.subViews[1]
        let H2 = view2.calculateHeight()
        
        if(H1>H2) {
            return H1
        } else {
            return H2
        }
    }
    
}
