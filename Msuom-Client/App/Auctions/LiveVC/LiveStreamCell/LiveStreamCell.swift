//
//  LiveStreamCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 21/05/2023.
//
//  Template by MGAbouarab®


import UIKit
import OpenTok

class LiveStreamCell: UICollectionViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var muteButton: UIButton!
    
    //MARK: - properties -
    var subscriber: OTSubscriber?
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCellData()
    }
    override func layoutSubviews() {
        if let sub = subscriber, let subView = sub.view {
            subView.translatesAutoresizingMaskIntoConstraints = true
            subView.frame = bounds
            subView.isHidden = false
            contentView.insertSubview(subView, belowSubview: muteButton)
            muteButton.isEnabled = true
            muteButton.isHidden = true
        }
    }
    
    //MARK: - Design Methods -
    private func setupInitialDesign() {
        
    }
    private func resetCellData() {
        
    }
    
    //MARK: - Set Data Methods -
    func configureWith(data: Stream) {
        
    }
    @IBAction func muteSubscriberAction(_ sender: AnyObject) {
        subscriber?.subscribeToAudio = !(subscriber?.subscribeToAudio ?? true)
        
        muteButton.isSelected = (subscriber?.subscribeToAudio ?? true)
        
    }
    
}
