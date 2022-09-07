//
//  MenuViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import UIKit

class MenuViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPink
        
        var text = "go to Bright mode"
        if(DisplayMode.current() == .bright){ text = "go to Dark mode" }
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .yellow
        button.setTitleColor(.blue, for: .normal)
        button.setTitle(text, for: .normal)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            button.heightAnchor.constraint(equalToConstant: 25),
            button.widthAnchor.constraint(equalToConstant: 200),
        ])
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
    }
    
    @objc func onButtonTap(_ sender: UIButton) {
        self.changeDisplayMode()
    }
    
    
    
    
    
    private func dismissMe() {
        CustomNavController.shared.dismissMenu()
    }
    
}

// MARK: - Menu action(s)
extension MenuViewController {
    
    func changeDisplayMode() {
        var changeTo: DisplayMode = .bright
        if(DisplayMode.current() == .bright) {
            changeTo = .dark
        }

        var newValue = "0"
        if(changeTo == .bright){ newValue = "1" }
        WRITE(LocalKeys.preferences.displayMode, value: newValue)

        CustomNavController.shared.refreshDisplayMode()
        //NOTIFY(Notification_reloadMainFeed)
        self.dismissMe()
    }
    
}
