//
//  Emailer.swift
//
//  Created by MGAbouarab®
//


import MessageUI

/*
 To use this:-
 
 1-create an object of this class to your VC on top level scoop
 
 let emailer = Emailer()
 
 2- call send method when press in specific button or view
 
 emailer.sendMail(body: "Hello From Mohammed", recipients: ["mgabouarab@gmail.com"])
 
 
 */


class Emailer: NSObject {
    
    func sendMail(body: String, recipients: [String]) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.delegate = self
            mail.setToRecipients(recipients)
            mail.setMessageBody(body, isHTML: true)
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let window = window else {return}
            window.topViewController()?.present(mail, animated: true, completion: nil)
        }
        
    }
    
}

extension Emailer: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

