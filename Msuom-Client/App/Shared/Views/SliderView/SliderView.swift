//
//  SliderView.swift
//  LocationClient
//
//  Created by MGAbouarab on 23/09/2022.
//

import UIKit

@IBDesignable
class SliderView: UIView {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    //MARK: - Properties -
    private var items: [String] = [] {
        didSet {
            if !items.isEmpty {
                self.collectionView.reloadData()
                self.setupSlider()
            }
        }
    }
    private var timer: Timer?
    private var counter = 0
    private var currentIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    @IBInspectable
    var selectedPageColor: UIColor = .black {
        didSet {
            pageControl.currentPageIndicatorTintColor = selectedPageColor
        }
    }
    @IBInspectable
    var unselectedPageColor: UIColor = .white {
        didSet {
            pageControl.pageIndicatorTintColor = unselectedPageColor
        }
    }
    @IBInspectable
    var isCard: Bool = true {
        didSet {
            self.collectionView.reloadData()
        }
    }
    @IBInspectable
    var enableIndicator: Bool = true
    
    
    
    //MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetUp()
        self.setupCollectionView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetUp()
        self.setupCollectionView()
    }
    
    private func xibSetUp() {
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SliderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
        
    }
    private func handleTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.changeSliderPosition), userInfo: nil, repeats: true)
    }
    
    //MARK: - Data -
    func set(images: [String]) {
        self.items = images
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.items = images
        }
    }
    
    //MARK: - Actions -
    @objc private func changeSliderPosition() {
        guard !self.items.isEmpty else {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        
        if counter < self.items.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.currentIndex = index
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
            return
        }
        
        counter = 0
        let index = IndexPath.init(item: counter, section: 0)
        self.currentIndex = index
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = counter
        counter = 1
        
    }
    
}

//MARK: - CollectionView -
extension SliderView {
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(cellType: SliderCell.self)
    }
    private func setupSlider() {
        pageControl.numberOfPages = items.count
        pageControl.currentPage = counter
        DispatchQueue.main.async {
            self.handleTimer()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            guard scrollView == self.collectionView else {return}
            
            var visibleRect = CGRect()

            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = collectionView.bounds.size

            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

            guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

            self.counter = indexPath.item
            self.pageControl.currentPage = counter
        }
    

}
extension SliderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.items.count == 1 {
            self.pageControl.isHidden = true
        } else {
            self.pageControl.isHidden = !self.enableIndicator
        }
        

        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SliderCell.self, for: indexPath)
        cell.imageView.setWith(string: items[indexPath.item])
        if self.isCard {
            cell.cornerRadius = 8
        } else {
            cell.cornerRadius = 0
        }
        return cell
    }
}
extension SliderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = self.items.map({ImageViewerItem(urlImage: $0, dataImage: nil)})
        let vc = ImageViewerVC.create(images: items, selectedIndex: self.currentIndex)
        self.parentContainerViewController?.present(vc, animated: true)
    }
}
extension SliderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isCard {
            let width = collectionView.bounds.width - 32
            let height = collectionView.bounds.height - 8
            return CGSize(width: width, height: height)
        } else {
            return collectionView.bounds.size
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isCard {
            return 32
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.isCard {
            return UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        } else {
            return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isCard {
            return 32
        } else {
            return 0
        }
    }
}
