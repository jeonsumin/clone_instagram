//
//  PhotoSelectorController.swift
//  instagramFireBase
//
//  Created by Terry on 2023/08/30.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController{
    
    //MARK: - Properties
    let cellId = "cellId"
    let headerId = "headerId"
    
    var images = [UIImage]()
    var selectImage: UIImage?
    var assets = [PHAsset]()
    var header: PhotoSelectorHeader?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        setupNavgationButtons()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhoto()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Function
    /**
     네비게이션 버튼 설정
     
     다음, 취소 버튼 추가
     */
    fileprivate func setupNavgationButtons(){
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(handleNext))
    }
    
    /**
     PHAssets 옵션 메소드
     */
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        return fetchOptions
    }

    /**
     디바이스 앨범에 접근하여 사진 가져오기
     */
    fileprivate func fetchPhoto(){
        
        let allPhotos = PHAsset.fetchAssets(with: .image , options: assetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { assets, count, stop in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 350, height: 350)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: assets, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(assets)
                        if self.selectImage == nil {
                            self.selectImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    /**
     취소 버튼 메소드
     */
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    /**
     다음 버튼 메소드
     */
    @objc func handleNext(){
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}
//MARK: - CollectionView DataSource, Delegate
extension PhotoSelectorController:UICollectionViewDelegateFlowLayout {
    
    // 컬렉션 뷰의 엣지 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //컬렉션뷰 헤더뷰의 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    // 헤더 속성 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        self.header = header
        
        if let selectImage = selectImage {
            if let index = self.images.index(of: selectImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 500, height: 500)
                imageManager.requestImage(for: selectedAsset,
                                          targetSize: targetSize,
                                          contentMode: .default,
                                          options: nil) { image, info in
                    header.photoImageView.image = image
                }

            }
        }
        
        return header
    }
    
    //상하 좌우 마진 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //컬렉션뷰 셀의 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    // 셀의 개수 설정
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // 컬렉션뷰의 셀 속성 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    // 컬렉션 뷰 셀 선택시 호출되는 메소드 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectImage = images[indexPath.item]
        self.collectionView.reloadData()
        let indexPath = IndexPath(item:0,section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}
