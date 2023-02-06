//
//  DatePickerVC.swift
//  Msuom-Client
//
//  Created by MGAbouarab on 23/01/2023.
//

import UIKit

protocol DatePickerDelegate {
    func didSelect(date: Date)
}

class DatePickerVC: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak private var calendar: UIDatePicker!
    
    //MARK: - Propreties -
    let delegate: DatePickerDelegate
    
    //MARK: - Init -
    init(delegate: DatePickerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "BaseVC") is deinit, No memory leak found")
    }
    
    //MARK: - IBActions -
    @IBAction private func closeButtonPressed() {
        self.dismiss(animated: true)
    }
    @IBAction private func selectButtonPressed() {
        self.dismiss(animated: true) {
            self.delegate.didSelect(date: self.calendar.date)
        }
    }
    
}
