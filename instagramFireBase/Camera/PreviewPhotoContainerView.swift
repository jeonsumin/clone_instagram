//
//  PreviewPhotoContainerView.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/07.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    //MARK: - Properties
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBotton: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBotton: 24, paddingRight: 0, width: 50, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Function
    
    //MARK: - Action Selector Methods
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    @objc func handleSave(){
        let library = PHPhotoLibrary.shared()
        guard let previewImage = previewImageView.image else { return }
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save Image to photo library: ", err)
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let saveLabel = UILabel()
                saveLabel.text = "저장되었습니다."
                saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
                saveLabel.textColor = .white
                saveLabel.numberOfLines = 0
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                saveLabel.textAlignment = .center
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.center = self.center
                
                self.addSubview(saveLabel)
                saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,options: .curveEaseOut) {
                    saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                } completion: { completed in
                    //completed
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,options: .curveEaseOut) {
                        saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        saveLabel.alpha = 0
                    } completion: { _ in
                        saveLabel.removeFromSuperview()
                    }

                }

            }
        }
    }
}

