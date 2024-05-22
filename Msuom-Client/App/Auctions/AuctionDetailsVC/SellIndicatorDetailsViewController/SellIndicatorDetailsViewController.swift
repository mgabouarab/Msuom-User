//
//  SellIndicatorDetailsViewController.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 14/05/2024.
//

import UIKit

class SellIndicatorDetailsViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var containerView: UIView!
    
    //MARK: - Properties -
    let data: [AuctionRateInfo]
    
    //MARK: - Initializers -
    init(data: [AuctionRateInfo]) {
        self.data = data
        super.init(nibName: "SellIndicatorDetailsViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) {
        self.data = []
        super.init(coder: coder)
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.containerView.layer.cornerRadius = 30
        self.containerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        
        let x = UITapGestureRecognizer()
        self.containerView.addGestureRecognizer(x)
        
        let m = UITapGestureRecognizer(target: self, action: #selector(self.endView))
        self.view.addGestureRecognizer(m)
        
        
    }
    
    
    @objc private func endView() {
        self.dismiss(animated: true)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .singleLine
        self.tableView.register(cellType: SellIndicatorDetailsTableViewCell.self)
    }
    

}

extension SellIndicatorDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SellIndicatorDetailsTableViewCell.self, for: indexPath)
        cell.set(data: self.data[indexPath.row])
        return cell
    }
    
}
