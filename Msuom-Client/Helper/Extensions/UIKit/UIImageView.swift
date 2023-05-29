//
//  UIImageView.swift
//
//  Created by MGAbouarab®
//

import Kingfisher
import AVKit


extension UIImageView {
    func setWith(string: String?) {
        self.kf.indicatorType = .activity
        self.image = UIImage(named: "AppIcon")
        guard let string = string else {return}
        
        guard let stringUrl = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let httpURL = URL(string: stringUrl), httpURL.isFileURL || (httpURL.host != nil && httpURL.scheme != nil) else {
            self.image = UIImage(named: string) ?? UIImage(named: "AppIcon")
            return
        }
        
        if let newURL = ((string)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.kf.setImage(with: URL(string: newURL), placeholder: image, options: [.transition(.fade(0.2))])
            return
        }
        self.kf.setImage(with: URL(string: (string)), placeholder: image, options: [.transition(.fade(0.2))])
    }
    func createVideoThumbnail(from stringURL: String) {
        
        guard let url = URL(string: stringURL) else {
            self.image = UIImage(named: "logo")
            return
        }
        
        let width = frame.width
        let height = frame.height
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            let asset = AVAsset(url: url)
            let assetImageGenerate = AVAssetImageGenerator(asset: asset)
            assetImageGenerate.appliesPreferredTrackTransform = true
            assetImageGenerate.maximumSize = CGSize(width: width, height: height)
            
            let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
            do {
                let image = try assetImageGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: image)
                DispatchQueue.main.async {
                    self.image = thumbnail
                }
            }
            catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.image = UIImage(named: "logo")
                }
            }
        }
    }
}

