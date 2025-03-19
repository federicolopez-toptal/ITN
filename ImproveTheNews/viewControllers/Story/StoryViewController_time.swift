//
//  StoryViewController_time.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/03/2025.
//
import Foundation
import UIKit


extension StoryViewController {
    
    func timeForStoryMetaData(with time: String) -> String {
        return FIX_TIME(time).uppercased()        
    }
    
// ---------------------------------------------
    func makeTimeStringWith(num: Int, typeSingular: String, typePlural: String) -> String {
        let result = String(num) + " " + (num==1 ? typeSingular : typePlural) + " ago"
        return result.uppercased()
    }
    
    func hourToDate(hours: Int) -> Date {
        let H: TimeInterval = 60 * 60
        let _hours: TimeInterval = Double(hours) * H
        let result = Date() - _hours
        
        return result
    }
    
    func timeForImageCredit(with time: String) -> String {
        //https://improvethenews.atlassian.net/browse/ITN-4151
            // Less than a day: no conversion
            
    
        //print("original:", time) // 1 hours ago
    
        let parts = time.components(separatedBy: " ")
        if let _strNum = parts.first, let _num = Int(_strNum) {
            let _type = parts[1]
            
            var result = ""
            switch(_type.lowercased()) {
                case "minute", "minutes":
                    result = self.makeTimeStringWith(num: _num, typeSingular: "minute", typePlural: "minutes")
                    
                case "hour", "hours":
                    if(_num>23) {
                        let date = self.hourToDate(hours: _num)
                        let formatter = DateFormatter()
                        formatter.calendar = Calendar(identifier: .gregorian)
                        
                        let days = _num/24
                        if(days<29) {
                            formatter.dateFormat = "MMM dd"
                        } else {
                            formatter.dateFormat = "MMM yyyy"
                        }
                           
                        result = formatter.string(from: date).uppercased()
                    
//                        let days = _num/24
//                        if(days>29) {
//                            let months = days/30
//                            if(months>364) {
//                                let years = months/12
//                                result = self.makeTimeStringWith(num: years, typeSingular: "year", typePlural: "years")
//                                
//                            } else {
//                                result = self.makeTimeStringWith(num: months, typeSingular: "month", typePlural: "months")
//                            }
//                            
//                        } else {
//                            result = self.makeTimeStringWith(num: days, typeSingular: "day", typePlural: "days")
//                        }
//                        
                    } else {
                        result = self.makeTimeStringWith(num: _num, typeSingular: "hour", typePlural: "hours")
                    }
                
                default:
                    NOTHING()
            }
            
            if(result.isEmpty) {
                return time
            } else {
                return result
            }
        } else {
            return time
        }
    }
    
}
