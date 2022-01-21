//
//  mapController.swift
//  Air Pollution
//
//  Created by Ray Wan on 2020/7/22.
//  Copyright © 2020 Ray Wan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class mapController:UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 22.989819, longitude:  120.202366, zoom: 7)
        let frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.mapType = .normal

        // Implement GMSTileURLConstructor
        // Returns a Tile based on the x,y,zoom coordinates, and the requested floor
        let urls: GMSTileURLConstructor = {(x, y, zoom) in
          let url = "https://tiles.aqicn.org/tiles/usepa-aqi/\(zoom)/\(x)/\(y).png"
          return URL(string: url)
        }
        // Create the GMSTileLayer
        let layer = GMSURLTileLayer(urlConstructor: urls)

        // Display on the map at a specific zIndex
        layer.tileSize = 512
        //layer.zIndex = 10
        layer.map = mapView
        
        self.view = mapView
    }
    
    
}
