//
//  NextAuctionsView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//

import UIKit

class NextAuctionsView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: TableViewContentSized!

    //MARK: - Properties -
    private var items: [BidDetails] = [] {
        didSet {
            self.isHidden = items.isEmpty
        }
    }
    var tapAction: ((String)->())?
    
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
        let nib = UINib(nibName: "NextAuctionsView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: ComingSoonAuctionCell.self)
    }
    func set(items: [BidDetails]) {
        self.items = items
        self.tableView.reloadData()
    }
    
    //MARK: - Encapsulation -
    
    
    //MARK: - Action -
    
}
extension NextAuctionsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(details: item.homeComingSoonCellData())
        return cell
    }
}

extension NextAuctionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.items[indexPath.row].id else {return}
        self.tapAction?(id)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
