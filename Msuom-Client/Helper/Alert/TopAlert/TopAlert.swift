//
//  TopAlert.swift
//
//  Created by MGAbouarab®
//


import UIKit

//MARK: - Enums
enum AlertType {
    case warning
    case success
    case error
    case addedToFav
    
    var image: String {
        switch self {
        case .warning:
            return "warningAlert"
        case .success:
            return "successAlert"
        case .error:
            return "errorAlert"
        case .addedToFav:
            return "addedToFav"
        }
    }
}

class TopAlert {
    
    //MARK: - Properties -
    private var isLongPressActive: Bool = false
    private var isSwipePerformed: Bool = false
    private let view = AlertView(frame: .zero)
    var message: String = "Error"
    var type: AlertType = .error
    
    //MARK: - Initialization -
    static let shared: TopAlert = TopAlert()
    private init() {}
    
    //MARK: - Animation -
    func showAnimate(){
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(view)
        view.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        
        view.set(message: message, type: type)
        view.showAnimate()
        
    }
    
}
