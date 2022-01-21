//
//  AirDataModel.swift
//  PM
//
//  Created by Ray Wan on 2020/7/6.
//  Copyright © 2020 Ray Wan. All rights reserved.
//

import Foundation


struct AirDataModel
{
    var pm25:Int
    var pm10:Int
    var AQI:Int
    var name:String
    
    var condition:Void{
        switch AQI{
        case 0...50:
            return
        case 51...100:
            return
        case 101...150:
            return
        case _ where AQI > 150:
            return
        default:
            return
        }
    }

}
