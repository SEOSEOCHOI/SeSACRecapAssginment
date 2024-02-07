//
//  ProfileSettingCodeViewController.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 1/29/24.
//

import UIKit

#Preview {
    ProfileSettingCodeViewController()
}

class ProfileSettingCodeViewController: UIViewController {
    
    let selectedImageView = ProfileImageView(frame: .zero)
    let profileSelectCollectionVeiw = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    let profileImageList = ProfileImage.allCases
    lazy var userSelect = profileImageList.randomElement()?.rawValue
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        configureNavigationItem()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        
        configureCollectionView()
    }
}

extension ProfileSettingCodeViewController {
    func configureNavigationItem() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 설정"
    }
    
    func configureHierarchy() {
        view.addSubview(selectedImageView)
        view.addSubview(profileSelectCollectionVeiw)
    }
    
    func configureConstraints() {
        selectedImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(view).multipliedBy(0.35)
            make.height.equalTo(selectedImageView.snp.width)
        }
        profileSelectCollectionVeiw.snp.makeConstraints { make in

            make.top.equalTo(selectedImageView.snp.bottom).offset(50)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        setBackgroundColor()
        guard let profileImage = userSelect else { return  }
        selectedImageView.image = UIImage(named: profileImage)
    }
}

extension ProfileSettingCodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = profileSelectCollectionVeiw.dequeueReusableCell(withReuseIdentifier:  ProfileSettingCodeCollectionViewCell.identifier, for: indexPath) as! ProfileSettingCodeCollectionViewCell
        
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

extension ProfileSettingCodeViewController {
    func configureCollectionView() {
        profileSelectCollectionVeiw.backgroundColor = .clear
        
        profileSelectCollectionVeiw.delegate = self
        profileSelectCollectionVeiw.dataSource = self
        
        profileSelectCollectionVeiw.register(ProfileSettingCodeCollectionViewCell.self, forCellWithReuseIdentifier: ProfileSettingCodeCollectionViewCell.identifier)
    }
    
    static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 5)) / 4
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
}

