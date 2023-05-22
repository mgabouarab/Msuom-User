//
//  CarInfoView.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 15/05/2023.
//

import UIKit

class CarInfoView: UIView {
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var infoContainerView: UIView!
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
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var specificationButton: UIButton!
    @IBOutlet weak private var imagesButton: UIButton!
    @IBOutlet weak private var actionStack: UIStackView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    //MARK: - Properties -
    private var items: [String] = []
    private var isSpecification: Bool = true {
        didSet {
            if isSpecification {
                self.specificationButton.backgroundColor = Theme.colors.secondaryColor
                self.imagesButton.backgroundColor = .clear
                self.specificationButton.setTitleColor(Theme.colors.whiteColor, for: .normal)
                self.imagesButton.setTitleColor(Theme.colors.secondryDarkFontColor, for: .normal)
                self.infoContainerView.isHidden = false
                self.collectionView.isHidden = true
            } else {
                self.specificationButton.backgroundColor = .clear
                self.imagesButton.backgroundColor = Theme.colors.secondaryColor
                self.specificationButton.setTitleColor(Theme.colors.secondryDarkFontColor, for: .normal)
                self.imagesButton.setTitleColor(Theme.colors.whiteColor, for: .normal)
                self.infoContainerView.isHidden = true
                self.collectionView.isHidden = false
            }
        }
    }
    
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
        let nib = UINib(nibName: "CarInfoView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    //MARK: - Design -
    private func setupInitialDesign() {
        self.setupCollectionView()
    }
    func set(info details: BidDetails) {
        self.markLabel.text = details.brandName
        self.typeLabel.text = details.typeName
        self.incomingLabel.text = details.importedCarName
        self.categoryLabel.text = details.categoryName
        self.gearTypeLabel.text = details.transmissionGearName
        self.pushTypeLabel.text = details.vehicleTypeName
        self.cylinderCountLabel.text = details.cylinders
        self.statusLabel.text = details.statusName
        self.walkedLabel.text = details.walkway
        self.cityLabel.text = details.cityName
        self.yearLabel.text = details.year
        self.fuelTypeLabel.text = details.fuelTypeName
        self.engineSizeLabel.text = details.engineSize
        self.colorLabel.text = details.colorName
        self.specificationLabel.text = details.specificationName
        self.items = details.arrImage ?? []
        self.collectionView.reloadData()
        self.isSpecification = true
        
        self.actionStack.isHidden = details.type != "live"
        self.titleLabel.isHidden = details.type == "live"
        
    }
    
    
    //MARK: - Encapsulation -
    
    
    //MARK: - Action -
    @IBAction private func specificationButtonPressed() {
        self.isSpecification = true
    }
    @IBAction private func imagesButtonPressed() {
        self.isSpecification = false
    }
    
}

//MARK: - CollectionView -

extension CarInfoView {
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: ImageViewerCell.self)
    }
}

extension CarInfoView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ImageViewerCell.self, for: indexPath)
        cell.setupCell(image: ImageViewerItem(urlImage: self.items[indexPath.row], dataImage: nil), enableZoom: false)
        return cell
    }
}

extension CarInfoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageViewerVC.create(images: self.items.map({ImageViewerItem(urlImage: $0, dataImage: nil)}), selectedIndex: indexPath)
        self.parentContainerViewController?.present(vc, animated: true)
    }
}

extension CarInfoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
    }
}
