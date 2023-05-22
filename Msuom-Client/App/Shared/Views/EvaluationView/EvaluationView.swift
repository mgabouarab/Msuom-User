//
//  EvaluationView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 13/05/2023.
//

import UIKit


class EvaluationView: UIView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var requiredMarkLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    //MARK: - Proprites -
    @IBInspectable
    var isRequired: Bool = true {
        didSet {
            self.requiredMarkLabel.isHidden = !isRequired
        }
    }
    @IBInspectable
    var titleLocalizableKey: String? = nil {
        didSet {
            self.titleLabel.xibLocKey = titleLocalizableKey
        }
    }
    private var items: [EvaluationModel] = []
    
    var selectedEvaluation: String? {
        self.items.first(where:{$0.isSelected})?.degree
    }
    
    
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
        let nib = UINib(nibName: "EvaluationView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupCollectionView()
    }
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: EvaluationViewCell.self)
    }
    func set(data: [EvaluationModel]) {
        self.items = data
        self.collectionView.reloadData()
    }
}

extension EvaluationView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(with: EvaluationViewCell.self, for: indexPath)
        cell.setup(data: item)
        if indexPath.row == 0 {
            cell.set(corner: Language.isRTL() ? .trailing : .leading)
        } else if indexPath.row == self.items.count - 1 {
            cell.set(corner: Language.isRTL() ? .leading : .trailing)
        } else {
            cell.set(corner: .middle)
        }
        return cell
    }
}
extension EvaluationView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in self.items.indices {
            self.items[index].isSelected =  false
        }
        self.items[indexPath.row].isSelected = true
        self.collectionView.reloadData()
    }
}
extension EvaluationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width/CGFloat(items.count),
            height: collectionView.bounds.height
        )
    }
}
