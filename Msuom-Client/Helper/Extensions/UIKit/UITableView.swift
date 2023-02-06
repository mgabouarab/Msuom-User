//
//  UITableView.swift
//
//  Created by MGAbouarab®
//

import UIKit

class TableViewContentSized: UITableView {
    
    // 2) Add a UITableView to your layout and set constraints on all sides. Set the class of it to ContentSizedTableView.

    // 3) You should see some errors, because Storyboard doesn't take our subclass' intrinsicContentSize into account. Fix this by opening the size inspector and overriding the intrinsicContentSize to a placeholder value. This is an override for design time. At runtime it will use the override in our ContentSizedTableView class
    
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

//MARK: - Extensions -
extension UITableView {
    
    private enum AnimationDirection {
        case up
        case down
        case left
        case right
    }
    private func reloadData(animationDirection:AnimationDirection) {
        self.reloadData()
        self.layoutIfNeeded()
        let cells = self.visibleCells
        var index = 0
        let tableHeight: CGFloat = self.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            switch animationDirection {
            case .up:
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
                break
            case .down:
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                break
            case .left:
                cell.transform = CGAffineTransform(translationX: tableHeight, y: 0)
                break
            case .right:
                cell.transform = CGAffineTransform(translationX: -tableHeight, y: 0)
                break
            }
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    func animateToLeft() {
        self.reloadData(animationDirection: .left)
    }
    func animateToRight() {
        self.reloadData(animationDirection: .right)
    }
    func animateToTop() {
        self.reloadData(animationDirection:.down)
    }
    func animateToBottom() {
        self.reloadData(animationDirection: .up)
    }
}
extension UITableView {
    
    //MARK: -Properities -
//    private static var placeholderAction: (()->())? = nil
//    private var action: (()->())? {
//        get {
//            return UITableView.placeholderAction
//        }
//        set(newValue) {
//            UITableView.placeholderAction = newValue
//        }
//    }
    
    //MARK: - Logic Methods -
    private func creatPlaceholder(title: String?, message: String?, image: UIImage? = nil, actionNames: [String]? = nil, actions: [Selector]? = nil) {
        
//        self.action = action
        
        //MARK:- Colors-
        let titleColor = Theme.colors.secondryDarkFontColor
        let messageColor = Theme.colors.secondryDarkFontColor
//        let buttonTextColor = #colorLiteral(red: 0.1058823529, green: 0.5568627451, blue: 0.5450980392, alpha: 1)
        
        //MARK:-Views-
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let stackView = UIStackView()
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        
        //MARK:-Handel Views-
        
        //MARK:- EmptyView
        emptyView.backgroundColor = .clear
        
        //MARK:- StackView
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.alignment = .center
        stackView.spacing = 5
        
        //MARK:- ImageView
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        if image == nil {
            imageView.isHidden = true
        }
        
        //MARK:- Title Label
        titleLabel.textColor = titleColor
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        if title == nil {
            titleLabel.isHidden = true
        }
        
        //MARK:- Message Label
        messageLabel.textColor = messageColor
        messageLabel.font = .systemFont(ofSize: 17)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        if message == nil {
            messageLabel.isHidden = true
        }
        
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        //MARK:- Action Button
        if let actions = actions, let actionNames = actionNames, actions.count == actionNames.count {
            for index in actions.indices {
                let actionButton = UIButton()
                actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                actionButton.setTitleColor(Theme.colors.mainColor, for: .normal)
                actionButton.setTitle(actionNames[index], for: .normal)
                actionButton.layer.borderColor = Theme.colors.mainColor.cgColor
                actionButton.layer.borderWidth = 1
                actionButton.layer.cornerRadius = 25
                actionButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4).isActive = true
                actionButton.clipsToBounds = true
                actionButton.addTarget(self.parentContainerViewController, action: actions[index], for: .touchUpInside)
                stackView.addArrangedSubview(actionButton)
            }
        }
        
        
        //MARK:-Add Views As Subviews-
        stackView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(stackView)
        
        //MARK:-Handel Constriant-
        stackView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(greaterThanOrEqualTo: emptyView.trailingAnchor).isActive = true
        
        //MARK:- The Final Result
        emptyView.alpha = 0
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
        UIView.animate(withDuration: 0.3) {
            emptyView.alpha = 1
        }
        
    }
    
    func createPlaceholder(_ placeholder: TableViewPlaceHolder) {
        self.creatPlaceholder(title: placeholder.title, message: placeholder.message, image: UIImage(named: placeholder.imageName), actionNames: placeholder.actionName, actions: placeholder.action)
    }
    func restorePlaceholderWith(seperator: UITableViewCell.SeparatorStyle) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundView?.alpha = 0
        } completion: { (_) in
            self.backgroundView = nil
            self.separatorStyle = seperator
        }
    }
    
    func setPlaceholder(isEmpty: Bool, separator: UITableViewCell.SeparatorStyle = .none) {
        if isEmpty {
            self.createPlaceholder(.empty)
        } else {
            self.restorePlaceholderWith(seperator: separator)
        }
    }
    
    //MARK: - Action -
//    @objc func tempFunc() {
//        self.action?()
//    }
    
}
extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let sections = self.numberOfSections - 1
            let rows = self.numberOfRows(inSection: sections) - 1
            if (rows > 0){
                self.scrollToRow(at: NSIndexPath(row: rows, section: sections) as IndexPath, at: .bottom, animated: true)
            }
        }
    }
}

//MARK: - Placeholder -
enum TableViewPlaceHolder {
    case notLogin(action: [Selector]?)
    case notifications(action: [Selector]?)
    case empty
    case emptyHome(action: [Selector]?)
}
extension TableViewPlaceHolder {
    var title: String {
        switch self {
        case .notLogin:
            return "Your are not login".helperLocalizable
        case .notifications:
            return "No Notifications Found".helperLocalizable
        case .empty:
            return "No Data Found".helperLocalizable
        case .emptyHome:
            return "No Posts Found".localized
        }
    }
    var message: String {
        switch self {
        case .notLogin:
            return "Start logging into your account with us".helperLocalizable
        case .notifications:
            return ""
        case .empty:
            return ""
        case .emptyHome:
            return "Add Friends to see posts".localized
        }
    }
    var actionName: [String] {
        switch self {
        case .notLogin:
            return ["Login".helperLocalizable]
        case .notifications:
            return [""]
        case .empty:
            return [""]
        case .emptyHome:
            return ["Add Friends".localized, "Register as store".localized]
        }
    }
    var imageName: String {
        switch self {
        case .notLogin:
            return "accountTotalLogo"
        case .notifications:
            return "NoNotifications"
        case .empty:
            return "emptyPlaceholder"
        case .emptyHome:
            return ""
        }
    }
    var action:  [Selector]? {
        switch self {
        case .notLogin(let action):
            return action
        case .notifications(_):
            return nil
        case .empty:
            return nil
        case .emptyHome(let actions):
            return actions
        }
    }
}
