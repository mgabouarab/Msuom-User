//
//  AuctionsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/11/2022.
//

import UIKit


//MARK: - ViewController
class AuctionsVC: BaseVC {
    
    private enum AuctionTimeType: String {
        case current
        case coming
    }
    
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var cityTextFieldView: DropDownTextFieldView!
    
    //MARK: - Properties -
    private var streams: [BidStream] = []
    private var bids: [BidDetails] = []
    private var cityArray: [Cities] = []
    private var cityFilterArray: [DropDownItem] = []
    private var selectedType: AuctionTimeType = .current
    private var selectedCityId: String?
    
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
        self.configureInitialData()
        self.cityTextFieldView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setLeading(title: "Auctions".localized)
        self.setMapButton()
        self.segmentedControl.setupSegmented(mainColor: Theme.colors.secondaryColor, font: .systemFont(ofSize: 16), normalColor: Theme.colors.secondaryColor, selectedColor: Theme.colors.whiteColor)
        self.segmentedControl.setTitle("Current_bids".localized, forSegmentAt: 0)
        self.segmentedControl.setTitle("Next_bids".localized, forSegmentAt: 1)
    }
    private func configureInitialData() {
        
        if let data = UserDefaults.addCarData {
            self.cityFilterArray = data.cities
        } else {
            self.getAttributes()
        }
        
    }
    func setMapButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "mapIcon"), for: .normal)
        button.addTarget(self, action: #selector(self.mapButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func mapButtonPressed() {
        let vc = AuctionCitiesVC.create(cities: self.cityArray, delegate: self)
        self.push(vc)
    }
    @objc func refresh() {
        self.streams = []
        self.bids = []
        self.cityArray = []
        self.selectedCityId = nil
        self.cityTextFieldView.set(value: nil)
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getAuctionsData()
    }
    func refresh(cityId: String? = nil) {
        self.streams = []
        self.bids = []
        self.cityArray = []
        self.selectedCityId = cityId
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
        self.getAuctionsData()
    }
    @objc func sectionZeroSeeAll() {
        let vc = ShowAllProvidersVC.create(type: selectedType.rawValue, topTitle: selectedType == .current ? "currentAuctions".localized : "nextAuctions".localized)
        self.push(vc)
    }
    @objc func sectionOneSeeAll() {
        
    }
    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedType = .current
            self.selectedCityId = nil
        case 1:
            self.selectedType = .coming
            self.selectedCityId = nil
        default:
            return
        }
        self.refresh()
    }
    
}


