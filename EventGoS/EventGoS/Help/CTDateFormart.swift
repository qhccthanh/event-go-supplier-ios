//
//  CTDateFormart.swift
//  QuanLyChiTieu
//
//  Created by Quach Ha Chan Thanh on 12/25/16.
//  Copyright © 2016 Quach Ha Chan Thanh. All rights reserved.
//

import Foundation

public enum SortTimeType: Int {
    case day = 0
    case month
    case week
    case quater
    case year
    case all
}

class CTDateFormart: NSObject {
    
    let date: Date
    let calendar: DateComponents!
    
    let day: Int
    let month: Int
    let year: Int
    let weekly: Int
    let weekOfYear: Int
    let quarter: Int
    let hour: Int
    let minute: Int
    let second: Int
    
    static var weekStringDictionary: Dictionary<Int,String>  {
        get {
            var dict = Dictionary<Int,String>()
            dict[2] = "hai"
            dict[3] = "ba"
            dict[4] = "tư"
            dict[5] = "năm"
            dict[6] = "sáu"
            dict[7] = "bảy"
            dict[1] = "Chủ nhật"
            
            return dict
        }
    }
    
    var weaklyString: String {
        get {
            return "\(weekly == 1 ? "" : "Thứ ")\(CTDateFormart.weekStringDictionary[weekly]!)"
        }
    }
    
    var weeklyShortString: String {
        get {
            if weekly == 1 {
                return "C.Nhật".uppercased()
            }
            return "\(CTDateFormart.weekStringDictionary[weekly]!)".uppercased()
        }
    }
    
    required public init(date: Date = Date()) {
        
        self.date = date
        calendar = Calendar.autoupdatingCurrent.dateComponents([.day,.weekday,.weekOfYear,.month,.year,.quarter,.hour,.minute,.second], from: date)
        
        day = calendar.day!
        month = calendar.month!
        year = calendar.year!
        weekOfYear = calendar.weekOfYear!
        weekly = calendar.weekday!
        quarter = calendar.quarter!
        hour = calendar.hour!
        minute = calendar.minute!
        second = calendar.second!
        
        super.init()
    }
    
    func toString() -> String {
        let weeklyStr = weaklyString
        let newStr = "\(weeklyStr), \(day) tháng \(month) năm \(year)"
        
        return newStr
    }
    
    func fullString() -> String {
        return "Lúc \(hour):\(minute):\(second) \(toString())"
    }
    
    func daymonyear() -> String {
        return  "\(day)-\(month)-\(year)"
    }
    
    func isSame(_ otherDate: Date, type: SortTimeType) -> Bool {
        
        let ctDate = CTDateFormart(date: otherDate)
        
        switch type {
        case .day:
            return ctDate.day == day && ctDate.month == month && ctDate.year == year
        case .month:
            return ctDate.month == month && ctDate.year == year
        case .year:
            return ctDate.year == year
        case .quater:
            return ctDate.quarter == quarter && ctDate.year == year
        case .week:
            return ctDate.weekOfYear == weekOfYear
        case .all:
            return false
        }
        
    }
    
    func toMonthString() -> String {
        
        if self.isSame(Date(), type: .month) {
            return "Tháng này"
        } else if self.isSame(Date().getPreviousMonth(), type: .month) {
            return "Tháng trước"
        } else if self.isSame(Date().getNextMonth(), type: .month) {
            return "Tháng sau"
        }
        
        return "\(self.month)/\(self.year)"
    }
    
    func toWeekString() -> String {
        
        let currentDate = Date()
        let startWeek = self.date.startOfWeek().toCTDateFormat()
        let endWeek = self.date.endOfWeek().toCTDateFormat()
        
        if self.date.between(startDate: currentDate.startOfWeek(), endDate: currentDate.endOfWeek()) {
            return "Tuần này"
        } else if self.date.between(startDate: currentDate.getPreviousWeek().startOfWeek(), endDate: currentDate.getPreviousWeek().endOfWeek() ) {
            return "Tuần trước"
        } else if self.date.between(startDate: currentDate.getNextWeek().startOfWeek(), endDate: currentDate.getNextWeek().endOfWeek() ) {
            return "Tuần sau"
        }
        
        return "\(startWeek.day)/\(startWeek.month)-\(endWeek.day)/\(endWeek.month)"
    }
    
    func toDayString() -> String {
        
        let currentDate = CTDateFormart()
        
        if self.isSame(currentDate.date, type: .day) {
            return "Hôm nay"
        } else if self.isSame(currentDate.date.getPreviousDay(), type: .day) {
            return "Hôm qua"
        } else if self.isSame(currentDate.date.getNextDay(), type: .day) {
            return "Ngày mai"
        }
        
        return "\(self.day)/\(self.month)/\(self.year)"
    }
    
    func transactionDateTitleTimeString() -> String {
        
        var result = ""
        
        let currentDate = CTDateFormart()
        
        if self.isSame(currentDate.date, type: .day) {
            result =  "Hôm nay"
        } else if self.isSame(currentDate.date.getPreviousDay(), type: .day) {
            result =  "Hôm qua"
        } else if self.isSame(currentDate.date.getNextDay(), type: .day) {
            result =  "Ngày mai"
        }
        if result == "" {
            result = weaklyString
        }
        
        result = "thg \(month), \(year) - \(result)"
        
        return result
    }
    
}

extension Date {
    
    func between(startDate: Date, endDate: Date) -> Bool {
        return (self.timeIntervalSince1970 > startDate.timeIntervalSince1970 && self.timeIntervalSince1970 < endDate.timeIntervalSince1970)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        return Calendar.current.startOfDay(for: self).addingTimeInterval(ONCE_DAY_INTERVAL - 1)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        let dslTimeOffset = NSTimeZone.system.daylightSavingTimeOffset(for: date)
        return date.addingTimeInterval(dslTimeOffset)
    }
    
    func endOfWeek() -> Date {
        return Calendar.current.date(byAdding: .second, value: 604799, to: self.startOfWeek())!
    }
    
    func getNextMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    func getPreviousMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    func getNextWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!
    }
    
    func getPreviousWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    func getNextDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func getPreviousDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func toCTDateFormat() -> CTDateFormart {
        return CTDateFormart(date: self)
    }
    
    func toString() -> String {
        return self.toCTDateFormat().toDayString()
    }
}



