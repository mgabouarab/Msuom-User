//
//  FQAVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 29/01/2023.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class FQAVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private var mainItems: [FQAModel] = []
    private var items: [FQAModel] = []
    
    
    //MARK: - Creation -
    static func create() -> FQAVC {
        let vc = AppStoryboards.more.instantiate(FQAVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.getFQA()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Help".localized)
//        self.searchTextField.delegate = self
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    
    @IBAction func searchValueChanged(_ sender: UITextField) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchButtonPressed), object: nil)
        perform(#selector(self.searchButtonPressed), with: nil, afterDelay:
                    1)
        
    }
    
    @IBAction private func searchButtonPressed() {
        if let word = self.searchTextField.text, !word.isEmpty {
            self.items = self.mainItems.filter({$0.question?.contains(word) == true})
            self.tableView.animateToTop()
        } else {
            self.items = mainItems
            self.tableView.animateToTop()
        }
    }
    
}


//MARK: - Start Of TableView -
extension FQAVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: FQACell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension FQAVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FQACell.self, for: indexPath)
        let item = self.items[indexPath.row]
        cell.configureWith(data: item)
        return cell
    }
}
extension FQAVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.items[indexPath.row].isOpen.toggleOptional()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension FQAVC {
    private func getFQA() {
        self.showIndicator()
        SettingRouter.fqs.send { [weak self] (response: APIGenericResponse<[FQAModel]>) in
            guard let self = self else {return}
            self.mainItems = response.data ?? []
            self.items = response.data ?? []
            self.tableView.reloadData()
        }
    }
}

//MARK: - Routes -
extension FQAVC {
    
}
