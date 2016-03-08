//
//  DateExtension.swift
//  eBayWeather
//
//  Created by Adnan Aftab on 2/27/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
extension NSDate {
    /**
     * This method will return data at start of today
     * @param void
     * @return date:NSDate (00:00)
     */
    class func todayStartOfDay() -> NSDate {
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        var dateAtStart : NSDate? = nil
        
        cal.rangeOfUnit(.Day, startDate: &dateAtStart , interval: nil, forDate: now)
        let timeZone = NSTimeZone.systemTimeZone()
        
        // Add summer time offset
        let destGMTOffSet = timeZone.secondsFromGMTForDate(dateAtStart!)
        dateAtStart = dateAtStart?.dateByAddingTimeInterval(NSTimeInterval(destGMTOffSet))
        return dateAtStart!
    }

    /**
     * This method will return data at start of the day
     */
    func startOfTheDay() -> NSDate? {
        let cal = NSCalendar.currentCalendar()
        let dateComp = cal.components([.Year, .Month, .Day, .Minute,.Hour,.Second], fromDate: self)
        
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        
        let date = cal .dateFromComponents(dateComp)
        return date
    }
    
    /**
     * Utility method which willr return just hour and mints
     * @param void
     * @return string HH:mm
     */
    func shortTime() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    
    /**
     * Utility method which will return just Day and month
     * @param void
     * @return string dd:MMM
     */
    func dayAndMonth() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MMM"
        return dateFormatter.stringFromDate(self)
    }
}