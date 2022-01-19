//
//  Helper.swift
//  TryCustomDatePicker
//
//  Created by dong on 2022/1/18.
//

import Foundation
import UIKit

extension UIColor {
    static func hexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        var str = ""
        if hexString.lowercased().hasPrefix("0x") {
            str = hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.lowercased().hasPrefix("#") {
            str = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            str = hexString
        }

        let length = str.count
        // 如果不是 RGB RGBA RRGGBB RRGGBBAA 结构
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return .clear
        }

        // 将 RGB RGBA 转换为 RRGGBB RRGGBBAA 结构
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }

        guard let hexValue = Int(str, radix: 16) else {
            return .clear
        }

        var red = 0
        var green = 0
        var blue = 0

        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xFF
            green = (hexValue >> 8) & 0xFF
            blue = hexValue & 0xFF
        } else {
            red = (hexValue >> 20) & 0xFF
            green = (hexValue >> 16) & 0xFF
            blue = (hexValue >> 8) & 0xFF
        }
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: CGFloat(alpha))
    }

    // 返回随机颜色
    open class var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension Date {
    func toString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fm = DateFormatter()
        fm.dateFormat = dateFormat
        return fm.string(from: self)
    }

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp: Int {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp: Int {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let millisecond = Int(round(timeInterval * 1000))
        return millisecond
    }

    static func dateStringToDate(_ dataStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dataStr)
        return date!
    }
}
