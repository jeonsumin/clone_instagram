//
//  CameraController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/05.
//

import UIKit
import AVFoundation

class CameraController: UIViewController{
    //MARK: - Properties
    let output = AVCapturePhotoOutput()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    //MARK: - Function
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
        // 1. 인풋 설정
        guard let captureDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else{ return }
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
        }catch let err {
            print("Could not setup camera input: ", err)
        }
        
        // 2. 아웃풋 설정
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
        // 3. 아웃풋 프리뷰 설정
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            captureSession.startRunning()
        }
    }
    
    func setupHUD(){
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBotton: 24, paddingRight: 0, width: 80, height: 80)
        
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBotton: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    //MARK: - Action Selector Methods
    @objc func handleCapturePhoto(){
        print("Capturing photo ")
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    

    
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
    
}
extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
//        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: <#T##CMSampleBuffer#>, previewPhotoSampleBuffer: <#T##CMSampleBuffer?#>)
        let imageData = photo.fileDataRepresentation()
        
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
        containerView.previewImageView.image = previewImage
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
//
        print("Finish Processing Photo Sample Buffer ... ")
    }
}
