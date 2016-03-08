//
//  Parser.swift
//  Weather
//
//  Created by Adnan Aftab on 3/7/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

typealias ParserCompletionHandler = (AnyObject?, Error?) -> Void
protocol Parser {
    func parseData(data:NSData?, completionHandler:ParserCompletionHandler)
}