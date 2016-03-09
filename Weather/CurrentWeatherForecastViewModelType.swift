//
//  CurrentWeatherForecastViewModelType.swift
//  Weather
//
//  Created by Adnan Aftab on 3/8/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
//: Notificaitons
enum ForecastViewModelNotificaitons : String {
    case GotNewForecastData = "viewModelGotNewForecastData"
    case GotNewCurrentWeatherData = "viewModelGotNewCurrentWeatherData"
    case GotAnErrorWhileFetchingCurrentWeather = "viewModelFetchCurrentWeather"
    case GotNoForecasts = "viewModelGotNoForecasts"
    case GotNoCurrentWeatherData = "viewModelGotNoCurrentWeatherData"
    case StartLoadingCurrentWeatherInfo = "viewModelStartLoadingCurrentWeatherInfo"
}
protocol CurrentWeatherForecastViewModelType {
    //: Current Weather
    var currentLocationName:String {get}
    var lastUpdateDateAndTimeString:String {get}
    var currentTemperatureString:String {get}
    var currentMaxTemperatureString:String {get}
    var currentMinTemperatureString:String {get}
    var currentWeatherConditionIconText:String {get}
    var currentWeatherConditionText:String {get}
    
    //: Forecasts
    var totalNumberOfTodaysForecasts:Int {get}
    var totalNumberOfFutureForecastsExcludingToday:Int {get}
    
    func todayForecastTemperatureStringForIndex(index:Int) -> String?
    func todayForecastShortDateTimeStringForIndex(index:Int) -> String?
    func todayForecastWeatherConditionIconTextForIndex(index:Int) -> String?
    
    func futureForecastTemperatureStringForIndex(index:Int) -> String?
    func futureForecastShortDateTimeStringForIndex(index:Int) -> String?
    func futureForecastWeatherConditionIconTextForIndex(index:Int) -> String?
    
    //: Update
    func updateWeatherData()->Void
}