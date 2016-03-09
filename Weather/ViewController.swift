//
//  ViewController.swift
//  Weather
//
//  Created by Adnan Aftab on 3/7/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var updateDateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var weatherConditionIcon: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var futureForecastScrollView: UIScrollView!
    @IBOutlet weak var todayForecastScrollView: UIScrollView!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var alreadyPopulatedCurrentWeather = false
    private var alreadyPopulatedForecastInfo = false
    
    var viewModel:CurrentWeatherForecastViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForViewModelNotificaitons()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    @IBAction func onTapRefreshButton(sender: AnyObject) {
        viewModel!.updateWeatherData()
    }
    private func clearCurrentWeatherUI(){
        self.locationLabel.text = ""
        self.updateDateTimeLabel.text = ""
        self.weatherConditionIcon.text = ""
        self.currentTempLabel.text = ""
    }
    private func clearForecastUI(){
        for v in self.todayForecastScrollView.subviews {
            v.removeFromSuperview()
        }
        for v in self.futureForecastScrollView.subviews {
            v.removeFromSuperview()
        }
    }
}
//: ViewModel notificaitons
extension ViewController {
     func registerForViewModelNotificaitons() {
        viewModel = CurrentWeatherForecastViewModel()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCurrentWeatherUI", name: ForecastViewModelNotificaitons.GotNewCurrentWeatherData.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "udpateForecastUI", name: ForecastViewModelNotificaitons.GotNewForecastData.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNoForecastInfo", name: ForecastViewModelNotificaitons.GotNoForecasts.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNoCurrentWeatherInfo", name: ForecastViewModelNotificaitons.GotNoCurrentWeatherData.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStartLoadingWeatherInfo", name: ForecastViewModelNotificaitons.StartLoadingCurrentWeatherInfo.rawValue, object: nil)
    }
    
    func onStartLoadingWeatherInfo(){
        self.refreshButton.hidden = true
        self.clearCurrentWeatherUI()
        self.errorTextLabel.hidden = true
        self.spinner.startAnimating()
    }
    
    func onNoCurrentWeatherInfo(){
        self.spinner.stopAnimating()
        self.refreshButton.hidden = false
        if !alreadyPopulatedCurrentWeather {
            clearCurrentWeatherUI()
            self.errorTextLabel.hidden = false
        }
        else {
            updateCurrentWeatherUI()
        }
    }
    
    func onNoForecastInfo(){
        if !alreadyPopulatedForecastInfo {
            clearForecastUI()
            self.todayForecastScrollView.hidden = true
            self.futureForecastScrollView.hidden = true
        }
    }
    
    func updateCurrentWeatherUI() {
        self.spinner.stopAnimating()
        self.refreshButton.hidden = false
        self.errorTextLabel.hidden = true
        locationLabel.text = viewModel!.currentLocationName
        updateDateTimeLabel.text = viewModel!.lastUpdateDateAndTimeString
        currentTempLabel.text = viewModel!.currentTemperatureString
        weatherConditionIcon.text = viewModel!.currentWeatherConditionIconText
        alreadyPopulatedCurrentWeather = true
    }
    func updateTodayForecastUI(){
        var xPos = 0
        for index in 0..<viewModel!.totalNumberOfTodaysForecasts {
            let frame = CGRectMake(CGFloat(xPos), 0.0, 80.0, 114.0)
            let fv = ForecastView(frame: frame)
            fv.temperature = viewModel?.todayForecastTemperatureStringForIndex(index)
            fv.icon = viewModel?.todayForecastWeatherConditionIconTextForIndex(index)
            fv.time = viewModel?.todayForecastShortDateTimeStringForIndex(index)
            self.todayForecastScrollView.addSubview(fv)
            xPos += 80
        }
        self.todayForecastScrollView.contentSize = CGSizeMake(CGFloat(xPos), 114.0)
    }
    func updateFutureForecastUI(){
        var xPos = 0
        for index in 0..<viewModel!.totalNumberOfFutureForecastsExcludingToday {
            let frame = CGRectMake(CGFloat(xPos), 0.0, 80.0, 114.0)
            let fv = ForecastView(frame: frame)
            fv.temperature = viewModel?.futureForecastTemperatureStringForIndex(index)
            fv.icon = viewModel?.futureForecastWeatherConditionIconTextForIndex(index)
            fv.time = viewModel?.futureForecastShortDateTimeStringForIndex(index)
            xPos += 80
            self.futureForecastScrollView.addSubview(fv)
        }
        self.futureForecastScrollView.contentSize = CGSizeMake(CGFloat(xPos), 114.0)
    }
    func udpateForecastUI() {
        clearForecastUI()
        self.todayForecastScrollView.hidden = false
        self.futureForecastScrollView.hidden = false
        updateTodayForecastUI()
        updateFutureForecastUI()
        alreadyPopulatedForecastInfo = true
    }
}
