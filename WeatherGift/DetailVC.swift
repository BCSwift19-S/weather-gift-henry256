//
//  DetailVC.swift
//  WeatherGift
//
//  Created by user150412 on 3/11/19.
//  Copyright © 2019 user150412. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0{
            getLocation()
        }
    }
    func updateUserInterface(){
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = locationsArray[currentPage].coordinates
        
    }

}
extension DetailVC: CLLocationManagerDelegate{
    
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        handleLocationAuthorizeStatus(status: status)
    }
    func handleLocationAuthorizeStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("can't show location. User has not authorized its use")
        case .restricted:
            print("Access denied")
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizeStatus(status: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        let currentCoodinates = "\(currentLatitude),\(currentLongitude)"
        print(currentCoodinates)
        dateLabel.text = currentCoodinates
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks ,error in
            if placemarks != nil{
                let placemark = placemarks?.last
                place = (placemark?.name)!
            }
            else{
                print("error retrieving place")
                place = "Unknown weather location"
            }
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoodinates
            self.locationsArray[0].getWeather()
            self.updateUserInterface()
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("failed to get user location")
        
    }
}
