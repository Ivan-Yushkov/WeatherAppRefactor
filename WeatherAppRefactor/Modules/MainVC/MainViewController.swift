//
//  MainViewController.swift
//  WeatherAppRefactor
//
//  Created by Иван Юшков on 14.12.2020.
//

import UIKit
import SVProgressHUD
import SnapKit
import CoreLocation

protocol MainViewControllerProtocol: class {
    func updateInterface(currentWeather: CurrentWeather?)
    func startRefreshing()
    func stopRefreshing()
}

class MainViewController: UIViewController {
   
    var presenter: PresenterMainVCProtocol?
    var networking: NetworkServiceProtocol?
    var currentWeather: CurrentWeather?
    
    //MARK: - create view objects
    
    lazy var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = view.bounds
        let image = UIImage(named: "background")
        iv.image = image
        
        return iv
    }()
    
    lazy var conditionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "30 C"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "feels like temp"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfiguratorMainVC().configure(view: self, networking: DI.resolve(), locationService: DI.resolve())
        view.addSubview(coverImageView)
        view.addSubview(conditionImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeLabel)
        view.addSubview(searchButton)
        view.addSubview(cityLabel)
        makeConstraints()
        presenter?.getWeatherFromLocation()
        //MARK: - add target to button
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
    }
    
    public func updateInterface(currentWeather: CurrentWeather?) {
        DispatchQueue.main.async {
            guard let image = UIImage(systemName: currentWeather?.conditionString ?? "") else { return }
            self.conditionImageView.image = image
            self.cityLabel.text = currentWeather?.cityName
            self.feelsLikeLabel.text = currentWeather?.feelsLikeTemperatureString
            self.temperatureLabel.text = currentWeather?.temperatureString
            
        }
    }
    
    //MARK: - Make Constraints for views
    private func makeConstraints() {
        coverImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view).offset(0)
        }
        conditionImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(70)
            make.height.equalTo(125)
            make.width.equalTo(125)
            make.centerX.equalTo(self.view)
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
            make.width.equalTo(conditionImageView)
            make.height.equalTo(50)
        }
        
        feelsLikeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(1)
            make.width.equalTo(temperatureLabel)
            make.height.equalTo(21)
            make.centerX.equalTo(self.view)
        }
        
        searchButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-33)
            make.right.equalTo(self.view.snp.right).offset(-33)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        cityLabel.snp.makeConstraints { (make) in
            make.right.equalTo(searchButton.snp.left).offset(1)
            make.bottom.equalTo(self.view.snp.bottom).offset(-39)
            make.width.equalTo(100)
            make.height.equalTo(21)
        }
    }
    
    
    @objc func searchAction() {
        createAlertSearch(title: nil, message: "input city", style: .alert) { (city) in
            self.presenter?.getWeatherFromCity(city: city)
        }
    }
}


extension MainViewController: MainViewControllerProtocol {
    func startRefreshing() {
        
    }
    
    func stopRefreshing() {
        
    }
}

//MARK: - Create Alert Controller for input cityName
extension MainViewController {
    func createAlertSearch(title: String?, message: String?, style: UIAlertController.Style, completionHandling: ( @escaping (String) -> Void)) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { (tf) in
            let cities = ["Stavropol", "New York", "London", "Sidney", "Pattya", "Limasol", "Usinsk"]
            tf.placeholder = cities.randomElement()
        }
        
        let searchAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let text = ac.textFields?.first?.text else { return }
            let cityName = text
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandling(city)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(searchAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
}

