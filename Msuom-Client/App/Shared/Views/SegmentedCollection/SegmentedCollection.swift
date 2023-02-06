//
//  SegmentedCollection.swift
//  LocationClient
//
//  Created by MGAbouarab on 23/09/2022.
//

import UIKit

protocol SegmentedCollectionItem {
    var id: String {get set}
    var name: String? {get set}
    var isSelected: Bool {get set}
}

protocol SegmentedCollectionDelegate: UIViewController {
    var collectionItems: [SegmentedCollectionItem] {get}
    func segmentedCollectionItem(_ segmentedCollectionItem: SegmentedCollection, didSelectItemAt indexPath: IndexPath)
}

class SegmentedCollection: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Properties -
    weak var delegate: SegmentedCollectionDelegate?
    
    //MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupCollectionView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupCollectionView()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SegmentedCollection", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    
    //MARK: - Data -
    func reload() {
        self.collectionView.reloadData()
    }
    
    //MARK: - Actions -
    
}

//MARK: - CollectionView -
extension SegmentedCollection {
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: SegmentedCollectionCell.self)
    }
    
}
extension SegmentedCollection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.collectionItems.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SegmentedCollectionCell.self, for: indexPath)
        if let item = self.delegate?.collectionItems[indexPath.item] {
            cell.setup(name: item.name ?? "", isSelected: item.isSelected)
        }
        return cell
    }
}
extension SegmentedCollection: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.delegate?.segmentedCollectionItem(self, didSelectItemAt: indexPath)
    }
}
extension SegmentedCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = self.delegate?.collectionItems[indexPath.item].name ?? ""
        let height = collectionView.bounds.height - 8
        let width = name.width(withConstrainedHeight: height, font: .systemFont(ofSize: 17)) + 16
        return CGSize(width: width, height: height)
    }
}
