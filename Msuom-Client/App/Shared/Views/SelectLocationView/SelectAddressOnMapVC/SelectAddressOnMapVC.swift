//
//  SelectAddressOnMapVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 24/05/2023.
//
//  Template by MGAbouarab®


import UIKit
import MapKit

protocol AddAddressDelegate {
    func update(with locationCoordinate: CLLocationCoordinate2D)
}

class SelectAddressOnMapVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var mapView: MKMapView!
    
    //MARK: - Properties -
    private var locator: Locator?
    private var delegate: AddAddressDelegate?
    
    
    //MARK: - Creation -
    static func create(delegate: AddAddressDelegate?) -> SelectAddressOnMapVC {
        let vc = AppStoryboards.shared.instantiate(SelectAddressOnMapVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.locator = Locator(delegate: self)
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Select Location".localized)
        self.mapView.delegate = self
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @IBAction private func confirmButtonPressed() {
        self.delegate?.update(with: self.mapView.centerCoordinate)
        self.pop()
    }
    
}


//MARK: - Networking -
extension SelectAddressOnMapVC {
    
}

//MARK: - Routes -
extension SelectAddressOnMapVC {
    
}

extension SelectAddressOnMapVC: LocatorDelegate {
    
    func updateUserLocation(lat: Double, long: Double) {
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(mRegion, animated: true)
        
        // Get user's Current Location and Drop a pin
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
        AppHelper.getAddressFrom(latitude: lat, longitude: long) { [weak self] (address) in
            guard let self = self else {return}
            
        }
        self.mapView.addAnnotation(annotation)
        
    }
    func showLocationAlert(message: String) {
        self.showErrorAlert(error: message)
    }
    
}

extension SelectAddressOnMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        AppHelper.getAddressFrom(latitude: lat, longitude: long) { [weak self] (address) in
            guard let self = self else {return}
            
        }
    }
}
