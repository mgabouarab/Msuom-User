//
//  HomeCategoryCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class HomeCategoryCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Proprieties -
    private var items: [IdName] = []
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setupCollectionView()
    }
    
    //MARK: - Setup Data -
    func set(carBrands: [IdName], title: String?) {
        self.items = carBrands
        self.titleLabel.text = title
        self.collectionView.reloadData()
    }
    
}

extension HomeCategoryCell {
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: BrandCell.self)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
extension HomeCategoryCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(with: BrandCell.self, for: indexPath)
        cell.setup(image: item.image, name: item.name, isSelected: false)
        return cell
    }
    
}
extension HomeCategoryCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        let vc = BrowseCarVC.create(type: .brand(id: item.id, title: item.name))
        self.parentContainerViewController?.show(vc, sender: self)
    }
}
extension HomeCategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 80)
    }
}
