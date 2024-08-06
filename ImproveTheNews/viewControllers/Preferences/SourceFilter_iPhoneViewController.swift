//
//  SourceFilter_iPhoneViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/08/2024.
//

import Foundation
import SDWebImage

class SourceFilter_iPhoneViewController: BaseViewController {

    var sourcesLoaded = false
    var dataProvider = [SourceIcon]()

    let titleLabel = UILabel()
    let filterText = FilterTextView()
    let list = UITableView()
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            Sources.shared.checkIfLoaded { _ in // load sources (if needed)
                self.sourcesLoaded = true
                MAIN_THREAD {
                    self.searchForText("")
                }
            }
        
            self.didLayout = true
            self.buildContent()
        }
    }
    
    // MARK: - misc
    func buildContent() {
        let topSpace: CGFloat = Y_TOP_NOTCH_FIX(54)
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
    
        let closeImage = UIImage(named: DisplayMode.imageName("SourcesClose"))
        let closeIcon = UIImageView(image: closeImage)
        self.view.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace+4)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = self.view.backgroundColor
        self.view.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    
        self.view.addSubview(self.titleLabel)
        self.titleLabel.font = DM_SERIF_DISPLAY_fixed(24) //MERRIWEATHER_BOLD(24)
        self.titleLabel.text = "Source filter"
        self.titleLabel.textAlignment = .center
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: -4)
        ])
    
        self.filterText.delegate = self
        self.filterText.buildInto(viewController: self)
        self.filterText.activateConstraints([
            self.filterText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
            self.filterText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17),
            self.filterText.heightAnchor.constraint(equalToConstant: 48),
            self.filterText.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16)
        ])
        self.filterText.layer.cornerRadius = 48/2
    
        let moneyIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("money")))
        self.view.addSubview(moneyIcon)
        moneyIcon.activateConstraints([
            moneyIcon.widthAnchor.constraint(equalToConstant: 24),
            moneyIcon.heightAnchor.constraint(equalToConstant: 24),
            moneyIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            moneyIcon.topAnchor.constraint(equalTo: self.filterText.bottomAnchor, constant: 14)
        ])
    
        let paywallLabel = UILabel()
        paywallLabel.text = "Indicates a paywall."
        paywallLabel.textColor = DARK_MODE() ? UIColor(hex: 0xbbbdc0) : UIColor(hex: 0x19191c)
        paywallLabel.font = AILERON(16)
        self.view.addSubview(paywallLabel)
        paywallLabel.activateConstraints([
            paywallLabel.leadingAnchor.constraint(equalTo: moneyIcon.trailingAnchor, constant: 8),
            paywallLabel.centerYAnchor.constraint(equalTo: moneyIcon.centerYAnchor)
        ])
        
        var bottomSpace: CGFloat = 0
        if let _extraSpace = SAFE_AREA()?.bottom {
            bottomSpace += _extraSpace
        }
        
        self.view.addSubview(self.list)
        self.list.backgroundColor = .red //self.view.backgroundColor
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.topAnchor.constraint(equalTo: moneyIcon.bottomAnchor, constant: 27),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomSpace)
        ])
        self.initList()
        
        self.refreshDisplayMode()
        if(self.sourcesLoaded){ self.searchForText("") }
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.list.backgroundColor = self.view.backgroundColor
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

extension SourceFilter_iPhoneViewController: FilterTextViewDelegate {
    
    func FilterTextView_onTextChange(sender: FilterTextView, text: String) {
        self.searchForText(text)
    }

    func searchForText(_ text: String) {
        if(text.isEmpty) {
            self.dataProvider = Sources.shared.all!.filter { obj in true }
        } else {
            self.dataProvider = Sources.shared.all!.filter { obj in
                obj.name.lowercased().contains(text.lowercased())
            }
        }
        //---------------------
        
        self.list.reloadData()
    }

}

extension SourceFilter_iPhoneViewController: UITableViewDelegate, UITableViewDataSource {

    func initList() {
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        
        self.list.delegate = self
        self.list.dataSource = self
        
        self.list.register(SourceFilterCell.self, forCellReuseIdentifier: SourceFilterCell.identifier)
    }
    
    // UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SourceFilterCell.heigth
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.list.dequeueReusableCell(withIdentifier: SourceFilterCell.identifier) as! SourceFilterCell
        cell.populate(with: self.dataProvider[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = self.dataProvider[indexPath.row]
//        self.tapOnItem(item)

        let i = indexPath.row

        self.updatePrefSourceFilters(code: self.dataProvider[i].code)        
        self.dataProvider[i].state = !self.dataProvider[i].state
        Sources.shared.updateSourceState(self.dataProvider[i].code!, self.dataProvider[i].state)
        
        let cell = self.tableView(self.list, cellForRowAt: indexPath) as! SourceFilterCell
        cell.check.setState(self.dataProvider[i].state)
        self.list.reloadData()
    }
    
    // ---------------------------------------
    func updatePrefSourceFilters(code: String?) {
        if(code==nil){ return }
        
        var filters: [String] = READ(LocalKeys.preferences.sourceFilters)?.components(separatedBy: ",") ?? []
        if let _index = filters.firstIndex(of: code!) {
            filters.remove(at: _index)
        } else {
            filters.append(code!)
        }
        
        var value = filters.joined(separator: ",")
        
        WRITE(LocalKeys.preferences.sourceFilters, value: value)
        print("Writing", value)
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeedOnShow)
    }
    
}
