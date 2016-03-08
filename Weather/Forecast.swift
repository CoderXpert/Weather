//
//  Forecast.swift
//  Weather
//
//  Created by Adnan Aftab on 3/7/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

struct Forecast : ForecastType {
    var country:String
    var location:String
    var date : NSDate
    var iconText: String
    var temperature: Double
    var maxTemperature : Double
    var minTemperature : Double
    var weatherConditionText : String
    
    var localizedTemperatureString : String {
        get{
            return localizedTemperatureString(temperature)
        }
    }
    var localizedMaxTemperatureString : String {
        get{
            return localizedTemperatureString(maxTemperature)
        }
    }
    var localizedMinTemeratureString : String {
        get{
            return localizedTemperatureString(minTemperature)
        }
    }
    /**
     * This funcation will convert Kelvin temperature to Fahrenheit or Celsius
     * depending on current country
     * @param kelvinTemperture:Double to convert
     * @return localizedString (either fahrenheit or Celsius)
     */
    private func localizedTemperatureString(kelvinTemp:Double) -> String{
        var degrees : String
        if country == "US" {
            // Fahrenheit (K - 273.15)* 1.8000 + 32.00
            var val = round(((kelvinTemp - 273.15) * 1.8) + 32)
            if abs(val) == 0 {
                val = 0
            }
            degrees = String(format: "%.0f",val) + "\u{f045}"
        } else {
            //  Celsius
            var val = round(kelvinTemp - 273.15)
            if abs(val) == 0 {
                val = 0
            }
            degrees = String(format: "%0.f",val) + "\u{f03c}"
        }
        return degrees
    }
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