//
//  ForecastClient.swift
//  Weather
//
//  Created by Adnan Aftab on 3/7/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
import CoreLocation


typealias ForecastClientCompletionHandler = ([Forecast]?, Error?) -> Void
typealias CurrentWeatherCompletionHandler = (Forecast?, Error?) -> Void

//: This class is responsible for fetching weather forecast data from server and parsing it

class ForecastClient : HttpClient {

    private let FORECAST_API_URL =  "http://api.openweathermap.org/data/2.5/forecast"
    private let WEATHER_API_URL = "http://api.openweathermap.org/data/2.5/weather"
    private let API_ID = "da9397b92fc24e8e0e1efb8069eb7a8a"
    
    /**
     * @breif private method used by to invoke superclass fetchDataFromURL
     * @param url:NSURL to fetch data from
     * @param handler:HTTPClientCompletionHandler which will be executed once get data
     */
    private func getDataFromURL(url:NSURL,completionHandler:HttpClientCompletionHandler) {
        print("URL : \(url.absoluteString)")
        fetchDataFromServer(url, completionHandler: completionHandler)
    }
    
    /**
     * @breif private method to construct url from provided params
     * @param dictionay params which will be added as queryItems in URL
     * @return optionalURL:NSURL?
     */
    
    private func constructURLWithParams(params:[String:String]?, forecast:Bool) -> NSURL? {
        
        guard let components = NSURLComponents(string:(forecast) ? FORECAST_API_URL : WEATHER_API_URL) else {
            return nil
        }
        
        // let create query items
        var queryItems = [NSURLQueryItem]()
        queryItems.append(NSURLQueryItem(name:"appid", value:String(API_ID)))
        
        // loop over query params and create a query item
        if let queryParams = params {
            for (key,val) in queryParams {
                let queryItem = NSURLQueryItem(name: key, value: val)
                queryItems.append(queryItem)
            }
        }
        
        components.queryItems = queryItems
        return components.URL
    }
    
    /**
     * @breif private method of class which will consturct a url and call super class method to getch Data from url
     * @param params:Dictionary dicationary of params need to add as queryItems in url
     * @param completionHandler:ForecastCompletionHandler
     * @return void
     */
    private func getForecastWithParams(params:[String:String], completionHandler:ForecastClientCompletionHandler){
        guard let url = constructURLWithParams(params,forecast: true) else {
            completionHandler(.None, Error.InvalidURL)
            return
        }
        
        getDataFromURL(url) { (data:NSData?, error:Error?) in
            self.parseForecastData(data, completionHandler: { (parseObject, error) in
                guard let forecasts =  parseObject else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(forecasts, nil)
            })
        }
    }
    /**
     * @breif private method of class which will consturct a url and call super class method to getch Data from url
     * @param params:Dictionary dicationary of params need to add as queryItems in url
     * @param completionHandler:ForecastCompletionHandler
     * @return void
     */
    private func getCurrentWeatherWithParams(params:[String:String], completionHandler:CurrentWeatherCompletionHandler){
        guard let url = constructURLWithParams(params,forecast: false) else {
            completionHandler(.None, Error.InvalidURL)
            return
        }
        
        getDataFromURL(url) { (data:NSData?, error:Error?) in
            self.parseCurrentWeatherData(data, completionHandler: { (parseObject, error) in
                print(parseObject)
                guard let fc =  parseObject  else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(fc, nil)
            })
        }
    }
    
    /**
     * @breif this method will get forecasts from server by location (lat, lon)
     * @param location:CLLocation for which forecast needed
     * @param handler:ForecastCompletionHandler method will execute handler when finish fetching and parsing data from server
     * @return void
     */
    func getForecastsWithLocation(location:CLLocation, completionHandler:ForecastClientCompletionHandler){
        let params = ["lat":String(location.coordinate.latitude), "lon":String(location.coordinate.longitude)]
        getForecastWithParams(params, completionHandler: completionHandler)
    }
    
    /**
     * @breif this method will get forecasts from server by cityName
     * @param cityName:String city for which forecast need to fetch
     * @param handler:ForecastCompletionHandler method will execute handler when finish fetching and parsing data from server
     * @return void
     */
    func getForecastWithCityName(cityName:String, completionHandler:ForecastClientCompletionHandler){
        let params = ["city":cityName]
        getForecastWithParams(params, completionHandler: completionHandler)
        
    }
    
    //: Current Weather
    
