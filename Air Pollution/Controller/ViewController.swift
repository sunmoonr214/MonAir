//
//  ViewController.swift
//  Air Pollution
//
//  Created by Ray Wan on 2020/7/7.
//  Copyright © 2020 Ray Wan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController, searchControllerDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var pm25display: UILabel!
    @IBOutlet weak var pm10display: UILabel!
    @IBOutlet weak var pm25View: UIView!
    @IBOutlet weak var pm10View: UIView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var indexValue: UILabel!
    @IBOutlet weak var quality: UILabel!
    var pm25converter = AQIPM25()
    var long:Double = 0
    var lat:Double = 0
    let geocoder = CLGeocoder()
    
    var searchLocation = ""
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    var currentLocation:String = ""
    var pm25Data:Int = 0
    var pm10Data:Int? = 0
    var AQI:Int = 0
    @IBOutlet weak var pm10Circle: PlainCircularProgressBar!
    @IBOutlet weak var pm25Circle: PlainCircularProgressBar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        myView.layer.cornerRadius = 30
        pm10View.layer.cornerRadius = pm10View.frame.height/8
        pm25View.layer.cornerRadius = pm25View.frame.height/8
        pm10Circle.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        pm25Circle.color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        
    }
    func updateView()
    {
        
        location.text = searchLocation
        indexValue.text = "\(AQI)"
        switch AQI{
        case 0...50:
            quality.text = "Good"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Green"))
        case 51...100:
            quality.text = "Moderate"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Yellow"))
        case 101...150:
            quality.text = "Unhealthy for Sensitive Groups"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Yellow"))
        case 151...200:
            quality.text = "Unhealthy"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Red"))
        case let x where x > 201:
            quality.text = "Very Unhealthy"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Red"))
        default:
            quality.text = "Good"
            myView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Green"))
        }
    }
    
    func updateCircle()
    {
        var dpm10 = pm10Data ?? 0
        var dpm25 = pm25Data ?? 0
        if dpm10 > 100
        {
            dpm10 = 100
        }
        if dpm25 > 100
        {
            dpm25 = 100
        }
        let data = Int(pm25converter.getPM25(Double(pm25Data)))
        print(data)
        pm10Circle.progress = CGFloat(Double(dpm10)/100.0)
        pm25Circle.progress = CGFloat(Double(dpm25)/100.0)
        pm25display.text = "\(data)"
        pm10display.text = "\(pm10Data ?? 0)"
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        retrieveDataWithGeo(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil
            {
                print("There was an error: \(error)")
            }
            else
            {
                if let place = placemark?[0]
                {
                    DispatchQueue.main.async {
                        self.searchLocation = place.subAdministrativeArea!
                        print(place.subAdministrativeArea)
                    }
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func retrieveDataWithGeo(lat:Double,long:Double)
    {
        let searchURL = "https://api.waqi.info/feed/geo:\(lat);\(long)/?token=\(C.APIkey)"
        performRequest(with: searchURL)
    }
    
    func performRequest(with typeURL: String)
    {
            if let url = URL(string: typeURL)
            {
                let session = URLSession.shared
                let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error == nil && data != nil
                {
                    let decoder = JSONDecoder()
                    do
                    {
                        let info = try decoder.decode(AirData.self, from: data!)
                        self.pm25Data = info.data.iaqi.pm25.v
                        self.pm10Data = info.data.iaqi.pm10?.v
                        self.currentLocation = "\(info.data.city)"
                        self.AQI = info.data.aqi
                        DispatchQueue.main.async {
                            self.updateCircle()
                            self.updateView()
                        }
                    } catch
                    {
                        print("we have an error")
                        print(error)
                    }
                    }
                }
                dataTask.resume()
            }
        
    }
    
    //MARK: - Search
    
    @IBAction func searchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toSearch", sender: UIButton.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! searchController
        vc.lat = self.lat
        vc.long = self.long
        vc.location = self.searchLocation
        vc.delegate = self
    }
    func didBackButtonPressed()
    {
        print(lat)
        print(long)
        retrieveDataWithGeo(lat: lat, long: long)
    }
    override open var shouldAutorotate:Bool
    {
        return false
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    func onUserAction(info:Double) {
        self.long = info
        print(long)
    }
}
