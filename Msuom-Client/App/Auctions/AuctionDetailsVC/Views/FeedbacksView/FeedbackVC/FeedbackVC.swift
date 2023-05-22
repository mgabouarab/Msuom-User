//
//  FeedbackVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//

import UIKit

protocol TextViewVCDelegate {
    func didWrite(feedback: FeedbackModel?)
    func getValidationMessage() -> String
}

protocol FeedbackEditDelegate {
    func edit(feedback: FeedbackModel)
}

class FeedbackVC: BaseVC {
    
    enum OperationType {
        case add(bidId: String, streamId: String)
        case edit(feedback: FeedbackModel, delegate: FeedbackEditDelegate)
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var textView: AppTextView!
    @IBOutlet weak private var dismissImageView: UIImageView!
    @IBOutlet weak private var sheetView: UIView!
    @IBOutlet weak private var ratingView: StarRatingView!
    
    //MARK: - Properties -
    private lazy var sheetHeight: CGFloat = self.sheetView.bounds.height
    private var delegate: TextViewVCDelegate!
    private var titleLocalizedKey: String?
    private var placeholderLocalizedKey: String?
    private var type: OperationType!
    
    //MARK: - Creation -
    static func create(delegate: TextViewVCDelegate, titleLocalizedKey: String?, placeholderLocalizedKey: String?, type: OperationType) -> FeedbackVC {
        let vc = AppStoryboards.auctions.instantiate(FeedbackVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = delegate
        vc.titleLocalizedKey = titleLocalizedKey
        vc.placeholderLocalizedKey = placeholderLocalizedKey
        vc.type = type
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupPanGesture()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimate()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "".localized
        self.view.backgroundColor = Theme.colors.blackColor.withAlphaComponent(0.2)
        
        self.textView.titleLocalizedKey = self.titleLocalizedKey
        self.textView.placeholderLocalizedKey = self.placeholderLocalizedKey
        
        self.sheetView.alpha = 0
        
//        self.sheetView.clipsToBounds = true
//        self.sheetView.layer.cornerRadius = 40
//        self.sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeAnimate))
        self.dismissImageView.addGestureRecognizer(tap)
        self.dismissImageView.isUserInteractionEnabled = true
        
        switch self.type! {
        case .add: break
        case .edit(let feedback, _):
            self.ratingView.rating = Float(feedback.rating?.doubleValue ?? 0)
            self.textView.set(text: feedback.comment)
        }
        
    }
    private func showAnimate(){
        self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.sheetView.bounds.height)
        self.sheetView.alpha = 1
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            self.sheetView.transform = .identity
        }
    }
    @objc private func removeAnimate(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.sheetView.bounds.height)
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.dismiss(animated: false)
            }
        })
    }
    
    //MARK: - Logic Methods -
    
    // MARK: - Pan gesture handler -
    private func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        sheetView.addGestureRecognizer(panGesture)
    }
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: sheetView)
        let newHeight = sheetHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < sheetHeight {
                self.sheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            
            if newHeight < sheetHeight * 0.35 {
                self.removeAnimate()
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.sheetView.transform = .identity
                }
            }
        default:
            break
        }
    }
    
    
    //MARK: - Actions -
    @IBAction private func confirmButtonPressed() {
        do {
            let message = self.delegate.getValidationMessage()
            let text = try ValidationService.validate(text: self.textView.textValue(), errorMessage: message)
            let rate = Int(self.ratingView.rating)
            switch self.type! {
            case .add(let bidId, let streamId):
                self.add(bidId: bidId, comment: text, rate: rate, streamId: streamId)
            case .edit(let feedback, let delegate):
                
                var comment = feedback
                comment.comment = text
                comment.rating = .double(Double(rate))
                delegate.edit(feedback: comment)
                self.removeAnimate()
            }
        } catch {
            self.showErrorAlert(error: error.localizedDescription)
        }
    }
}


//MARK: - Networking -
extension FeedbackVC {
    func add(bidId: String, comment: String, rate: Int, streamId: String) {
        self.showIndicator()
        AuctionRouter.add(bidId: bidId, comment: comment, rate: rate, streamId: streamId).send { [weak self] (response: APIGenericResponse<FeedbackModel>) in
            guard let self = self else {return}
            self.delegate.didWrite(feedback: response.data)
            self.removeAnimate()
        }
    }
}

//MARK: - Routes -
extension FeedbackVC {
    
}

