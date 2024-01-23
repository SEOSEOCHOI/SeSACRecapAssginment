//
//  ProfileSettingViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/19/24.
//

import UIKit

class ProfileSettingViewController: UIViewController {
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var profileSelectCollectionVeiw: UICollectionView!

    let profileImageList = ProfileImage.allCases
    lazy var userSelect = profileImageList.randomElement()?.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureView()
        configureCollectionView()
        setLayout()
    }
    
}

// MARK: View
extension ProfileSettingViewController {
    func configureNavigationItem() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 설정"
    }
    
    func configureView() {
        setBackgroundColor()
        
        guard let profileImage = userSelect else { return  }
        selectedImageView.image = UIImage(named: profileImage)
        selectedImageView.setBorder(image: selectedImageView)
        selectedImageView.setRadius(image: selectedImageView)
    }
}

// MARK: CollectionView
extension ProfileSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // TODO: 타입캐스팅 학습
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  ProfileSettingCollectionViewCell.identifier, for: indexPath) as! ProfileSettingCollectionViewCell
        
        cell.configureCell(image: profileImageList[indexPath.row].rawValue, select: userSelect ?? "")

   
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        userSelect = profileImageList[indexPath.row].rawValue
        
        if let userSelectImage = userSelect {
            UserDefaultManager.shaerd.userImage = userSelectImage
            selectedImageView.image = UIImage(named: userSelectImage)
        }
        collectionView.reloadData()
    }
}

// MARK: CollectionView [layout + Register]
extension ProfileSettingViewController {
    func configureCollectionView() {
        let xib = UINib(nibName: ProfileSettingCollectionViewCell.identifier, bundle: nil)
        profileSelectCollectionVeiw.register(xib, forCellWithReuseIdentifier: ProfileSettingCollectionViewCell.identifier)
        
        profileSelectCollectionVeiw.delegate = self
        profileSelectCollectionVeiw.dataSource = self
        
        profileSelectCollectionVeiw.backgroundColor = .black
        
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 5)) / 4
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        profileSelectCollectionVeiw.collectionViewLayout = layout
    }
}
