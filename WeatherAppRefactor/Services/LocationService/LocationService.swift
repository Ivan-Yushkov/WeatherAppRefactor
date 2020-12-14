//
//  LocationService.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationServiceProtocol: class {
    func getUserLocation() -> Observable<CLLocation?>
}

class LocationService: NSObject, LocationServiceProtocol {
    
    var userLocation = PublishSubject<CLLocation?>()
    var locationManager = CLLocationManager()
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    
    override init() {
        super.init()
        initLocationManager()
        locationManager.delegate = self
    }
    
    func getUserLocation() -> Observable<CLLocation?> {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            return userLocation.debounce(.seconds(0), scheduler: MainScheduler.instance)
            }
        return Observable.empty()
    }

    
    func initLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        seenError = false
        locationFixAchieved = false
        locationManager.delegate = self
       // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation.onNext(location)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        if (locationFixAchieved == false) {
//            locationFixAchieved = true
//            var locationArray = locations as NSArray
//            var locationObj = locationArray.lastObject as! CLLocation
//            var coord = locationObj.coordinate
//
//            print(coord.latitude)
//            print(coord.longitude)
//        }
//    }
    
    func locationManager(manager: CLLocationManager!,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
            case CLAuthorizationStatus.restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.notDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
}
 
