//
//  CurrentWeatherForecastViewModel.swift
//  Weather
//
//  Created by Adnan Aftab on 3/8/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
import CoreLocation


class CurrentWeatherForecastViewModel {
    //: Private properties
    private var forecastsItems:[Forecast]?
    private var forecast:Forecast?
    private let locationManager = LocationManager()
    private let forecastClient = ForecastClient()
    private var location : CLLocation?
    
    init() {
        startLocationService()
    }
    // This method will start locationServices and will set delegate method to self
    private func startLocationService() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    private func getCurrentWeatherAndForecastData() {
        guard let loc = location else { return }
        forecastClient.getCurrentWeatherWithLocation(loc) { (forecast, error) in
            guard error == .None else {
                //Post error notification
                return
            }
            guard let fc = forecast else {
                // Post no forecast notification
                return
            }
            self.forecast = fc
            dispatch_async(dispatch_get_main_queue(), {
                 NSNotificationCenter.defaultCenter().postNotificationName(ForecastViewModelNotificaitons.ViewModelGotNewCurrentWeatherData.rawValue, object: .None)
            })
           
        }
        forecastClient.getForecastsWithLocation(loc) { (forecasts, error) in
            guard error == .None else {
                return
            }
            guard let fcs = forecasts else {
                return
            }
            self.forecastsItems = fcs
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(ForecastViewModelNotificaitons.ViewModelGotNewForecastData.rawValue, object: .None)
            })
        }
    }
}
//: ViewModel protocol implementation
extension CurrentWeatherForecastViewModel : CurrentWeatherForecastViewModelType {
    //: Current Weather
    var currentLocationName:String{
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.location
        }
    }
    var lastUpdateDateAndTimeString:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyy MM:HH"
            return dateFormatter.stringFromDate(fc.date)
        }
    }
    var currentTemperatureString:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.localizedTemperatureString
        }
    }
    var currentMaxTemperatureString:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.localizedMaxTemperatureString
        }
    }
    var currentMinTemperatureString:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.localizedMinTemeratureString
        }
    }
    var currentWeatherConditionIconText:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.iconText
        }
    }
    var currentWeatherConditionText:String {
        get{
            guard let fc = forecast else {
                return ""
            }
            return fc.weatherConditionText
        }
    }
    
    //: Forecasts
    var totalNumberOfTodaysForecasts:Int {
        get {
            guard let fcs = forecastsItems else {
                return 0
            }
            return fcs.forecastForToday().count
        }
    }
    var totalNumberOfFutureForecastsExcludingToday:Int {
        get {
            guard let fcs = forecastsItems else {
                return 0
            }
            return fcs.forecastExcludingToday().count
        }
    }
    
    func todayForecastTemperatureStringForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastForToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return fc.localizedTemperatureString
    }
    func todayForecastShortDateTimeStringForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastForToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return fc.date.dayAndMonth()
    }
    func todayForecastWeatherConditionIconTextForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastForToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return fc.iconText
    }
    
    func futureForecastTemperatureStringForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastExcludingToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return fc.localizedTemperatureString
    }
    func futureForecastShortDateTimeStringForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastExcludingToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return "\(fc.date.dayAndMonth())\n\(fc.date.shortTime())"
    }
    func futureForecastWeatherConditionIconTextForIndex(index:Int) -> String? {
        guard index >= 0 else { return .None }
        guard let fcs = forecastsItems else {
            return .None
        }
        let tfcs = fcs.forecastExcludingToday()
        guard  tfcs.count > 0 && index <= tfcs.count else {
            return .None
        }
        let fc = tfcs[index]
        return fc.iconText
    }
}
//: Extension which will implement LocationManagerDelegate method
extension CurrentWeatherForecastViewModel : LocationManagerDelegate {
    func locationDidUpdate(service: LocationManager, location: CLLocation) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.location = location
            self.getCurrentWeatherAndForecastData()
        }
    }
}
