//
//  VideosViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/10/2024.
//

import Foundation
import UIKit

class VideosViewController: BaseViewController {

    let navBar = NavBarView()
    var iPad_W: CGFloat = -1
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    var containerViewHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Videos")
            self.navBar.addBottomLine()
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        let C = CSS.shared.displayMode().main_bgColor
        self.view.backgroundColor = C
        
        self.view.addSubview(self.scrollView)
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
        ])
        
            let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        self.contentView.backgroundColor = C
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = C
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                constant: 0),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                constant: 0),
            self.VStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        let mainView = UIView()
        mainView.backgroundColor = C
        self.VStack.addArrangedSubview(mainView)
        
         let containerView = UIView()
        mainView.addSubview(containerView)
        containerView.backgroundColor = C
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            containerView.widthAnchor.constraint(equalToConstant: self.W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        containerView.tag = 555
        
        self.containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 3000)
        self.containerViewHeightConstraint!.isActive = true
        mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadContent()
        }
    }

}

// MARK: Data
extension VideosViewController {
    
    func addVideos(_ videos: [VideoStory], total: Int) {
        //REMOVE_ALL_SUBVIEWS(from: self.VStack)
        
        let containerView = self.view.viewWithTag(555)!
        let _W = (self.W() - 16)/2
        
        var col = 1
        var maxH: CGFloat = 0
        var val_y: CGFloat = 0
        for _vidStory in videos {
            let storyView = iPhoneAllNews_vImgCol_v3(width: _W, imgHeight: 97)
//            storyView.article = MainFeedArticle(url: "")
//            storyView.article.isStory = true

            storyView.article = MainFeedArticle(videoStory: _vidStory)
            storyView.populate(videoStory: _vidStory)
            
            let _H = storyView.calculateHeight()-20
            if(_H > maxH) { maxH = _H }
            
            var val_x: CGFloat = 0
            if(col==2) {
                val_x = _W + 16
            }
            
            containerView.addSubview(storyView)
            storyView.activateConstraints([
                storyView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                storyView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                storyView.widthAnchor.constraint(equalToConstant: _W),
                storyView.heightAnchor.constraint(equalToConstant: _H)
            ])
            
            col += 1
            if(col==3) {
                col = 1
                val_y += maxH + 16
                
                maxH = 0
            }
        }
        
        self.containerViewHeightConstraint?.constant = val_y
    }
    
    func loadContent() {
        
        self.showLoading()
        self.loadList() { (error, total, videos) in
            self.hideLoading()
            
            if let _error = error {
                ALERT(vc: self, title: "Server error",
                        message: "Trouble loading Videos,\nplease try again later.", onCompletion: {
                    })
            } else {
                if let _total = total, let _videos = videos {
                    MAIN_THREAD {
                        self.addVideos(_videos, total: _total)
                    }
                }
            }
        }
    }
    
    func loadList(callback: @escaping (Error?, Int?, [VideoStory]?) -> () ) {
        let url = ITN_URL() + "/php/util/get-videos.php"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        print("VIDEO(s) LIST -  URL", url)
        let task = URL_SESSION().dataTask(with: request) { (data, resp, error) in
            if(error as? URLError)?.code == .timedOut {
                print("TIME OUT!!!")
                callback(error, nil, nil
                )
            }
            
            if let _error = error {
                print(_error.localizedDescription)
                callback(error, nil, nil)
            } else {
                if let _json = JSON(fromData: data) {
                    if(_json["totalRecords"] != nil) {
                        var total = -1
                        let strTotal = CHECK(_json["totalRecords"])

                        if(strTotal.isEmpty) {
                            total = CHECK_NUM(_json["totalRecords"])
                        } else if let _total = Int(strTotal) {
                            total = _total
                        }
                        
                        if(total != -1) {
                            if let _data = _json["videos"] as? [[String: Any]] {
                                var videos = [VideoStory]()
                                
                                for D in _data {
                                    let newItem = VideoStory(D)
                                    videos.append(newItem)
                                }
                                
                                callback(nil, total, videos)
                            } else {
                                callback(CustomError.jsonParseError, nil, nil)
                            }
                        } else {
                            callback(CustomError.jsonParseError, nil, nil)
                        }
                    }
                } else {
                    callback(CustomError.jsonParseError, nil, nil)
                }
            }
        }

        task.resume()
    }
}

// MARK: misc
extension VideosViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func W() -> CGFloat {
        let M: CGFloat = 16
        
        if(IPHONE()) {
            return SCREEN_SIZE().width - (M*2)
        } else {
            if(self.iPad_W == -1) {
                var value: CGFloat = 0
                let w = SCREEN_SIZE().width
                let h = SCREEN_SIZE().height
                
                if(w<h){ value = w }
                else{ value = h }
                self.iPad_W = value - IPAD_sideOffset() - 32 //- 74
            }
        
            return self.iPad_W
        }
    }
}

class VideoStory {

    var type: String
    var id: String
    var time: String
    var title: String
    var url: String
    var videoFile: String
    var image: String
    var excerpt: String
    
    init (_ json: [String: Any]) {
        self.type = CHECK(json["type"])
        self.id = CHECK(json["id"])
        self.time = CHECK(json["timestamp"])
        self.title = CHECK(json["title"])
        self.url = CHECK(json["url"])
        self.videoFile = CHECK(json["videofile"])
        self.image = CHECK(json["image"])
        self.excerpt = CHECK(json["excerpt"])
    }
    
}
