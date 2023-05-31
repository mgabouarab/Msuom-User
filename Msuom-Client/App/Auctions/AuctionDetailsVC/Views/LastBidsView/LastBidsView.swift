//
//  LastBidsView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class LastBidsView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: TableViewContentSized!
    @IBOutlet weak private var showMoreView: UIView!
    
    //MARK: - Properties -
    private var items: [LastBidModel] = [] {
        didSet {
            self.isHidden = items.isEmpty
        }
    }
    private var bidId: String?
    private var currentPage: Int = 1
    private var isLast: Bool = false
    var lastBidder:((_ id: String?)->())?
    
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
        let nib = UINib(nibName: "LastBidsView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.tableView.dataSource = self
        self.tableView.register(cellType: LastBidsCell.self)
        
        self.showMoreView.isHidden = true
    }
    func set(bidId: String) {
        self.bidId = bidId
        self.refresh()
    }
    func add(bid: LastBidModel) {
        self.items.insert(bid, at: 0)
        self.tableView.reloadData()
    }
    
    //MARK: - Encapsulation -
    private func refresh() {
        self.currentPage = 1
        self.isLast = false
        self.items = []
        self.tableView.reloadData()
        self.getMoreData { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    
    //MARK: - Action -
    @IBAction private func showAllBidsTapped() {
        let vc = AllLastBidsVC.create(items: self.items, delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.viewContainingController?.present(nav, animated: true)
    }
    
}
extension LastBidsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isMoreThree = self.items.count > 3
        self.showMoreView.isHidden = isMoreThree ? false : true
        return  isMoreThree ? 3 : self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LastBidsCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.set(
            image: item.avatar,
            name: item.name,
            date: item.createAt,
            bid: item.price?.stringValue?.toPrice(),
            isWinner: item.isWinner
        )
        return cell
    }
}

//MARK: - Delegation -
extension LastBidsView: LoadMoreLastBids {
    func getMoreData(_ completion: @escaping ([LastBidModel]) -> ()) {
        guard let bidId = self.bidId, !self.isLast else {return}
        AuctionRouter.customersBid(bidId: bidId, page: self.currentPage).send { [weak self] (response: APIGenericResponse<LastBidResponse>) in
            guard let self = self else {return}
            if currentPage == 1 {
                lastBidder?(response.data?.customerBids.first?.viewerId)
            }
            self.isLast = (response.paginate?.currentPage == response.paginate?.lastPage)
            self.currentPage = response.paginate?.currentPage ?? 1
            self.items += response.data?.customerBids ?? []
            completion(response.data?.customerBids ?? [])
        }
    }
}

//MARK: - Networking -
extension LastBidsView {
    
}

struct LastBidResponse: Codable {
    let countBids: Int?
    let customerBids: [LastBidModel]
}



struct LastBidModel: Codable {
    let viewerId: String?
    let currency: String?
    let price: Numerical?
    let name: String?
    let avatar: String?
    let createAt: String?
    let isWinner: Bool?
}
