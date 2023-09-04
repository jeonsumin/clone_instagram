//
//  UserSearchController.swift
//  instagramFireBase
//
//  Created by terry on 2023/09/04.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.barTintColor = .gray
        searchBar.delegate = self
        
        return searchBar
    }()
    
    let userSearchView = SearchResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor,
                         left: navBar?.leftAnchor,
                         bottom: navBar?.bottomAnchor,
                         right: navBar?.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 8,
                         paddingBotton: 0,
                         paddingRight: 8,
                         width: 0,
                         height: 0)
        
        searchBar.setValue("취소", forKey: "cancelButtonText")
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        
        userSearchView.alpha = 1
        view.addSubview(userSearchView)
        userSearchView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBotton: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        
        userSearchView.alpha = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 ) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}

extension UserSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.isEmpty {
//            self.userSearchView.filteredUsers = self.userSearchView.users
//        }
        
        self.userSearchView.filteredUsers = self.userSearchView.users.filter { user -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        }
        
        self.userSearchView.collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.userSearchView.alpha = 0
            self.collectionView.alpha = 1
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.userSearchView.alpha = 1
        }
    }

}
