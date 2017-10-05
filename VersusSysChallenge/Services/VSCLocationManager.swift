//
//  VSCLocationManager.swift
//  VersusSysChallenge
//
//  Created by Arbi on 10/2/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol VSCLocationManagerProtocol:class{
    
    func didUpdateLocation(long:Double,lat:Double)

}
//gets current location of the user
class VSCLocationManager:NSObject,CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    public var longitude:Double = 0.0
    public var latitude:Double = 0.0
    weak var vscDelegate:VSCLocationManagerProtocol?
    
    override init() {
        super.init()
        getUsersLocation()
    }
    
    func getUsersLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate{
         latitude = coord.latitude
         longitude = coord.longitude
         vscDelegate?.didUpdateLocation(long: longitude, lat: latitude)

        }
    }
}
