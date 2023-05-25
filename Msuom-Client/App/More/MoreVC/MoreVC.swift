//
//  MoreVC.swift
//  Msuom
//
//  Created by MGAbouarab on 26/10/2022.
//
//  Template by MGAbouarab®

import UIKit


//MARK: - ViewController
class MoreVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties -
    private lazy var items: [MoreModel] = []
    
    
    //MARK: - Creation -
    static func create() -> MoreVC {
        let vc = AppStoryboards.more.instantiate(MoreVC.self)
        return vc
    }
    
    // MARK: - UIViewController Events -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.setupTableView()
        self.tableView.reloadData()
        self.handleItemsDependingOnUserLoginStatus()
        self.addObservers()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.setLeading(title: "More".localized)
        self.setNotificationButton()
    }
    
    //MARK: - Logic Methods -
    private func accountInfoSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "profileIcon",
                title: "Profile".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToProfile()
                }
            ),
            MoreItem(
                iconName: "profileAuction",
                title: "My Auctions".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToMyAuctions()
                }
            ),
            MoreItem(
                iconName: "profileWallet",
                title: "Wallet".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToWallet()
                }
            ),
            MoreItem(
                iconName: "profileAds",
                title: "My Ads".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToMyAds()
                }
            ),
            MoreItem(
                iconName: "profileFav",
                title: "My Favourite".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToFavourite()
                }
            ),
            MoreItem(
                iconName: "reports",
                title: "Complains".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToComplain()
                }
            ),
            MoreItem(
                iconName: "evaluateCar",
                title: "Evaluate Car".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToEvaluateCar()
                }
            )
        ]
    }
    private func generalSettingsSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "langIcon",
                title: "Language Settings".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToLanguage()
                }
            )
        ]
    }
    private func generalInfoSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "requestHelp",
                title: "Help".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.gotoHelp()
                }
            ),
            MoreItem(
                iconName: "profileAds",
                title: "Car show".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToCarShow()
                }
            ),
            MoreItem(
                iconName: "profileOffers",
                title: "Offers".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToOffers()
                }
            ),
            MoreItem(
                iconName: "profileGarag",
                title: "Car Auction".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToCarAuction()
                }
            ),
            MoreItem(
                iconName: "termsIcon",
                title: "Terms and Conditions".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToInfo(type: .terms)
                }
            ),
            MoreItem(
                iconName: "aboutUsIcon",
                title: "About Msuom".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToAbout()
                }
            ),
            MoreItem(
                iconName: "contactusIcon",
                title: "Contact us".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToContactUs()
                }
            )
        ]
    }
    private func deleteAccountSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "deleteAccountIcon",
                title: "Delete Account".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToDeleteAccount()
                },
                color: Theme.colors.errorColor.withAlphaComponent(0.1),
                hasArrow: false
            )
        ]
    }
    private func logoutAccountSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "logoutIcon",
                title: "Logout".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToLogout()
                },
                color: Theme.colors.errorColor.withAlphaComponent(0.1),
                hasArrow: false
            )
        ]
    }
    private func loginAccountSectionItems() -> [MoreItem] {
        return [
            MoreItem(
                iconName: "loginIcon",
                title: "Login".localized,
                description: "",
                action: { [weak self] in
                    guard let self = self else {return}
                    self.goToLogin()
                },
                color: Theme.colors.mainColor.withAlphaComponent(0.1),
                hasArrow: false
            )
        ]
    }
    
    //MARK: - Logic -
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleItemsDependingOnUserLoginStatus), name: .isLoginChanged, object: nil)
    }
    @objc private func handleItemsDependingOnUserLoginStatus() {
        self.items = UserDefaults.isLogin ? [
            MoreModel(title: "Welcome".localized + ", \(UserDefaults.user?.name ?? "")", items: self.accountInfoSectionItems()),
            MoreModel(title: "General Settings".localized, items: self.generalSettingsSectionItems()),
            MoreModel(title: "About Msuom".localized, items: self.generalInfoSectionItems()),
            MoreModel(title: nil, items: self.deleteAccountSectionItems()),
            MoreModel(title: nil, items: self.logoutAccountSectionItems()),
        ] : [
            MoreModel(title: "General Settings".localized, items: self.generalSettingsSectionItems()),
            MoreModel(title: "About Msuom".localized, items: self.generalInfoSectionItems()),
            MoreModel(title: nil, items: self.loginAccountSectionItems()),
        ]
        self.tableView.reloadData()
    }
    
}


