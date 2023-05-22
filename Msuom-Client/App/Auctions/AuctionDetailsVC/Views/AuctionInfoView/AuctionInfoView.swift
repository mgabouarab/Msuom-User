//
//  AuctionInfoView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class AuctionInfoView: UIView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var liveView: UIView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var dateView: UIView!
    @IBOutlet weak private var timeView: UIView!
    @IBOutlet weak private var evaluationView: EvaluationView!
    
    //MARK: - Properties -
    var detailsAction: (()->())?
    
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
        let nib = UINib(nibName: "AuctionInfoView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.evaluationView.isUserInteractionEnabled = false
    }
    
    //MARK: - Encapsulation -
    func set(date: String?, time: String?, evaluationLetter: String?, isLive: Bool) {
        
        var evaluations = [
            EvaluationModel(degree: "A", color: Theme.colors.a),
            EvaluationModel(degree: "B", color: Theme.colors.b),
            EvaluationModel(degree: "C", color: Theme.colors.c),
            EvaluationModel(degree: "D", color: Theme.colors.d),
            EvaluationModel(degree: "F", color: Theme.colors.f)
        ]
        
        if let index = evaluations.firstIndex(where: {$0.degree == evaluationLetter}) {
            evaluations[index].isSelected = true
        }
        
        
        self.evaluationView.isHidden = (evaluationLetter == nil || evaluationLetter?.isEmpty == true)
        self.evaluationView.set(data:
                evaluations
        )
        if let date = date {
            self.dateView.isHidden = false
            self.dateLabel.text = "Auction Date:".localized + " " + date
        } else {
            self.dateView.isHidden = true
        }
        if let time = time {
            self.timeView.isHidden = false
            self.timeLabel.text = "Auction Time:".localized + " " + time
        } else {
            self.timeView.isHidden = true
        }
        
        self.liveView.isHidden = !isLive
        
    }
    
    
    //MARK: - Action -
    
    
}
