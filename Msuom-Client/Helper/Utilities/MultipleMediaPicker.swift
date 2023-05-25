//
//  MultipleMediaPicker.swift
//  shqran
//
//  Created by Yosef elbosaty on 08/05/2023.
//

import UIKit
import MobileCoreServices
import AVFoundation
import PhotosUI

class MultipleMediaPicker: NSObject {
    
    //MARK: Variables Declaration
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    private var configuration = PHPickerConfiguration()
    private var actionSheet = UIAlertController()
    private let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    private var didPickMedia : ((_ media: [PickedMediaModel]) -> ())?
    private var mediaType: MediaType = .image
    
    //MARK: Initialization
    override init() {
        super.init()
    }
    
    convenience init(limit: Int) {
        self.init()
        configuration.selectionLimit = limit
        configuration.filter = .any(of: [.images])
        checkImagePickerAuthorization()
    }
    
    //MARK: Actions
    private func checkImagePickerAuthorization() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.presentSourceTypeAlert()
        }else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentSourceTypeAlert()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.presentDidDenyCameraPermissionAlert()
                    }
                }
            }
        }
    }
    
    //MARK: Present Source Type Alert
    private func presentSourceTypeAlert() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "camera".localized, style: .default) { (action) in
            let actionSheet = UIAlertController(title: "mediaType".localized, message: "", preferredStyle: .actionSheet)
            
            let photoAction = UIAlertAction(title: "photo".localized, style: .default) { _ in
                self.openCameraForImage()
            }
            photoAction.setValue(Theme.colors.mainColor, forKey: "titleTextColor")
            
            let videoAction = UIAlertAction(title: "video".localized, style: .default) { _ in
                self.openCameraForVideo()
            }
            videoAction.setValue(Theme.colors.mainColor, forKey: "titleTextColor")
            
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            actionSheet.addAction(photoAction)
            actionSheet.addAction(videoAction)
            actionSheet.addAction(cancelAction)
            self.window?.topViewController()?.present(actionSheet, animated: true)
        }
        cameraAction.setValue(Theme.colors.mainColor, forKey: "titleTextColor")
        
        let galleryAction = UIAlertAction(title: "gallery".localized, style: .default) { (action) in
            actionSheet.dismiss(animated: true)
            let picker = PHPickerViewController(configuration: self.configuration)
            picker.delegate = self
            self.window?.topViewController()?.present(picker, animated: true, completion: nil)
        }
        galleryAction.setValue(Theme.colors.mainColor, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        window?.topViewController()?.present(actionSheet, animated: true)
    }
    
    private func openCameraForImage() {
        mediaType = .image
        actionSheet.dismiss(animated: true)
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [UTType.image.identifier]
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = false
        window?.topViewController()?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCameraForVideo() {
        mediaType = .video
        actionSheet.dismiss(animated: true)
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.videoMaximumDuration = 30
        imagePicker.cameraFlashMode = .off
        imagePicker.videoQuality = .typeHigh
        imagePicker.mediaTypes = [UTType.movie.identifier]
        imagePicker.cameraCaptureMode = .video
        imagePicker.allowsEditing = false
        window?.topViewController()?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentDidDenyCameraPermissionAlert() {
        let alert = UIAlertController(title: "".localized, message: "noCameraPermission".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        let enableCamera = UIAlertAction(title: "enableCamera".localized, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alert.addAction(enableCamera)
        alert.addAction(okAction)
        window?.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func didPickMedia(completion: @escaping(_ media: [PickedMediaModel]) -> Void) {
        didPickMedia = completion
    }
    
}

extension MultipleMediaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 0.5) {
            picker.dismiss(animated: true) {
                self.didPickMedia?([PickedMediaModel(media: image, mediaData: imageData, mediaType: .image)])
            }
        } else {
            if let mediaURL = info[.mediaURL] as? URL{
                
                AVURLAsset(url: mediaURL).exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: .mp4, fileExtension: "mp4") { url in
                    do{
                        if let url = url {
                            print("url: \(url)")
                            let videoData = try Data(contentsOf: url)
                            if let image = self.generateThumbnail(path: url) {
                                DispatchQueue.main.async {
                                    picker.dismiss(animated: true) {
                                        self.didPickMedia?([PickedMediaModel(media: image, mediaData: videoData, mediaType: .video)])
                                    }
                                }
                            }
                        }
                    }catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    ///User for generating a thumbnail from video
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}

extension MultipleMediaPicker: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else{ return }
        let pickedItems = results
            .compactMap({ $0.itemProvider })
        
        var pickedMedia: [PickedMediaModel] = [ ]
        
        let dispatchGroup = DispatchGroup()
        
        for item in pickedItems {
            dispatchGroup.enter()
            if item.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                item.loadItem(forTypeIdentifier: UTType.movie.identifier, options: [:])  { videoURL, error in
                    if let url = videoURL as? URL {
                        AVURLAsset(url: url).exportVideo(presetName: AVAssetExportPresetHighestQuality, outputFileType: .mp4, fileExtension: "mp4") { url in
                            do{
                                if let url = url {
                                    let videoData = try Data(contentsOf: url)
                                    if let image = self.generateThumbnail(path: url) {
                                        pickedMedia.append(PickedMediaModel(media: image, mediaData: videoData, mediaType: .video))
                                    }
                                    dispatchGroup.leave()
                                }
                            }catch {
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            } else {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage, let imageData = image.jpegData(compressionQuality: 0.5) {
                        pickedMedia.append(PickedMediaModel(media: image, mediaData: imageData, mediaType: .image))
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.didPickMedia?(pickedMedia)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

struct PickedMediaModel {
    let media: UIImage
    let mediaData: Data
    let mediaType: MediaType
}

enum MediaType {
    case image
    case video
}

extension AVURLAsset{
    func exportVideo(presetName: String = AVAssetExportPresetHighestQuality, outputFileType: AVFileType = .mp4, fileExtension: String = "mp4", then completion: @escaping (URL?) -> Void) {
    
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completion(nil)
            }
        }
        
        if let session = AVAssetExportSession(asset: self, presetName: presetName) {
            session.outputURL = filePath
            session.outputFileType = outputFileType
            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
            let range = CMTimeRangeMake(start: start, duration: duration)
            session.timeRange = range
            session.shouldOptimizeForNetworkUse = true
            session.exportAsynchronously {
                switch session.status {
                case .completed:
                    completion(filePath)
                case .cancelled:
                    debugPrint("Video export cancelled.")
                    completion(nil)
                case .failed:
                    let errorMessage = session.error?.localizedDescription ?? "n/a"
                    print(session.error)
                    debugPrint("Video export failed with error: \(errorMessage)")
                    completion(nil)
                default:
                    break
                }
            }
        } else {
            completion(nil)
        }
    }
}

//extension UIWindow {
//    func topViewController() -> UIViewController? {
//        var top = self.rootViewController
//        while true {
//            if let presented = top?.presentedViewController {
//                top = presented
//            } else if let nav = top as? UINavigationController {
//                top = nav.visibleViewController
//            } else if let tab = top as? UITabBarController {
//                top = tab.selectedViewController
//            } else {
//                break
//            }
//        }
//        return top
//    }
//}

