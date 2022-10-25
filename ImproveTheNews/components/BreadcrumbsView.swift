//
//  BreadcrumbsView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/10/2022.
//

import UIKit


protocol BreadcrumbsViewDelegate: AnyObject {
    func breadcrumbOnTap(sender: BreadcrumbsView)
}

class BreadcrumbsView: UIView {

    weak var delegate: BreadcrumbsViewDelegate?
    private weak var viewController: UIViewController?
    
    let breadcrumbLabel = UILabel()
    let bottomLine = UIView()
    

    // MARK: - Build component
    func buildInto(viewController: UIViewController) {
        self.viewController = viewController
        let container = viewController.view!
        
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: NavBarView.HEIGHT() + TopicSelectorView.HEIGHT()),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: BreadcrumbsView.HEIGHT()),
        ])
        self.refreshDisplayMode()
        
        // ---------------
        let backIcon = UIImageView(image: UIImage(named: "breadcrumbBack"))
        backIcon.backgroundColor = .clear //.green
        self.addSubview(backIcon)
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            backIcon.widthAnchor.constraint(equalToConstant: 16),
            backIcon.heightAnchor.constraint(equalToConstant: 16),
            backIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -1)
        ])
            
        self.breadcrumbLabel.font = ROBOTO(13)
        self.breadcrumbLabel.text = self.getPrevTopicName()
        self.breadcrumbLabel.textColor = UIColor(hex: 0x93A0B4)
        self.addSubview(self.breadcrumbLabel)
        self.breadcrumbLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.breadcrumbLabel.leadingAnchor.constraint(equalTo: backIcon.trailingAnchor, constant: 4),
            self.breadcrumbLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        let areaButton = UIButton(type: .system)
        areaButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(areaButton)
        areaButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            areaButton.leadingAnchor.constraint(equalTo: backIcon.leadingAnchor, constant: -5),
            areaButton.trailingAnchor.constraint(equalTo: self.breadcrumbLabel.trailingAnchor, constant: 15),
            areaButton.topAnchor.constraint(equalTo: self.breadcrumbLabel.topAnchor, constant: -5),
            areaButton.bottomAnchor.constraint(equalTo: self.breadcrumbLabel.bottomAnchor, constant: 5)
        ])
        areaButton.addTarget(self, action: #selector(breadcrumbOnTap(_:)), for: .touchUpInside)

        self.bottomLine.backgroundColor = .red
        self.addSubview(self.bottomLine)
        self.bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomLine.heightAnchor.constraint(equalToConstant: 1),
            self.bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        self.refreshDisplayMode()
    }
    
    // MARK: - Tap
    @objc func breadcrumbOnTap(_ sender: UIButton) {
        self.delegate?.breadcrumbOnTap(sender: self)
    }
    
    // MARK: - Display mode
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }

}

extension BreadcrumbsView {

    static func HEIGHT() -> CGFloat {
        return 44
    }
    
    func getPrevTopicName() -> String {
        var result = ""
    
        if let _nav = CustomNavController.shared {
            let count = _nav.viewControllers.count
            if(count>1) {
                if let _prev = _nav.viewControllers[count-2] as? MainFeedViewController {
                    result = _prev.data.getMainTopicName()
                }
            }
        }
        
        return result
    }

}
