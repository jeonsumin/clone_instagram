//
//  Extension.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/29.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
}

extension Date {
    /**
     게시글 업로드 몇 시간 전으로 표시
     */
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "초"
        }else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "분"
        }else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "시간"
        }else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "일"
        }else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "주"
        }else {
            quotient = secondsAgo / month
            unit = "달"
        }
        
        return "\(quotient)\(unit) 전"
    }
}
