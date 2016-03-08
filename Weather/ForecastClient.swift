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
        fetchDataFromServer(url, completionHandler: completionHandler)
    }
    
    /**
     * @breif private method to construct url from provided params
     * @param dictionay params which will be added as queryItems in URL
     * @return optionalURL:NSURL?
     */
    
    private func constructURLWithParams(params:[String:String]?) -> NSURL? {
        
        guard let components = NSURLComponents(string:FORECAST_API_URL) else {
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
        guard let url = constructURLWithParams(params) else {
            completionHandler(.None, Error.InvalidURL)
            return
        }
        
        getDataFromURL(url) { (data:NSData?, error:Error?) in
            self.parseData(data, completionHandler: { (parseObject:AnyObject?, error:Error?) in
                guard let forecasts =  parseObject as? [Forecast] else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(forecasts, nil)
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
}

//: Forecast parser
extension ForecastClient : Parser {
    
    /**
     * @breif Parser class method use to parse server data to create Forecast class objects
     * @param data:NSData to parse
     * @param handler:ParserCompletionHandler to execute after parsing
     * @return void
     */
    func parseData(data: NSData?, completionHandler: ParserCompletionHandler) {
        
    }
}