//MARK: - Start Of TableView -
extension AuctionsVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: AuctionCell.self, bundle: nil)
        self.tableView.register(cellType: AuctionsStoreCell.self, bundle: nil)
        self.tableView.register(cellType: ComingSoonAuctionCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.addRefresh(action: #selector(self.refresh))
    }
}
extension AuctionsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        func spacer() -> UIView {
            let spacer = UIImageView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.widthAnchor.constraint(equalToConstant: 20).isActive = true
            return spacer
        }
        
        switch section {
        case 0:
            if !self.streams.isEmpty {
                
                let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
                
                let titleLabel = UILabel()
                titleLabel.font = .systemFont(ofSize: 16)
                titleLabel.textColor = Theme.colors.mainDarkFontColor
                titleLabel.text = "Stores".localized
                
//                let allButton = UIButton()
//                allButton.setTitle("See all".localized, for: .normal)
//                allButton.addTarget(self, action: #selector(sectionZeroSeeAll), for: .touchUpInside)
//                allButton.setTitleColor(Theme.colors.mainColor, for: .normal)
                
                stack.addArrangedSubview(spacer())
                stack.addArrangedSubview(titleLabel)
                stack.addArrangedSubview(UIImageView())
//                stack.addArrangedSubview(allButton)
                stack.addArrangedSubview(spacer())
                
                return stack
            } else {
                return nil
            }
        case 1:
            if !self.bids.isEmpty {
                let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
                
                let titleLabel = UILabel()
                titleLabel.font = .systemFont(ofSize: 16)
                titleLabel.textColor = Theme.colors.mainDarkFontColor
                titleLabel.text = "Bids".localized
                
//                let allButton = UIButton()
//                allButton.setTitle("See all".localized, for: .normal)
//                allButton.addTarget(self, action: #selector(sectionOneSeeAll), for: .touchUpInside)
//                allButton.setTitleColor(Theme.colors.mainColor, for: .normal)
                
                stack.addArrangedSubview(spacer())
                stack.addArrangedSubview(titleLabel)
                stack.addArrangedSubview(UIImageView())
//                stack.addArrangedSubview(allButton)
                stack.addArrangedSubview(spacer())
                
                return stack
                
            } else {
                return nil
            }
        default:
            return nil
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setPlaceholder(isEmpty: self.bids.isEmpty && self.streams.isEmpty)
        switch section {
        case 0:
            return self.streams.count
        case 1:
            return self.bids.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            let item = self.streams[indexPath.row]
            let cell = tableView.dequeueReusableCell(with: AuctionsStoreCell.self, for: indexPath)
            
            let time = (item.isRunning == true) ? ((item.endDate ?? "") + " " + (item.endTime ?? "")) : ((item.startDate ?? "") + " " + (item.startTime ?? ""))
            
            cell.set(image: item.image, name: item.name, count: item.carCount, address: item.cityName, time: time)
            return cell
        case 1:
            let item = self.bids[indexPath.row]
            let cell = tableView.dequeueReusableCell(with: ComingSoonAuctionCell.self, for: indexPath)
            cell.configureWith(details: item.homeComingSoonCellData())
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
}
extension AuctionsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let providerId = self.streams[indexPath.row].providerId else {return}
            let vc = ProviderStreamsVC.create(type: self.selectedType.rawValue, providerId: providerId, topTitle: selectedType == .current ? "currentAuctions".localized : "nextAuctions".localized)
            self.push(vc)
        case 1:
            guard let id = self.bids[indexPath.row].id else {return}
            let vc = AuctionDetailsVC.create(id: id)
            self.push(vc)
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension AuctionsVC {
    private func getAuctionsData() {
        self.showIndicator()
        AuctionRouter.listOfComingOrCurrentBids(type: self.selectedType.rawValue, cityId: self.selectedCityId).send { [weak self] (response: APIGenericResponse<AuctionsModel>) in
            guard let self = self else {return}
            self.streams = response.data?.streams ?? []
            self.bids = response.data?.bids ?? []
            self.cityArray = response.data?.cities ?? []
            self.tableView.reloadData()
        }
    }
    private func getAttributes() {
        self.showIndicator()
        CarRouter.addCarData.send { [weak self] (response: APIGenericResponse<AddCarData>) in
            guard let self = self else {return}
            self.hideIndicator()
            UserDefaults.addCarData = response.data
            self.configureInitialData()
        }
    }
}

//MARK: - Routes -
extension AuctionsVC {
    
}

//MARK: - Delegate -
extension AuctionsVC: DropDownTextFieldViewDelegate {
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem] {
        switch textFieldView {
        case cityTextFieldView: return self.cityFilterArray
        default: return []
        }
    }
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView) {
        switch textFieldView {
        case cityTextFieldView:
            self.refresh(cityId: item.id)
        default:
            return
        }
    }
}


struct AuctionsModel: Codable {
    let streams: [BidStream]
    let bids: [BidDetails]
    let cities: [Cities]
}

struct ProviderStreamsModel: Codable {
    let streams: [BidStream]
    let cities: [Cities]
}

extension AuctionsVC: AuctionCitiesProtocol {
    func updateWith(cityId: String?) {
        self.selectedCityId = cityId
        
        if let city = self.cityFilterArray.first(where: {$0.id == cityId}) {
            self.cityTextFieldView.set(value: city)
        }
        self.refresh(cityId: cityId)
    }
}
