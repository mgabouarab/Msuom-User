//
//  HomeSliderCell.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 13/02/2023.
//

import UIKit

class HomeSliderCell: UITableViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var sliderView: SliderView!

    //MARK: - Lifecycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - setupDesign -
    func setup(data: [SliderView.SliderItem]) {
        self.sliderView.set(images: data)
    }
    
    
}
