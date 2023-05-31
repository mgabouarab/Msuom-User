//
//  CarDetailsVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 27/11/2022.
//
//  Template by MGAbouarab®


import UIKit
import FirebaseDynamicLinks

class CarDetailsVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var containerStackView: UIStackView!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var sliderView: SliderView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var sellTypeLabel: UILabel!
    @IBOutlet weak private var sellTypeDescriptionLabel: UILabel!
    @IBOutlet weak private var sellerNameLabel: UILabel!
    @IBOutlet weak private var sellerImageView: UIImageView!
    @IBOutlet weak private var sellerAddressLabel: UILabel!
    @IBOutlet weak private var markLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var incomingLabel: UILabel!
    @IBOutlet weak private var categoryLabel: UILabel!
    @IBOutlet weak private var gearTypeLabel: UILabel!
    @IBOutlet weak private var pushTypeLabel: UILabel!
    @IBOutlet weak private var cylinderCountLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var walkedLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var yearLabel: UILabel!
    @IBOutlet weak private var fuelTypeLabel: UILabel!
    @IBOutlet weak private var engineSizeLabel: UILabel!
    @IBOutlet weak private var colorLabel: UILabel!
    @IBOutlet weak private var specificationLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var actionsContainerView: UIView!
    @IBOutlet weak private var guaranteeLabel: UILabel!
    @IBOutlet weak private var callView: UIView!
    
    //MARK: - Properties -
    private var id: String!
    private var details: Car.Details?
    private var car: Car?
    private var ownerPhoneNo: String?
    
    //MARK: - Creation -
    static func create(id: String) -> CarDetailsVC {
        let vc = AppStoryboards.cars.instantiate(CarDetailsVC.self)
        vc.hidesBottomBarWhenPushed = true
        vc.id = id
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDetailsForCar(id: self.id)
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.addBackButtonWith(title: "Car Details".localized)
        self.containerStackView.isHidden = true
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(self.openLocationOnMap))
        self.sellerAddressLabel.addGestureRecognizer(locationTap)
        self.actionsContainerView.clipsToBounds = false
        self.actionsContainerView.addShadow()
    }
    private func setCar(details: Car.Details) {
        self.details = details
        self.sliderView.set(images: details.images.map({SliderView.SliderItem(image: $0, title: nil, description: nil)}))
        self.nameLabel.text = details.name
        self.priceLabel.text = details.price
        self.sellTypeLabel.text = details.sellType
        self.sellTypeDescriptionLabel.text = details.sellTypeDescription
        self.sellerNameLabel.text = details.sellerName
        self.sellerImageView.setWith(string: details.sellerImage)
        self.sellerAddressLabel.text = details.sellerAddress
        self.markLabel.text = details.mark
        self.typeLabel.text = details.type
        self.incomingLabel.text = details.incoming
        self.categoryLabel.text = details.category
        self.gearTypeLabel.text = details.gearType
        self.pushTypeLabel.text = details.pushType
        self.cylinderCountLabel.text = details.cylinderCount
        self.statusLabel.text = details.status
        self.walkedLabel.text = details.walked
        self.cityLabel.text = details.city
        self.yearLabel.text = details.year
        self.fuelTypeLabel.text = details.fuelType
        self.engineSizeLabel.text = details.engineSize
        self.colorLabel.text = details.color
        self.colorLabel.textColor = UIColor(hex: details.hexColor)
        self.specificationLabel.text = details.specification
        self.descriptionLabel.text = details.description
        self.containerStackView.isHidden = false
        self.actionsContainerView.isHidden = !details.isMyCar
        self.guaranteeLabel.text = details.refundableText
        self.ownerPhoneNo = details.ownerPhoneNo
        
        if details.isMyCar {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shareButton"), style: .plain, target: self, action: #selector(self.openShareSheet))
            self.callView.isHidden = true
        } else {
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(
                    image: UIImage(named: "shareButton"),
                    style: .plain,
                    target: self,
                    action: #selector(self.openShareSheet)
                ),
                UIBarButtonItem(
                    image: UIImage(named: details.isFav ? "favFill" : "unFav"),
                    style: .plain,
                    target: self,
                    action: #selector(self.toggleFav)
                )
            ]
            self.callView.isHidden = false
        }
        
        
    }
    
    //MARK: - Logic Methods -
    
    
    //MARK: - Actions -
    @objc private func openLocationOnMap() {
        if let latitude = self.details?.latitude, let longitude = self.details?.longitude {
            AppHelper.openLocationOnMap(lat: latitude, long: longitude)
        }
    }
    @objc private func openShareSheet() {
        guard let link = URL(string: "https://maseom.page.link/advertise/\(self.id ?? "")") else { return }

        let dynamicLinksDomainURIPrefix = "https://maseom.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.aait.Msuom-Client")
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.aait.mseom_user")
        let socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()

        socialMetaTagParameters.title = self.nameLabel.text
        socialMetaTagParameters.descriptionText = self.details?.name
        socialMetaTagParameters.imageURL = URL(string: self.details?.images.first ?? "")

        linkBuilder?.socialMetaTagParameters = socialMetaTagParameters
        linkBuilder?.shorten(completion: { shorten, _, _ in
            guard let shorten = shorten else {return}
            let activityController = UIActivityViewController(activityItems: [shorten], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        })
    }
    @objc private func toggleFav() {
        
        guard UserDefaults.isLogin else {
            
            self.showLogoutAlert { [weak self] in
                self?.presentLogin()
            }
            
            return
        }
        
        self.showIndicator()
        CarRouter.toggleAdFav(id: self.id).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.getDetailsForCar(id: self.id)
        }
    }
    @IBAction private func deleteButtonPressed() {
        self.showDeleteAlert { [weak self] in
            guard let self = self else {return}
            self.delete(carId: self.id)
        }
    }
    @IBAction private func editButtonPressed() {
        guard let car = self.car else {return}
        let vc = AddCarVC.create(operationType: .edit(car: car))
        self.push(vc)
    }
    @IBAction private func callButtonPressed() {
        PhoneAction.call(number: self.ownerPhoneNo)
    }
    
}

//MARK: - Networking -
extension CarDetailsVC {
    private func getDetailsForCar(id: String) {
        self.showIndicator()
        CarRouter.carDetails(id: id).send { [weak self] (response: APIGenericResponse<Car>) in
            guard let self = self else {return}
            self.hideIndicator()
            if let car = response.data {
                self.car = car
                self.setCar(details: car.detailsData())
            }
        }
    }
    private func delete(carId: String) {
        self.showIndicator()
        CarRouter.deleteCar(id: carId).send { [weak self] (response: APIGlobalResponse) in
            guard let self = self else {return}
            self.showSuccessAlert(message: response.message)
            self.pop()
        }
    }
}

//MARK: - Routes -
extension CarDetailsVC {
    
}
