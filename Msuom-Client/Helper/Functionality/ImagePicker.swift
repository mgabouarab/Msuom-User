//
//  ImagePicker.swift
//
//  Created by MGAbouarab®
//

import UIKit

//MARK: - Image -
class ImagePicker: NSObject {
    
    private enum Keys {
        case pickImage
        case camera
        case gallery
        case cancel
        
        var value: String {
            switch self {
            case .pickImage:
                return "Pick Image".helperLocalizable
            case .camera:
                return "Camera".helperLocalizable
            case .gallery:
                return "Gallery".helperLocalizable
            case .cancel:
                return "Cancel".helperLocalizable
            }
        }
        
    }

    //MARK: - Properties -
    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: Keys.pickImage.value, message: nil, preferredStyle: .actionSheet)
    private var pickImageCallback : ((_ image: UIImage, _ imageData: Data?) -> ())?
    
    //MARK: - Initializers -
    override init() {
        super.init()
        self.setupAlert()
    }
    
    //MARK: - Private Methods -
    private func setupAlert() {
        let cameraAction = UIAlertAction(title: Keys.camera.value, style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Keys.gallery.value, style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Keys.cancel.value, style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        picker.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
//        if #available(iOS 13.0, *) {
//            alert.overrideUserInterfaceStyle = .dark
//            alert.view.tintColor = Theme.colors.whiteColor
//        } else {
        alert.view.tintColor = Theme.colors.mainColor
//        {
        
    }
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let window = window else {return}
            window.topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            AppAlert.showErrorAlert(error: "this device has no camera")
        }
    }
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        window.topViewController()?.present(picker, animated: true, completion: nil)
    }
    
    
    func pickImage(_ callback: @escaping ((_ image: UIImage, _ imageData: Data?) -> ())) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        
        
        pickImageCallback = callback
        
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    

}
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image, image.jpegData(compressionQuality: 1))
    }
}

//MARK: - Video -
class VideoPicker: NSObject {
    
    private enum Keys {
        case pickVideo
        case camera
        case gallery
        case cancel
        
        var value: String {
            switch self {
            case .pickVideo:
                return "Pick Video".helperLocalizable
            case .camera:
                return "Camera".helperLocalizable
            case .gallery:
                return "Gallery".helperLocalizable
            case .cancel:
                return "Cancel".helperLocalizable
            }
        }
        
    }
    
    //MARK: - Properties -
    private var picker = UIImagePickerController()
    private var alert = UIAlertController(title: Keys.pickVideo.value, message: nil, preferredStyle: .actionSheet)
    private var pickVideoCallback : ((_ videoURL: URL, _ videoData: Data) -> ())?
    
    //MARK: - Initializers -
    override init() {
        super.init()
        self.setupAlert()
    }
    
    //MARK: - Private Methods -
    private func setupAlert() {
        let cameraAction = UIAlertAction(title: Keys.camera.value, style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: Keys.gallery.value, style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: Keys.cancel.value, style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        //        if #available(iOS 13.0, *) {
        //            alert.overrideUserInterfaceStyle = .dark
        //            alert.view.tintColor = Theme.colors.whiteColor
        //        } else {
        alert.view.tintColor = Theme.colors.mainColor
        //    }
        
    }
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeHigh
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let window = window else {return}
            window.topViewController()?.present(picker, animated: true, completion: nil)
        } else {
            AppAlert.showErrorAlert(error: "this device has no camera")
        }
    }
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        window.topViewController()?.present(picker, animated: true, completion: nil)
    }
    
    private func savedPhotosAlbum(path: String) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, nil, nil)
        }
    }
    
    //MARK: - Action Methods -
    func pickVideo(_ callback: @escaping ((_ videoURL: URL, _ videoData: Data) -> ())) {
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        
        
        pickVideoCallback = callback
        
        alert.popoverPresentationController?.sourceView = window.topViewController()?.view
        window.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
extension VideoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let videoURL = info[.mediaURL] as? URL else {
            fatalError("Expected a dictionary containing a video url, but was provided the following: \(info)")
        }
        
        self.savedPhotosAlbum(path: videoURL.path)
        
        do {
            let videoData = try Data(contentsOf: videoURL)
            pickVideoCallback?(videoURL, videoData)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
