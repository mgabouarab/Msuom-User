//
//  Locator.swift
//  LocationClient
//
//  Created by MGAbouarab on 28/09/2022.
//

import Foundation
import CoreLocation


protocol LocatorDelegate: AnyObject {
    func updateUserLocation(lat: Double, long: Double)
    func showLocationAlert(message: String)
}
class Locator: NSObject {
    
    //MARK:- Properties
    private weak var delegate: LocatorDelegate?
    private var locationManger = CLLocationManager()
    private var usersCurrentLocation:CLLocationCoordinate2D? {
        didSet {
            if let lat = self.usersCurrentLocation?.latitude , let long = self.usersCurrentLocation?.longitude {
                let lat = Double(lat)
                let long = Double(long)
                delegate?.updateUserLocation(lat: lat, long: long)
            }
        }
    }
    
    //MARK:- init
    init(delegate: LocatorDelegate) {
        super.init()
        self.delegate = delegate
        
        //location Handeling
        self.locationManger.delegate = self
        self.locationManger.requestWhenInUseAuthorization()
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.startUpdatingLocation()
        
    }
    
}
extension Locator: CLLocationManagerDelegate {
    
    private enum LocationErrors {
        case notEnabeled
        case denied
        case restricted
        
        var message: String {
            switch self {
            case .notEnabeled:
                return "Please enable GPS service \n Settings > Privacy > Location services".localized
            case .denied:
                return "Please enable the app to access your location \n Settings > ".localized + "".localized + " > Location".localized
            case .restricted:
                return "The app is restricted from access your Location, please connect to your administrator to active it".localized
            }
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManger.authorizationStatus {
        case .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
            break
        case .denied:
            self.delegate?.showLocationAlert(message: LocationErrors.denied.message)
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            self.delegate?.showLocationAlert(message: LocationErrors.restricted.message)
            break
        case .authorizedAlways:
            locationManger.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            locationManger.requestWhenInUseAuthorization()
            return
        }
        locationManger.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.first != nil else {
            return
        }
        if let lat = locationManger.location?.coordinate.latitude , let long = locationManger.location?.coordinate.longitude {
            self.usersCurrentLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        locationManger.stopUpdatingLocation()
    }
    
}
