//
//  AirData.swift
//  PM
//
//  Created by Ray Wan on 2020/7/6.
//  Copyright © 2020 Ray Wan. All rights reserved.
//

import Foundation
//Call name: AirData.data.city.name
//Call aqi: AirData.data.aqi
//Call pm25: AirData.data.iaqi.pm25.v
//Call pm10: AirData.data.iaqi.pm10.v
struct AirData:Codable
{
    let data:DataList
}

struct DataList:Codable
{
    let aqi:Int
    let city:City
    let iaqi: IAQI
}

struct City:Codable
{
    let name:String
}

struct IAQI:Codable
{
    let pm10:PM10?
    let pm25:PM25
}

struct PM10:Codable
{
    let v:Int?
}

struct PM25:Codable{
    let v:Int
}
