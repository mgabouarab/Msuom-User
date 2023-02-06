//
//  IntroPageController.swift
//
//  Created by MGAbouarab®
//

import UIKit

class IntroPageController: UIPageViewController {
    
    //MARK: - Properties -
    private let nextTitle = "Next".localized
    private let skipTitle = "Skip".localized
    private let continueTitle = "Start".localized
    private var isLast = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    private var subVC: [UIViewController] = []
    private lazy var nextButton: UIButton = {
        let button = AppButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        return button
    }()
    private lazy var sheetView: UIView = {
        let sheetView = UIView()
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.layer.cornerRadius = 40
        sheetView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        sheetView.clipsToBounds = true
        sheetView.backgroundColor = Theme.colors.whiteColor
        return sheetView
    }()
    private var pageControl = UIPageControl(frame: .zero)

    //MARK: - Creation -
    static func create(subVCs: [UIViewController]) -> IntroPageController {
        let vc = AppStoryboards.main.instantiate(IntroPageController.self)
        vc.subVC = subVCs
        return vc
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageController()
        self.setupPageControl()
//        self.addContainerView()
        self.view.backgroundColor = Theme.colors.mainColor
    }
    
    //MARK: - Design Methods -
    private func setupPageControl() {
        
        //PageControl
        self.pageControl.numberOfPages = subVC.count
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.currentPageIndicatorTintColor = Theme.colors.mainColor
        self.pageControl.pageIndicatorTintColor = Theme.colors.mainWithAlph
        view.addSubview(self.pageControl)

        //Next Button
        self.nextButton.setTitle(nextTitle, for: .normal)
        self.nextButton.setTitleColor(Theme.colors.whiteColor, for: .normal)
        self.nextButton.alpha = 1
        self.view.addSubview(self.nextButton)
        
        self.nextButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pageControl.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: -10).isActive = true
        
        
        //Lang Button
        self.skipButton.setTitle(skipTitle, for: .normal)
        self.skipButton.setTitleColor(Theme.colors.whiteColor, for: .normal)
        self.skipButton.alpha = 1
        self.view.addSubview(self.skipButton)
        
        self.skipButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.skipButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        
    }
    private func addContainerView() {
        self.view.addSubview(sheetView)
        self.sheetView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sheetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.sheetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.sheetView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor).isActive = true
        self.view.sendSubviewToBack(self.sheetView)
    }
    
    //MARK: - objc Methods -
    @objc private func nextButtonPressed() {
        if isLast {
            self.skipButtonPressed()
        } else {
            self.goToNextPage()
        }
    }
    @objc private func skipButtonPressed() {
        let vc = AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    //MARK: - logic Methods -
    private func changeButtonTitle(currentIndex: Int) {
        if currentIndex == subVC.count - 1 {
            self.nextButton.setTitle(continueTitle, for: .normal)
        } else {
            self.nextButton.setTitle(nextTitle, for: .normal)
        }
    }
    private func showHideButtons(currentIndex: Int) {
        if currentIndex == subVC.count - 1 {
            isLast = true
            self.nextButton.setTitle(continueTitle, for: .normal)
            self.skipButton.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        } else if currentIndex == subVC.count - 2 && isLast {
            isLast = false
            self.nextButton.setTitle(nextTitle, for: .normal)
            self.skipButton.alpha = 1
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

extension IntroPageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private func setupPageController() {
        self.delegate = self
        self.dataSource = self
        self.setViewControllers([self.subVC[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        let currentIndex = subVC.firstIndex(of: nextViewController) ?? 0
        self.pageControl.currentPage = currentIndex
        showHideButtons(currentIndex: currentIndex)
        setViewControllers([nextViewController], direction: Language.isRTL() ? .reverse : .forward, animated: animated, completion: nil)
        
    }
    private func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        let currentIndex = subVC.firstIndex(of: previousViewController) ?? 0
        self.pageControl.currentPage = currentIndex
        showHideButtons(currentIndex: currentIndex)
        setViewControllers([previousViewController], direction: Language.isRTL() ? .forward : .reverse, animated: animated, completion: nil)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.subVC.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subVC.firstIndex(of: viewController) ?? 0
        self.pageControl.currentPage = currentIndex
        showHideButtons(currentIndex: currentIndex)
        if currentIndex <= 0 {
            return nil
        }
        return subVC[currentIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subVC.firstIndex(of: viewController) ?? 0
        self.pageControl.currentPage = currentIndex
        showHideButtons(currentIndex: currentIndex)
        if currentIndex >= subVC.count - 1 {
            return nil
        }
        return subVC[currentIndex + 1]
    }
    
}
