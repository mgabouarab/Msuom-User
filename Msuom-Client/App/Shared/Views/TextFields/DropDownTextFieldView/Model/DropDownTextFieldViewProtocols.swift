//
//  DropDownTextFieldViewProtocols.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 17/11/2022.
//

import Foundation

protocol DropDownTextFieldViewDelegate {
    func dropDownList(for textFieldView: DropDownTextFieldView) -> [DropDownItem]
    func didSelect(item: DropDownItem, for textFieldView: DropDownTextFieldView)
}
protocol DropDownTextFieldViewListDelegate {
    func didSelect(item: DropDownItem)
}
