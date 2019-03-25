//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by user150412 on 3/25/19.
//  Copyright © 2019 user150412. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation{
    var name = ""
    var coordinates = ""
    
    func getWeather(){
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        AF.request(weatherURL).responseJSON{response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print("json:\(json)")
            case .failure(let error):
                print(error)
            }}
    }
}
