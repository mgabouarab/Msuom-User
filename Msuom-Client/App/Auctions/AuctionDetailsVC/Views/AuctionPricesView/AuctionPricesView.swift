//
//  AuctionPricesView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit
import AVFoundation

class AuctionPricesView: TextFieldView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var startPriceLabel: UILabel!
    @IBOutlet weak private var startPriceView: UIView!
    @IBOutlet weak private var currentPriceLabel: UILabel!
    @IBOutlet weak private var currentPriceView: UIView!
    @IBOutlet weak private var numberOfBiddingLabel: UILabel!
    @IBOutlet weak private var numberOfBiddingView: UIView!
    
    //MARK: - Properties -
    
    
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupInitialDesign()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AuctionPricesView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        
    }
    
    
    //MARK: - Encapsulation -
    func set(startPrice: String?, currentPrice: String?, numberOfBidding: String?) {
        
        if let startPrice = startPrice {
            self.startPriceLabel.text = startPrice
            self.startPriceView.isHidden = false
        } else {
            self.startPriceView.isHidden = true
        }
        self.update(currentPrice: currentPrice)
        self.update(numberOfBidding: numberOfBidding)
        
    }
    func update(currentPrice: String?) {
        if let currentPrice = currentPrice {
            self.currentPriceLabel.text = currentPrice
            self.currentPriceView.isHidden = false
        } else {
            self.currentPriceView.isHidden = true
        }
        self.currentPriceView.shake()
    }
    func update(numberOfBidding: String?) {
        if let numberOfBidding = numberOfBidding {
            self.numberOfBiddingLabel.text = numberOfBidding
            self.numberOfBiddingView.isHidden = false
        } else {
            self.numberOfBiddingView.isHidden = true
        }
    }
    var audioPlayer: AVAudioPlayer?
    func playSound() {

        if let soundURL = Bundle.main.url(forResource: "newBid", withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)

                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }

        } else {
            print("Sound file not found.")
        }
    }
    
    //MARK: - Action -
    
    
}
