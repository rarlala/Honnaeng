//
//  MainView.swift
//  Honnaeng
//
//  Created by Rarla on 3/15/24.
//

import UIKit

final class MainView: UIView {
    
    // MARK: - Diffable DataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, FoodData>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    private var foodData: [FoodData] = [
        //    TODO: - 첫번째 아이템 추가 버튼으로 구성
        //    FoodData(name: "➕"),
            FoodData(name: "사과",
                     count: 3,
                     unit: .quantity,
                     group: .fruit,
                     storageType: .fridge,
                     storageName: "냉장고1",
                     emogi: "🍎"),
            FoodData(name: "포도",
                     count: 100,
                     unit: .weight,
                     group: .fruit,
                     storageType: .fridge,
                     storageName: "냉장고2",
                     emogi: "🍇"),
            FoodData(name: "계란",
                     count: 8,
                     unit: .quantity,
                     group: .dairy,
                     storageType: .fridge,
                     storageName: "냉장고1",
                     emogi: "🥚"),
            FoodData(name: "오징어",
                     count: 5,
                     unit: .quantity,
                     group: .seaFood,
                     storageType: .frozen,
                     storageName: "냉장고2",
                     emogi: "🦑"),
        ]
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - UI Components
    private let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        view.backgroundColor = UIColor(named: "white")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let plusRefrigeratorButton: UIButton = {
        let button = UIButton()
        let largeFont = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "plus.app", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "혼냉"
        label.font = .Heading3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let alertButton: UIButton = {
        let button = UIButton()
        let largeFont = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "bell", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let listBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["전체", "💧 냉장", "🧊 냉동"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let filterBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .equalSpacing
        return view
    }()
    
    private let refrigeraterFilter: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.titleLabel?.font = .Paragraph4
        return button
    }()
    
    private let listSortFilter: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.titleLabel?.font = .Paragraph4
        return button
    }()
    
    private lazy var foodListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = UIColor(named: "blue00")
        collectionView.layer.cornerRadius = 10
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.backgroundColor = UIColor(named: "gray00")
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchIcon: UIButton = {
        let largeFont = UIFont.systemFont(ofSize: 16)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - function
    private func setUp() {
        configureUI()
        configureSegmentControl()
        configureFilter()
        configurationCell()
        setUpSnapshot()
    }
    
    private func configureUI() {
        headerView.addArrangedSubview(plusRefrigeratorButton)
        headerView.addArrangedSubview(logoLabel)
        headerView.addArrangedSubview(alertButton)
        
        searchBox.addSubview(searchField)
        searchBox.addSubview(searchIcon)
        
        filterBox.addArrangedSubview(refrigeraterFilter)
        filterBox.addArrangedSubview(listSortFilter)
        
        mainView.addArrangedSubview(headerView)
        mainView.addArrangedSubview(segmentControl)
        mainView.addArrangedSubview(filterBox)
        
        mainView.addArrangedSubview(foodListView)
        mainView.addArrangedSubview(searchBox)
        
        self.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            refrigeraterFilter.heightAnchor.constraint(equalToConstant: 30),
            
            foodListView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            foodListView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            searchBox.heightAnchor.constraint(equalToConstant: 30),
            searchBox.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            searchBox.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            searchBox.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            searchField.topAnchor.constraint(equalTo: searchBox.topAnchor, constant: 2),
            searchField.widthAnchor.constraint(equalTo: searchBox.widthAnchor, multiplier: 0.9),

            searchIcon.widthAnchor.constraint(equalTo: searchBox.widthAnchor, multiplier: 0.1),
            searchIcon.topAnchor.constraint(equalTo: searchBox.topAnchor, constant: 2),
            searchIcon.trailingAnchor.constraint(equalTo: searchBox.trailingAnchor),
        ])
    }
    
    // MARK: - Drop down filter Setting
    // TODO: 유저가 추가한 냉장고 목록으로 변경 필요
    var refrigeraterList: [String] = ["전체 냉장고", "냉장고1", "냉장고2"]
    var menuChildren: [UIMenuElement] = []
    
    var sortList: [String] = ["유통기한 남은 순", "최근 추가 순"]
    var sortMenuChildren: [UIMenuElement] = []
    
    private func configureFilter() {
        for refrigerater in refrigeraterList {
            menuChildren.append(UIAction(title: refrigerater, handler: { _ in
                // TODO: 클릭에 따른 처리 필요
                print("")
            }))
        }
        
        refrigeraterFilter.menu = UIMenu(options: .displayInline, children: menuChildren)
        refrigeraterFilter.showsMenuAsPrimaryAction =  true
        refrigeraterFilter.changesSelectionAsPrimaryAction =  true
        
        for sort in sortList {
            sortMenuChildren.append(UIAction(title: sort, handler: { _ in
                // TODO: 클릭에 따른 처리 필요
                print("")
            }))
        }
        
        listSortFilter.menu = UIMenu(options: .displayInline, children: sortMenuChildren)
        listSortFilter.showsMenuAsPrimaryAction =  true
        listSortFilter.changesSelectionAsPrimaryAction =  true
    }
    
    // MARK: - segment control
    private func configureSegmentControl() {
        self.segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.segmentChanged(_: self.segmentControl)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // TODO: 클릭 시 list filtering 처리 (sender.selectedSegmentIndex 활용)
    }
    
    // MARK: - snapshot
    private func setUpSnapshot() {
        let foods = self.getData()
        var snapshot = NSDiffableDataSourceSnapshot<Section, FoodData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(foods)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configurationCell() {
        let foodBoxRegistration = UICollectionView.CellRegistration<FoodCell, FoodData> { cell, indexPath, itemIdentifier in
            cell.setFoodCell(food: itemIdentifier)
        }
                
        dataSource = DataSource(collectionView: foodListView) { (collectionView, indexPath, identifier) -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: foodBoxRegistration, for: indexPath, item: identifier)
        }
    }
    
    // TODO: VM로 분리
    func getData() -> [FoodData] {
        return self.foodData
    }
}

// MARK: - Collection View Layout
extension MainView {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 4), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}
