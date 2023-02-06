//
//  AppHelper.swift
//
//  Created by MGAbouarab®
//

import UIKit
import CoreLocation
import MapKit

struct AppHelper {
    
    static func changeWindowRoot(vc: UIViewController, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIApplication.shared.windows.first?.rootViewController = vc
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.transition(with: window, duration: 0.3, options: options, animations: nil, completion: nil)
    }
    static func openUrl(_ url: String?) {
        guard let stringUrl = url else {return}
        if let url = URL(string: stringUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    
    //MARK: - Location -
    /*
     Don't Forget to add this to Info.plist
     
     <key>LSApplicationQueriesSchemes</key>
     <array>
     <string>comgooglemaps</string>
     <string>maps</string>
     </array>
     */
    
    /*
     For more information about apple maps parameters
     https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
     */
    static func openLocationOnMap(lat: String, long: String) {
        
        let actionSheet = UIAlertController(title: "Open With".localized, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let mapsAction = UIAlertAction(title: "Maps".localized, style: .default, handler: { (action) in
            if UIApplication.shared.canOpenURL(URL(string:"maps://")!) {
                UIApplication.shared.open(URL(string:"maps://?saddr=&daddr=\(lat),\(long)")!)
            }
        })
        let googleMapsAction = UIAlertAction(title: "Google Maps".localized, style: .default, handler: { (action) in
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")!)
            } else if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        })
        actionSheet.addAction(mapsAction)
        actionSheet.addAction(googleMapsAction)
        actionSheet.addAction(cancelAction)
        
        actionSheet.overrideUserInterfaceStyle = .light
        actionSheet.view.tintColor = Theme.colors.mainColor
        
        UIApplication.shared.windows.first?.rootViewController?.present(actionSheet, animated: true, completion: nil)
    }
    static func getAddressFrom(latitude: Double, longitude: Double, completion: @escaping (_ address: String?) -> Void) {
        let geocoder = CLGeocoder()
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        center.latitude = latitude
        center.longitude = longitude
        let location: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let places = placeMarks, let place = places.first else {
                completion(nil)
                return
            }
            
            let addressStrings = [
                place.subLocality,
                place.thoroughfare,
                place.locality,
                place.country,
                place.postalCode
            ]
            
            completion(addressStrings.compactMap({$0}).joined(separator: ","))
        }
        
    }
    
    /*
     https://medium.com/@carnevalimarco/generate-a-map-snapshot-with-mapkit-a47b286a8a85
     */
    static func getLocationImageData(latitude: Double, longitude: Double, size: CGSize, completion: @escaping (_ address: Data?) -> Void) {
        
        
        let options: MKMapSnapshotter.Options = .init()
        
        options.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            // zoom
            span: MKCoordinateSpan()
        )
        options.size = size
        options.mapType = .standard
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(
            options: options
        )
        
        snapshotter.start { snapshot, error in
           if let snapshot = snapshot {
               completion(snapshot.image.jpegData(compressionQuality: 1))
           } else if let error = error {
               print(error.localizedDescription)
           }
        }
        
    }
    
    
    
    
}
