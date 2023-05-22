//
//  AllFeedbacksVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//
//  Template by MGAbouarab®

import UIKit

protocol LoadMoreFeedbacks {
    func getMoreData(_ completion: @escaping ([FeedbackModel]) -> ())
    func delete(id: String, _ completion: @escaping ([FeedbackModel]) -> ())
    func edit(feedback: FeedbackModel, _ completion: @escaping ([FeedbackModel]) -> ())
}

typealias AllFeedbacksDelegate = (LoadMoreFeedbacks & TextViewVCDelegate)

//MARK: - ViewController
class AllFeedbacksVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var items: [FeedbackModel] = []
    private var delegate: AllFeedbacksDelegate?
    
    //MARK: - Creation -
    static func create(items: [FeedbackModel], delegate: AllFeedbacksDelegate?) -> AllFeedbacksVC {
        let vc = AppStoryboards.auctions.instantiate(AllFeedbacksVC.self)
        vc.items = items
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "Comments".localized
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
}


//MARK: - Start Of TableView -
extension AllFeedbacksVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: FeedbackCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension AllFeedbacksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FeedbackCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        cell.deleteAction = { [weak self] in
            guard let self = self, let id = item.id else {return}
            self.delegate?.delete(id: id, { [weak self] items in
                self?.items = items
                self?.tableView.reloadData()
            })
        }
        cell.editAction = { [weak self] in
            guard let self = self else {return}
            guard let delegate = self.delegate else {return}
            let vc = FeedbackVC.create(
                delegate: delegate,
                titleLocalizedKey: "Edit Comment".localized,
                placeholderLocalizedKey: nil,
                type: .edit(feedback: item, delegate: self)
            )
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.topViewController()?.present(vc, animated: false)
            
//            self.delegate?.edit(feedback: item, { [weak self] items in
//                self?.items = items
//                self?.tableView.reloadData()
//            })
        }
        return cell
    }
}
extension AllFeedbacksVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.delegate?.getMoreData { [weak self] data in
            guard let self = self else {return}
            self.items = data
            self.tableView.reloadData()
        }
    }
}
//MARK: - End Of TableView -


//MARK: - Networking -
extension AllFeedbacksVC {
    
}

//MARK: - Routes -
extension AllFeedbacksVC {
    
}

//MARK: - Delegation -
extension AllFeedbacksVC: FeedbackEditDelegate {
    func edit(feedback: FeedbackModel) {
        self.delegate?.edit(feedback: feedback) { [weak self] data in
            guard let self = self else {return}
            self.items = data
            self.tableView.reloadData()
        }
    }
}
