//
//  SignUpView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/02/2023.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    func SignUpViewOnTabTap()
}


class SignUpView: UIView {

    weak var delegate: SignUpViewDelegate?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!

    // MARK: - Init
    func buildInto(view containerView: UIView) {
        containerView.addSubview(self)
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        self.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink

        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow

        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = .green
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .yellow
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -26),
            //self.VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
        
        self.buildForm()
        self.refreshDisplayMode()
    }
    
    private func buildForm() {
        let HLine = UIView()
        HLine.backgroundColor = .red
        self.VStack.addArrangedSubview(HLine)
        HLine.activateConstraints([
            HLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        HLine.tag = 100

        let hStack = HSTACK(into: VStack)
        hStack.backgroundColor = .blue
        hStack.activateConstraints([
            hStack.heightAnchor.constraint(equalToConstant: 67)
        ])
        hStack.tag = 101

        let tab1Label = UILabel()
        tab1Label.text = "SIGN IN"
        tab1Label.font = ROBOTO_BOLD(14)
        tab1Label.textAlignment = .center
        tab1Label.textColor = UIColor(hex: 0x93A0B4)
        hStack.addArrangedSubview(tab1Label)
        tab1Label.activateConstraints([
            tab1Label.widthAnchor.constraint(equalToConstant: (SCREEN_SIZE().width/2)-1)
        ])
        
        let tabButton = UIButton(type: .custom)
        tabButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        hStack.addSubview(tabButton)
        tabButton.activateConstraints([
            tabButton.leadingAnchor.constraint(equalTo: tab1Label.leadingAnchor),
            tabButton.trailingAnchor.constraint(equalTo: tab1Label.trailingAnchor),
            tabButton.topAnchor.constraint(equalTo: tab1Label.topAnchor),
            tabButton.bottomAnchor.constraint(equalTo: tab1Label.bottomAnchor)
        ])
        tabButton.addTarget(self, action: #selector(tabButtonOnTap(_:)), for: .touchUpInside)

        let vLine = UIView()
        vLine.backgroundColor = .red
        hStack.addArrangedSubview(vLine)
        vLine.activateConstraints([
            vLine.widthAnchor.constraint(equalToConstant: 1)
        ])
        vLine.tag = 100

        let tab2Label = UILabel()
        tab2Label.text = "SIGN UP"
        tab2Label.font = ROBOTO_BOLD(14)
        tab2Label.textAlignment = .center
        tab2Label.textColor = UIColor(hex: 0xFF643C)
        hStack.addArrangedSubview(tab2Label)

        let HLine2 = UIView()
        HLine2.backgroundColor = .red
        VStack.addSubview(HLine2)
        HLine2.activateConstraints([
            HLine2.leadingAnchor.constraint(equalTo: VStack.leadingAnchor, constant: 0),
            HLine2.topAnchor.constraint(equalTo: VStack.topAnchor, constant: 67),
            HLine2.heightAnchor.constraint(equalToConstant: 1),
            HLine2.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width/2)
        ])
        HLine2.tag = 100
        ADD_SPACER(to: self.VStack, height: 26)

        let HStack_form = HSTACK(into: self.VStack)
        ADD_SPACER(to: HStack_form, width: 16)
        let VStack_form = VSTACK(into: HStack_form)
        //VStack_form.backgroundColor = .green
        ADD_SPACER(to: HStack_form, width: 16)

        let titleLabel = UILabel()
        titleLabel.text = "Sign up"
        titleLabel.font = MERRIWEATHER_BOLD(18)
        VStack_form.addArrangedSubview(titleLabel)
        ADD_SPACER(to: VStack_form, height: 20)

        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = ROBOTO(14)
        VStack_form.addArrangedSubview(emailLabel)
        
        ADD_SPACER(to: VStack_form, height: 16)
    }

}

// MARK: - Events
extension SignUpView {
    @objc func tabButtonOnTap(_ sender: UIButton) {
        self.delegate?.SignUpViewOnTabTap()
    }
}

// MARK: - UI
extension SignUpView {

    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.scrollView.backgroundColor = self.backgroundColor
        self.contentView.backgroundColor = self.backgroundColor

        for v in self.VStack.arrangedSubviews {
            self.setColorToView(v)
        }

        for v in self.VStack.subviews {
            self.setColorToView(v)
        }
    }
    
    // ------------
    func setColorToView(_ view: UIView) {
        switch(view.tag) {
            case 100:
                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : UIColor(hex: 0xE2E3E3)

            case 101:
                view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : .white

            default:
                NOTHING()
        }

        if(view is UIStackView) {
            for v in (view as! UIStackView).arrangedSubviews {
                self.setColorToView(v)
            }
        }
    }
}
