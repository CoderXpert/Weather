//
//  Forecast.swift
//  Weather
//
//  Created by Adnan Aftab on 3/7/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

struct Forecast : ForecastType {
    var location:String
    var time: String
    var date : NSDate
    var iconText: String
    var temperature: Double
    var maxTemperature : Double
    var minTemperature : Double
    var weatherConditionText : String 
}
/**
 * Here I am conditionaly extending Array, method in this extension will only be avaialble for [ForecastType]
 */
extension Array where Element : ForecastType {
    
    /**
     * This extension method will return forecast item for today only
     * @param void
     * @return array of forecast [Forecast]
     */
    
    func forecastForToday() -> [Element]{
        
        let todayStartOfTheDay = NSDate.todayStartOfDay()
        let dayInterVal = NSTimeInterval(24 * 60 * 60)
        let todayEndOfTheDay = todayStartOfTheDay.dateByAddingTimeInterval(dayInterVal)
        
        return filter{ ($0.date.compare(todayStartOfTheDay) != .OrderedAscending && $0.date.compare(todayEndOfTheDay) != .OrderedDescending)}
    }
    /**
     * This method will return all future forecast excluding today
     * @param void, will work on self
     * @return array of forecast item
     */
    
    func forecastExcludingToday() -> [Element] {
        let todayStartOfTheDay = NSDate.todayStartOfDay()
        let dayInterVal = NSTimeInterval(24 * 60 * 60)
        let todayEndOfTheDay = todayStartOfTheDay.dateByAddingTimeInterval(dayInterVal)
        
        return filter{ $0.date.compare(todayEndOfTheDay) == .OrderedDescending }
    }
}