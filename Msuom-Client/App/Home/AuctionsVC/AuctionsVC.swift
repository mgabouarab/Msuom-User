//
//  AuctionsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import UIKit


//MARK: - ViewController
class AuctionsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var auctions: [Auction] = []
    
    
    //MARK: - Creation -
    static func create() -> AuctionsVC {
        let vc = AppStoryboards.home.instantiate(AuctionsVC.self)
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setupNavigationView()
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc func refresh() {
        self.auctions = []
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getAuctionsData()
    }
    
}


//MARK: - Start Of TableView -
extension AuctionsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension AuctionsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard !auctions.isEmpty else {
            return nil
        }
        
        func spacer() -> UIView {
            let spacer = UIImageView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.widthAnchor.constraint(equalToConstant: 20).isActive = true
            return spacer
        }
        
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = Theme.colors.mainDarkFontColor
        titleLabel.text = "Next Auctions".localized
        
        stack.addArrangedSubview(spacer())
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(spacer())
        
        return stack
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.auctions.isEmpty)
        return auctions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AuctionCell.self, for: indexPath)
        let auction = self.auctions[indexPath.row]
        cell.configureWith(data: auction.cellViewData())
        return cell
    }
}
extension AuctionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension AuctionsVC {
    private func getAuctionsData() {
        self.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideIndicator()
            self.auctions = Auction.auctions
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension AuctionsVC {
    
}
