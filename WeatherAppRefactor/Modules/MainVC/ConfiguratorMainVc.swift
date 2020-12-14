//
//  ConfiguratorMainVc.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import Foundation

class ConfiguratorMainVC {
    func configure(
        view: MainViewController,
        networking: NetworkServiceProtocol,
        locationService: LocationServiceProtocol) {
        let presenter = PresenterMainViewController(view: view, networking: networking, locationService: locationService)
        view.presenter = presenter
    }
}
