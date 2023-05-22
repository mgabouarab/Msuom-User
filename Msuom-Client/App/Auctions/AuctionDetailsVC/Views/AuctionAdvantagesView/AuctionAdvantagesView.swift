//
//  AuctionAdvantagesView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class AuctionAdvantagesView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [Advantages] = []
    
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
        let nib = UINib(nibName: "AuctionAdvantagesView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AuctionAdvantagesCell.self)
    }
    func set(items: [Advantages]) {
        self.items = items  
        self.tableView.reloadData()
    }
    
    //MARK: - Encapsulation -
    
    
    
    //MARK: - Action -
    
}

extension AuctionAdvantagesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AuctionAdvantagesCell.self, for: indexPath)
        cell.setup(advantages: self.items[indexPath.row])
        return cell
    }
    
    
}
extension AuctionAdvantagesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.items[indexPath.row].isSelected.toggleOptional()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
