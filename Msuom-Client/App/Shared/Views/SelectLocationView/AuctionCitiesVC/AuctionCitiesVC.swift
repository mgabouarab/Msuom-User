//
//  AuctionCitiesVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 28/05/2023.
//
//  Template by MGAbouarab®


import UIKit
import MapKit


class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let id: String
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, id: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.id = id
    }
}
protocol AuctionCitiesProtocol {
    func updateWith(cityId: String?)
}

class AuctionCitiesVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var mapView: MKMapView!
    
    //MARK: - Properties -
    private var cities: [Cities] = []
    private var delegate: AuctionCitiesProtocol?
    
    //MARK: - Creation -
    static func create(cities: [Cities], delegate: AuctionCitiesProtocol) -> AuctionCitiesVC {
        let vc = AppStoryboards.shared.instantiate(AuctionCitiesVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.cities = cities
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Auctions".localized)
        self.mapView.delegate = self
        
        var annotations = [CustomAnnotation]()
        
        for city in cities {
            // Create a coordinate representing the marker's location
            let coordinate = CLLocationCoordinate2D(latitude: city.latitude?.doubleValue ?? 0, longitude: city.longitude?.doubleValue ?? 0)

            // Create an instance of your custom annotation class
            let customAnnotation = CustomAnnotation(coordinate: coordinate, title: city.name, subtitle: nil, id: city.id)
            annotations.append(customAnnotation)
            
            // Add the custom annotation to the map view
            mapView.addAnnotation(customAnnotation)
        }
        var mapRect = MKMapRect.null
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
            mapRect = mapRect.union(pointRect)
        }
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        mapRect = mapView.mapRectThatFits(mapRect, edgePadding: edgePadding)
        mapView.showsCompass = false
        // Animate the map view to the calculated map rect
        mapView.setVisibleMapRect(mapRect, edgePadding: edgePadding, animated: true)
    }
    
    //MARK: - Logic Methods -
    
    //MARK: - Actions -
    
}


//MARK: - Networking -
extension AuctionCitiesVC {
    
}

//MARK: - Routes -
extension AuctionCitiesVC {
    
}

//MARK: - Delegation -
extension AuctionCitiesVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CustomAnnotation else {
            return nil
        }
        
        let identifier = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        
        // Set your custom marker image
        annotationView?.image = UIImage(named: "appMarker")
        
        
        annotationView?.canShowCallout = true
        
        // Add a title label
        let titleLabel = UILabel(frame: view.frame)
        titleLabel.text = annotation.title ?? ""
        titleLabel.textColor = Theme.colors.mainColor
        titleLabel.font = .systemFont(ofSize: 17)
        annotationView?.detailCalloutAccessoryView = titleLabel
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let cityId = (view.annotation as? CustomAnnotation)?.id
        self.delegate?.updateWith(cityId: cityId)
        self.pop()
    }
}
