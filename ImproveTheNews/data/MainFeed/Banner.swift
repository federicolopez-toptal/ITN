//
//  Banner.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 25/09/2022.
//

import Foundation

class Banner {

    static let DEFAULT_TITLE = "*** BANNER ***"

    static var imageHeight: CGFloat? = nil

    var headerText: String
    var mainText: String
    var colorScheme: Int
    var type: String
    var code: String
    var imgSize: Int
    var imgUrl: String
    var url: String
    
    init (_ json: [Any]) {
        self.headerText = json[1] as! String
        self.mainText = json[2] as! String
        self.colorScheme = json[3] as! Int
        self.type = json[4] as! String
        self.code = json[5] as! String
        self.imgSize = json[6] as! Int
        self.imgUrl = json[7] as! String
        self.url = json[8] as! String
    }
    
    func isNewsLetter() -> Bool {
        var result = false
        if(self.code.lowercased() == "nl"){ result = true }
        
        return result
    }
    
    func isPodcast() -> Bool {
        var result = false
        if(self.code.lowercased() == "pc"){ result = true }
        
        return result
    }
    
    func trace() {
        print("BANNER")
        print(self.headerText, self.mainText, self.colorScheme, self.type, self.code, self.imgSize, self.imgUrl, self.url)
        print("--------------------------")
    }
    
}
