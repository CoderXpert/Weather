//
//  ForecastType.swift
//  Weather
//
//  Created by Adnan Aftab on 3/8/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
protocol ForecastType {
    var location:String {get set}
    var time: String { get set }
    var date : NSDate { get set}
    var iconText: String { get set}
    var temperature: Double { get set}
    var maxTemperature : Double { get set}
    var minTemperature : Double { get set}
    var weatherConditionText : String { get set}
}