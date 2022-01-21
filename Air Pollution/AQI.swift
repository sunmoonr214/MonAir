//
//  AQI.swift
//  Air Pollution
//
//  Created by Ray Wan on 2020/7/27.
//  Copyright © 2020 Ray Wan. All rights reserved.
//
import Foundation

struct AQIPM25 {
    
    func getPM25(_ x:Double) -> Double
    {
        switch x{
        case 0...100:
            return x*0.3+0.1
        case 150...300:
            return x*0.33+0.5
        case 71...100:
            return x*0.34+0.5
        case 101...150:
            return x*0.4+0.5
        case 151...160:
            return x*0.5
        case 161...170:
            return x*0.6
        case 171...180:
            return x*0.7
        case 181...190:
            return x*0.8
        case 191...200:
            return x*0.9
        case let y where y > 200:
            return x-50
        
        default:
            return 0
        }
    }
    
    
    
}

