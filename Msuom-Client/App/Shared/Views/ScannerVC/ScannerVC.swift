//
//  ScannerVC.swift
//  Msuom-Provider
//
//  Created by MGAbouarab on 06/12/2022.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {
    
    //MARK: - Properties -
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCaptureSession()
        self.setupPreviewLayer()
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        self.handleDismissButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    deinit {
        print("ScannerViewController is dismissed No memory leak found")
    }
    
    //MARK: - Design -
    private func handleDismissButton() {
        let dismissButton = UIButton(frame: CGRect(x: 30, y: 30, width: 30, height: 30))
        dismissButton.setImage(UIImage(named: "errorAlert"), for: .normal)
        self.view.addSubview(dismissButton)
        self.view.bringSubviewToFront(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Logic -
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
    }
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    private func found(code: String) {
        print(code)
        guard (code.contains("live") || code.contains("normal")) else {return}
        guard let id = code.components(separatedBy: "/").last else {return}
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let window = window, let _ = window.rootViewController as? AppTabBarController, let index = (window.rootViewController as? AppTabBarController)?.selectedIndex  {
            (window.rootViewController as? AppTabBarController)?.viewControllers?[index].show(AuctionDetailsVC.create(id: id, isFromHome: false), sender: self)
        }
    }
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    @objc private func dismissButtonPressed() {
        self.dismiss(animated: true)
    }
    
}
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }
    
}
