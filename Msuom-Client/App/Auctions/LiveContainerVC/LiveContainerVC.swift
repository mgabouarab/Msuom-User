//
//  LiveContainerVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class LiveContainerVC: BaseVC {
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak var liveContainerView: UIView!
    
    //MARK: - Properties -
    private var liveView: LiveVC!
    
    //MARK: - Creation -
    static func create(liveView: LiveVC?) -> LiveContainerVC {
        let vc = AppStoryboards.auctions.instantiate(LiveContainerVC.self)
        vc.liveView = liveView
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLiveVC()
    }
    override func addKeyboardDismiss() {
        
    }
    
    private func addLiveVC() {
        if let childVC = self.liveView {
            self.addChild(childVC)
            childVC.view.frame = self.liveContainerView.bounds
            self.liveContainerView.addSubview(childVC.view)
            childVC.didMove(toParent: self)
        }
    }
    
    //MARK: - Actions -
    
    
}
