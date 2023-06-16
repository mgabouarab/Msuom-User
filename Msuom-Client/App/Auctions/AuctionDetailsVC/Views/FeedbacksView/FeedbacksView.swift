//
//  FeedbacksView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 16/05/2023.
//

import UIKit

struct FeedbackModel: Codable {
    
    let avatar: String?
    var comment: String?
    let createAt: String?
    let id: String?
    let owner: Bool?
    var rating: Numerical?
    let streamId: String?
    let user_id: String?
    let userName: String?
    let name: String?
    
}


class FeedbacksView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: TableViewContentSized!
    @IBOutlet weak private var showMoreView: UIView!
    @IBOutlet weak private var addButton: UIButton!
    
    //MARK: - Properties -
    private var items: [FeedbackModel] = [] {
        didSet {
            self.isHidden = items.isEmpty && !enableAddComment
        }
    }
    private var bidId: String?
    private var streamId: String?
    private var currentPage: Int = 1
    private var isLast: Bool = false
    
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
        let nib = UINib(nibName: "FeedbacksView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.tableView.dataSource = self
        self.tableView.register(cellType: FeedbackCell.self)
        self.showMoreView.isHidden = true
    }
    func set(bidId: String, streamId: String) {
        self.bidId = bidId
        self.streamId = streamId
        self.refresh()
    }
    var enableAddComment: Bool {
        set {
            addButton.isHidden = !newValue
        }
        get {
            !addButton.isHidden
        }
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
        let vc = AllFeedbacksVC.create(items: self.items, delegate: self)
        let nav = BaseNav(rootViewController: vc)
        self.viewContainingController?.present(nav, animated: true)
    }
    @IBAction private func addCommentButtonPressed() {
        guard let id = self.bidId, let streamId = self.streamId else {return}
        let vc = FeedbackVC.create(
            delegate: self,
            titleLocalizedKey: "Add Comment".localized,
            placeholderLocalizedKey: nil,
            type: .add(bidId: id, streamId: streamId)
        )
        self.viewContainingController?.present(vc, animated: false)
    }
    
}
extension FeedbacksView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isMoreThree = self.items.count > 3
        self.showMoreView.isHidden = isMoreThree ? false : true
        return  isMoreThree ? 3 : self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FeedbackCell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        cell.deleteAction = { [weak self] in
            guard let self = self, let id = item.id else {return}
            self.delete(commentId: id)
        }
        cell.editAction = { [weak self] in
            guard let self = self else {return}
            let vc = FeedbackVC.create(
                delegate: self,
                titleLocalizedKey: "Edit Comment".localized,
                placeholderLocalizedKey: nil,
                type: .edit(feedback: item, delegate: self)
            )
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            window?.topViewController()?.present(vc, animated: false)
        }
        return cell
    }
}



//MARK: - Networking -
extension FeedbacksView {
    func edit(comment: String, rate: Int, commentId: String) {
        AppIndicator.shared.show(isGif: false)
        AuctionRouter.edit(comment: comment, rate: rate, commentId: commentId).send {[weak self] (response: APIGenericResponse<FeedbackModel>) in
            guard let self = self else {return}
            guard let index = self.items.firstIndex(where: {$0.id == commentId}) else {return}
            self.items[index].comment = response.data?.comment
            self.items[index].rating = response.data?.rating
            self.tableView.reloadData()
        }
    }
    func delete(commentId: String) {
        (self.parentContainerViewController as? BaseVC)?.showDeleteAlert {
            AppIndicator.shared.show(isGif: false)
            AuctionRouter.delete(commentId: commentId).send { [weak self] (response: APIGlobalResponse) in
                guard let self = self else {return}
                guard let index = self.items.firstIndex(where: {$0.id == commentId}) else {return}
                self.items.remove(at: index)
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Delegation -
extension FeedbacksView: LoadMoreFeedbacks {
    func getMoreData(_ completion: @escaping ([FeedbackModel]) -> ()) {
        guard let streamId = self.streamId, !self.isLast else {return}
        AuctionRouter.commentsStream(streamId: streamId, page: self.currentPage).send { [weak self] (response: APIGenericResponse<[FeedbackModel]>) in
            guard let self = self else {return}
            self.isLast = (response.paginate?.currentPage == response.paginate?.lastPage)
            self.currentPage = response.paginate?.currentPage ?? 1
            self.items += response.data ?? []
            completion(self.items)
        }
    }
    func delete(id: String, _ completion: @escaping ([FeedbackModel]) -> ()) {
        AuctionRouter.delete(commentId: id).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            guard let index = self.items.firstIndex(where: {$0.id == id}) else {return}
            self.items.remove(at: index)
            self.tableView.reloadData()
            completion(self.items)
        }
    }
    func edit(feedback: FeedbackModel, _ completion: @escaping ([FeedbackModel]) -> ()) {
        guard let comment = feedback.comment, let rate = feedback.rating?.doubleValue , let commentId = feedback.id else {return}
        AppIndicator.shared.show(isGif: false)
        AuctionRouter.edit(comment: comment, rate: Int(rate), commentId: commentId).send {[weak self] (response: APIGenericResponse<FeedbackModel>) in
            guard let self = self else {return}
            guard let index = self.items.firstIndex(where: {$0.id == commentId}) else {return}
            self.items[index].comment = response.data?.comment
            self.items[index].rating = response.data?.rating
            self.tableView.reloadData()
            completion(self.items)
        }
    }
}
extension FeedbacksView: TextViewVCDelegate {
    func didWrite(feedback comment: FeedbackModel?) {
        guard let comment = comment else {return}
        self.items.insert(comment, at: 0)
        self.tableView.reloadData()
    }
    func getValidationMessage() -> String {
        return "Please enter your comment".localized
    }
}
extension FeedbacksView: FeedbackEditDelegate {
    func edit(feedback: FeedbackModel) {
        guard let comment = feedback.comment, let rate = feedback.rating?.doubleValue , let commentId = feedback.id else {return}
        self.edit(comment: comment, rate: Int(rate), commentId: commentId)
    }
}
