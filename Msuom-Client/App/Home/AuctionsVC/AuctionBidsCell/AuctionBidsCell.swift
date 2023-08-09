//
//  AuctionBidsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 06/08/2023.
//

import UIKit

class AuctionBidsCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Properties -
    private var items: [BidDetails] = []
    var showAllAction: (()->())?
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInitialDesign()
        self.setupCollectionView()
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.selectionStyle = .none
    }
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: AuctionBidsCollectionCell.self)
    }
    
    //MARK: - Data -
    func set(name: String?, items: [BidDetails]) {
        self.titleLabel.text = name
        self.items = items
        self.collectionView.reloadData()
    }
    
    //MARK: - Action -
    @IBAction private func showAllButtonPressed() {
        self.showAllAction?()
    }
    
}

extension AuctionBidsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: AuctionBidsCollectionCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.set(image: item.image, name: item.name, date: item.startDate)
        return cell
    }
}

extension AuctionBidsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = self.items[indexPath.row].id else {return}
        let vc = AuctionDetailsVC.create(id: id)
        self.viewContainingController?.show(vc, sender: self)
    }
}

extension AuctionBidsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width*0.7, height: collectionView.bounds.height)
    }
}
