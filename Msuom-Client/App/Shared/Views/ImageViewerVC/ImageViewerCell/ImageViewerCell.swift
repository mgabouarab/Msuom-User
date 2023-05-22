//
//  ImageViewerCell.swift
//  Shop Zone
//
//  Created by MGAboarab on 19/07/2022.
//

import UIKit

class ImageViewerCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier: String = "ImageViewerCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupScrollView()
    }
    
    func setupCell(image: ImageViewerItem, enableZoom: Bool = true) {
        self.imageView.contentMode = enableZoom ? .scaleAspectFit : .scaleAspectFill
        self.scrollView.isUserInteractionEnabled = enableZoom
        if let url = image.urlImage {
            self.imageView.setWith(string: url)
        } else if let data = image.dataImage {
            self.imageView.image = UIImage(data: data)
        }
    }

}

extension ImageViewerCell: UIScrollViewDelegate {
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 2
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