//MARK: - Start Of TableView -
extension MoreVC {
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: MoreCell.self, bundle: nil)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension MoreVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MoreCell.self, for: indexPath)
        let item = self.items[indexPath.section].items[indexPath.row]
        if self.items[indexPath.section].items.count == 1 {
            cell.contentView.layer.cornerRadius = 16
        } else if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == self.items[indexPath.section].items.count - 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.contentView.layer.cornerRadius = 0
        }
        
        cell.configureWith(data: item)
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].title
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = self.items[section].title {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 12)
            label.textColor = Theme.colors.secondryDarkFontColor
            headerView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 20).isActive = true
            label.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            return headerView
        } else {
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.items[section].headerHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
extension MoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.items[indexPath.section].items[indexPath.row].action?()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - End Of TableView -


//MARK: - Networking -
extension MoreVC {
    
}

//MARK: - Routes -
extension MoreVC {
    private func goToMyAuctions() {
        let vc = MyAuctionsVC.create()
        self.push(vc)
    }
    private func goToWallet() {
        let vc = WalletVC.create()
        self.push(vc)
    }
    private func goToMyAds() {
        let vc = MyCarsVC.create()
        self.push(vc)
    }
    private func goToFavourite() {
        let vc = MyFavouriteVC.create()
        self.push(vc)
    }
    private func goToComplain() {
        let vc = ReportsVC.create()
        self.push(vc)
    }
    private func goToEvaluateCar() {
        let vc = CarEvaluationVC.create()
        self.push(vc)
    }
    private func gotoHelp() {
        let vc = FQAVC.create()
        self.push(vc)
    }
    private func goToCarShow() {
        let vc = ProvidersVC.create()
        self.push(vc)
    }
    private func goToOffers() {
        let vc = OffersVC.create()
        self.push(vc)
    }
    private func goToCarAuction() {
        let vc = HarajVC.create()
        self.push(vc)
    }
    private func goToProfile() {
        let vc = EditProfileVC.create()
        self.push(vc)
    }
    private func goToLanguage() {
        let vc = InAppLanguageVC.create()
        self.push(vc)
    }
    private func goToAbout() {
        let vc = AboutVC.create()
        self.push(vc)
    }
    private func goToLogin() {
        self.presentLogin()
    }
    private func goToInfo(type: InfoVC.InfoType) {
        let vc = InfoVC.create(type: type)
        self.push(vc)
    }
    private func goToContactUs() {
        let vc = ContactUsVC.create()
        self.push(vc)
    }
    private func goToLogout() {
        self.showLoginAlert {
            
            self.showIndicator()
            AuthRouter.signOut.send { [weak self] (response: APIGlobalResponse) in
                guard let self = self else {return}
                UserDefaults.isLogin = false
                UserDefaults.accessToken = nil
                UserDefaults.user = nil
                self.presentLogin()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showSuccessAlert(message: response.message)
                }
            }
        }
    }
    private func goToDeleteAccount() {
        self.showDeleteAccountAlert {
            AuthRouter.deleteAccount.send { [weak self] (response: APIGlobalResponse) in
                guard let self = self else {return}
                UserDefaults.isLogin = false
                UserDefaults.accessToken = nil
                UserDefaults.user = nil
                self.presentLogin()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showSuccessAlert(message: response.message)
                }
            }
        }
    }
    
}
