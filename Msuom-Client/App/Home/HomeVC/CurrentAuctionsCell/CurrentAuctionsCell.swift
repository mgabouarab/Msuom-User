//
//  CurrentAuctionsCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class CurrentAuctionsCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    //MARK: - Proprieties -
    private var items: [Auction] = []
    
    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setupCollectionView()
    }
    
    //MARK: - Setup Data -
    func set(auctions: [Auction], title: String?) {
        self.items = auctions
        self.titleLabel.text = title
        self.collectionView.reloadData()
    }
    
}

extension CurrentAuctionsCell {
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: CurrentAuctionCell.self)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
extension CurrentAuctionsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(with: CurrentAuctionCell.self, for: indexPath)
        cell.configureWith(data: item.homeComingSoonCellData())
        return cell
    }
    
}
extension CurrentAuctionsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard UserDefaults.isLogin else {
//            (self.parentContainerViewController as? BaseVC)?.showLogoutAlert { [weak self] in
//                (self?.parentContainerViewController as? BaseVC)?.presentLogin()
//            }
//            return
//        }
        let item = self.items[indexPath.row]
        let vc = AuctionDetailsVC.create(id: item.id, isFromHome: true)
        self.parentContainerViewController?.show(vc, sender: self)
        
    }
}
extension CurrentAuctionsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.75, height: 80)
    }
}
