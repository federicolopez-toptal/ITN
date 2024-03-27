//
//  ClaimCellView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/03/2024.
//

import UIKit

protocol ClaimCellViewDelegate: AnyObject {
    func claimCellViewOnHeightChanged(sender: ClaimCellView)
}


class ClaimCellView: UIView {

    weak var delegate: ClaimCellViewDelegate?

    private var WIDTH: CGFloat = 1
    var isOpen = false
    var mainHeightConstraint: NSLayoutConstraint?
    
    let titleLabel = UILabel()
    
    
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        
        self.buildContent()
    }
    
    private func buildContent() {
        self.backgroundColor = .blue
        
        let line = UIView()
        line.backgroundColor = .green
        self.addSubview(line)
        line.activateConstraints([
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.topAnchor.constraint(equalTo: self.topAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(18)
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 0
        self.titleLabel.backgroundColor = .orange
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        ])
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .green.withAlphaComponent(0.5)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        self.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            button.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        button.addTarget(self, action: #selector(buttonOnTap(_:)), for: .touchUpInside)
        
        
        self.mainHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        self.mainHeightConstraint?.isActive = true
    }
    @objc func buttonOnTap(_ sender: UIButton?) {
        if(!self.isOpen) {
            // Abro
            self.isOpen = true
            
            // Muestro contenido extra
            self.mainHeightConstraint?.constant = self.calculateHeight()
            self.layoutIfNeeded() // visual update
            
            self.delegate?.claimCellViewOnHeightChanged(sender: self)
        } else {
            // Cierro
            self.isOpen = false
            
            // Oculto contenido extra
            self.mainHeightConstraint?.constant = self.calculateHeight()
            self.layoutIfNeeded() // visual update
            
            self.delegate?.claimCellViewOnHeightChanged(sender: self)
            
        }
    }
    
    func calculateHeight() -> CGFloat {
        let W: CGFloat = self.WIDTH - 10 - 10
        let H: CGFloat = 10 + self.titleLabel.calculateHeightFor(width: W) + 10 + 50 + 10
        var extraH: CGFloat = 0
        if(self.isOpen) {
            extraH = 100
        }
        
        return H + extraH
    }
    
    func populate(with claim: Claim) {
        self.titleLabel.text = claim.title
        self.mainHeightConstraint?.constant = self.calculateHeight()
    }
    
}

