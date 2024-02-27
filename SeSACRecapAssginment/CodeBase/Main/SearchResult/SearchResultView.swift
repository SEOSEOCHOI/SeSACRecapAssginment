//
//  SearchResultView.swift
//  SeSACRecapAssginment
//
//  Created by 최서경 on 2/26/24.
//

import UIKit
import SnapKit


class SearchResultView: BaseView {
    let searchResultCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        view.register(SearchResultCodeCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCodeCollectionViewCell.identifier)
        view.backgroundColor = .black
        return view
    }()
    
    let amountLabel = UILabel()
    let sortButton: [SortButton] = [
        SortButton(),
        SortButton(),
        SortButton(),
        SortButton()
    ]
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: sortButton)
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 5
        return view
    }()

    
    override func configureHierarchy() {
        addSubview(searchResultCollectionView)
        addSubview(amountLabel)
        addSubview(stackView)
    }
    
    override func configureLayout() {
        amountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        amountLabel.font = .systemFont(ofSize: 13)
        amountLabel.textColor = UIColor(named: Color.PointColor.rawValue)
        
        for count in 0 ... sortButton.count - 1 {
            sortButton[count].tag = count
            sortButton[count].setTitle("\(sortWay.allCases[count].sortList)", for: .normal)
            sortButton[count].tintColor = .white
            sortButton[count].layer.borderWidth = 1
            sortButton[count].layer.cornerRadius = sortButton[count].bounds.width * 0.3
            sortButton[count].layer.borderColor = UIColor.white.cgColor
            sortButton[count].titleLabel?.font = .boldSystemFont(ofSize: 15)
        }
    }
    
    static func setCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
}