    /**
    * @breif this method will get current weather info from server by location (lat, lon)
    * @param location:CLLocation for which forecast needed
    * @param handler:ForecastCompletionHandler method will execute handler when finish fetching and parsing data from server
    * @return void
    */
    func getCurrentWeatherWithLocation(location:CLLocation, completionHandler:CurrentWeatherCompletionHandler){
        let params = ["lat":String(location.coordinate.latitude), "lon":String(location.coordinate.longitude)]
        getCurrentWeatherWithParams(params, completionHandler: completionHandler)
    }
    /**
     * @breif this method will get current weather info from server by cityName
     * @param cityName:String city for which forecast need to fetch
     * @param handler:ForecastCompletionHandler method will execute handler when finish fetching and parsing data from server
     * @return void
     */
    func getWeatherWithCityName(cityName:String, completionHandler:CurrentWeatherCompletionHandler){
        let params = ["city":cityName]
        getCurrentWeatherWithParams(params, completionHandler: completionHandler)
    }
}
//: Forecast parser
extension ForecastClient {
    
    /**
     * @breif Parser class method use to parse server data to create Forecast class objects
     * @param data:NSData to parse
     * @param handler:ParserCompletionHandler to execute after parsing
     * @return void
     */
    func parseForecastData(data: NSData?, completionHandler: ForecastClientCompletionHandler) {
        guard let parseableData = data else {
            completionHandler(.None,Error.NoDataFound)
            return
        }
        
        let json = JSON(data: parseableData)
        
        // Get temperature, location and icon and check parsing error
        guard let country = json["city"]["country"].string
            else {
                completionHandler(nil, Error.InvalidData)
                return
        }
        
        var forecasts: [Forecast] = []
        // Get the first four forecasts
        guard let count = json["list"].array?.count else {
            completionHandler(nil,Error.InvalidData)
            return
        }
        for index in 0 ..< count {
            guard let forecastTempDegrees = json["list"][index]["main"]["temp"].double,
                cityName = json["city"]["name"].string,
                forecastMaxTemp = json["list"][index]["main"]["temp_max"].double,
                forecastMinTemp = json["list"][index]["main"]["temp_min"].double,
                rawDateTime = json["list"][index]["dt"].double,
                forecastCondition = json["list"][index]["weather"][0]["id"].int,
                forecastConditionText = json["list"][index]["weather"][0]["main"].string,
                forecastIcon = json["list"][index]["weather"][0]["icon"].string else {
                    break
            }
            
            let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: forecastIcon)
            
            
            let dt = NSDate(timeIntervalSince1970: rawDateTime)

            let forecast = Forecast(country:country,
                location:cityName,
                date: dt, iconText:
                weatherIcon.iconText,
                temperature:forecastTempDegrees,
                maxTemperature: forecastMaxTemp,
                minTemperature: forecastMinTemp,
                weatherConditionText: forecastConditionText)

            forecasts.append(forecast)
            
        }
        
        completionHandler(forecasts, .None)
        
    }
     func parseCurrentWeatherData(data: NSData?, completionHandler: CurrentWeatherCompletionHandler) {
        guard let parseableData = data else {
            completionHandler(.None,Error.NoDataFound)
            return
        }
        
        let json = JSON(data: parseableData)
        guard let temp = json["main"]["temp"].double,
            minTempDegrees = json["main"]["temp_min"].double,
            maxTempDegrees = json["main"]["temp_max"].double,
            country = json["sys"]["country"].string,
            city = json["name"].string,
            forecastCondition = json["weather"][0]["id"].int,
            iconString = json["weather"][0]["icon"].string,
            textDesc = json["weather"][0]["main"].string,
            rawDateTime = json["dt"].double
            /*sunriseTime = json["sys"]["sunrise"].double,
            sunsetTime = json["sys"]["sunset"].double*/
            else {
                completionHandler(nil, Error.InvalidData)
                return
        }
        let weatherIcon = WeatherIcon(condition: forecastCondition, iconString: iconString)
        
        
        let dt = NSDate(timeIntervalSince1970: rawDateTime)
        
        let forecast = Forecast(country:country,
            location:city,
            date: dt,
            iconText:weatherIcon.iconText,
            temperature:temp,
            maxTemperature: maxTempDegrees,
            minTemperature: minTempDegrees,
            weatherConditionText: textDesc)
        
        completionHandler(forecast, .None)
    }
}