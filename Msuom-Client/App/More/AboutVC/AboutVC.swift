//
//  AboutVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 14/11/2022.
//
//  Template by MGAbouarab®


import UIKit
import AVKit


class AboutVC: BaseVC {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var playerView: UIView!
    @IBOutlet weak private var textView: UITextView!
    
    
    //MARK: - Properties -
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    //MARK: - Creation -
    static func create() -> AboutVC {
        let vc = AppStoryboards.more.instantiate(AboutVC.self)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialDesign()
        self.getAbout()
    }
    
    
    //MARK: - Design Methods -
    private func configureInitialDesign() {
        self.title = "".localized
        self.addBackButtonWith(title: "About Msuom".localized)
        self.playerView.layer.cornerRadius = 12
        self.playerView.clipsToBounds = true
    }
    
    //MARK: - Logic Methods -
    private func initialVideo(with string: String?) {
        guard let string, let videoURL = URL(string: string) else {return}
        
        self.player = AVPlayer(url: videoURL)
        self.playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.view.frame = self.playerView.frame
        self.playerView.addSubview(playerViewController.view)
        self.addChild(playerViewController)
        playerViewController.player?.play()
        playerViewController.showsPlaybackControls = true
    }
    
    //MARK: - Actions -
    
}


//MARK: - Networking -
extension AboutVC {
    private func getAbout() {
        self.showIndicator()
        SettingRouter.about.send { [weak self] (response: APIGenericResponse<AboutModel>) in
            guard let self = self, let data = response.data else {return}
            self.initialVideo(with: data.link)
            
            let titles = ["Overview".localized, "Our mission".localized,"Goals".localized,"Our values".localized]
            
            let text = """
\("Overview".localized)
\(data.about.htmlToAttributedString?.string ?? "")
\("Our mission".localized)
\(data.mission.htmlToAttributedString?.string ?? "")
\("Goals".localized)
\(data.goals.htmlToAttributedString?.string ?? "")
\("Our values".localized)
\(data.rateus.htmlToAttributedString?.string ?? "")
"""
            
            let attributedText = text.change(strings: titles, with: Theme.colors.mainColor)
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: attributedText.length))
            self.textView.attributedText = attributedText
        }
    }
}

//MARK: - Routes -
extension AboutVC {
    
}
