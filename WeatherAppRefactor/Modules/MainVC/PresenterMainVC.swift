//
//  PresenterMainVC.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import Foundation
import RxSwift
import CoreLocation

protocol PresenterMainVCProtocol: class {
    func getWeatherFromCity(city: String?)
    func getWeatherFromLocation()
}

class PresenterMainViewController: PresenterMainVCProtocol {
    
    var locationManager = CLLocationManager()
    var city = ""
    private var view: MainViewControllerProtocol
    private var networking: NetworkServiceProtocol
    private var locationService: LocationServiceProtocol
    private let disposeBag = DisposeBag()
    private let disposeBag2 = DisposeBag()
    private var location: CLLocation?
    
    init(view: MainViewControllerProtocol, networking: NetworkServiceProtocol, locationService: LocationServiceProtocol) {
        self.view = view
        self.networking = networking
        self.locationService = locationService
    }
    
    func getWeatherFromCity(city: String? = nil) {
        //view.startRefreshing()
        if let city = city {
            self.city = city
        }
        _ = networking.getDataWeather(type: .RequestByCity(city: city ?? ""))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                //self?.view.stopRefreshing()
                switch event {
                case .success(let currentWeather):
                    self?.view.updateInterface(currentWeather: currentWeather)
                case .error(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
    }
    
    func getWeatherFromLocation() {
        _ = locationService.getUserLocation().subscribe(onNext: {(location) in
            guard let location = location else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("hello \(longitude)")
            _ = self.networking.getDataWeather(type: .RequestByLocation(longitude: longitude ?? 0.0, latitude: latitude ?? 0.0)).observeOn(MainScheduler.instance)
                .subscribe { [weak self] (event) in
                    switch event {
                    case .success(let currentWeather):
                        self?.view.updateInterface(currentWeather: currentWeather)
                    case .error(let error):
                        print(error)
                    }
                }
        })
        
    }
}
