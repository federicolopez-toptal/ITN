//
//  StoryEntities.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 11/01/2023.
//

import Foundation

struct Fact {

    var title: String = ""           // text
    var source_title: String = ""    // source name
    var source_url: String = ""      // source url
    
    init(_ json: [String: Any]) {
        if let _title = json["title"] as? String {
            self.title = _title
        }
        
        if let _sourceArray = json["source"] as? [[String: Any]] {
            if(_sourceArray.count>0) {
                let first = _sourceArray[0]
                
                if let sTitle = first["title"] as? String {
                    self.source_title = sTitle
                }
                if let sUrl = first["url"] as? String {
                    self.source_url = sUrl
                }
            }
        }
    }
}
