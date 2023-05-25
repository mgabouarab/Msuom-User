//
//  SelectImageView.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 25/05/2023.
//

import UIKit

class SelectImageView: UIView {
    
    struct ImageModel {
        let data: Data?
        let url: String?
        let id: Int?
        
        init(data: Data) {
            self.data = data
            self.url = nil
            self.id = nil
        }
        init(url: String, id: Int) {
            self.data = nil
            self.url = url
            self.id = id
        }
        
    }
    
    //MARK: - IBOutlet -
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    //MARK: - Properties -
    @IBInspectable
    var titleLocalizedKey: String? {
        didSet {
            self.titleLabel.xibLocKey = titleLocalizedKey
        }
    }
    
    private var items: [ImageModel] = []
    private var deletedIds: [Int] = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: - Initializer -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupCollectionView()
        self.setupInitialDesign()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupCollectionView()
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
        let nib = UINib(nibName: "SelectImageView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    
    private func setupInitialDesign() {
        
    }
    
    //MARK: - Logic -
    private func delete(at index: Int) {
        let item = self.items[index]
        if let id = item.id {
            self.deletedIds.append(id)
        }
        self.items.remove(at: index)
        self.collectionView.reloadData()
    }
    func getImagesData() -> [Data] {
        self.items.compactMap({$0.data})
    }
    
    //MARK: - Actions -
    @IBAction private func selectImageButtonPressed() {
        let picker = MultipleMediaPicker(limit: 5)
        picker.didPickMedia { [weak self] media in
            guard let self = self else {return}
            for item in media {
                self.items.append(ImageModel(data: item.mediaData))
                self.collectionView.reloadData()
            }
        }
    }
    
}

private extension SelectImageView {
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: SelectImageCell.self)
    }
}

extension SelectImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SelectImageCell.self, for: indexPath)
        cell.setImage(items[indexPath.row])
        cell.deleteAction = { [weak self] in
            guard let self = self else {return}
            self.delete(at: indexPath.row)
        }
        return cell
    }
}
extension SelectImageView: UICollectionViewDelegate {
    
}
extension SelectImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.height,
                                 height: collectionView.bounds.size.height)
    }
}
