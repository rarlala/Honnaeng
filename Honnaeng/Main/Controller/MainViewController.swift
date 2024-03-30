//
//  MainViewController.swift
//  Honnaeng
//
//  Created by Rarla on 2024/03/05.
//

import UIKit

protocol MainViewDelegate {
    func updateMainViewData()
    func updateStorageData()
}

final class MainViewController: UIViewController, MainViewDelegate {
    
    private let viewModel = MainViewModel()
    
    // MARK: - Diffable DataSource
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, FoodData>
    
    enum Section {
        case main
    }
    
    private var dataSource: DataSource?
    
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
        if let image = UIImage(named: "icon_plus_storage")?.resized(toWidth: 25) {
             button.setImage(image, for: .normal)
         }
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
        let control = UISegmentedControl(items: ["전체", "냉장", "냉동", "실온"])
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
    
    private let buttonBox: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let addFoodButton: UIButton = {
        let button = UIButton()
        button.setTitle("➕", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "gray01")?.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let addFoodToBarcodeButton: UIButton = {
        let button = UIButton()
        let largeFont = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        button.setImage(UIImage(systemName: "barcode.viewfinder", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "gray01")?.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var foodListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "+를 눌러 재료를 추가해보세요!"
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray03")
        label.font = .Paragraph3
        label.isHidden = true
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIColor(named: "gray00")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configurePlusRefrigeratorButton()
        configureSegmentControl()
        configureFilter()
        configurationCell()
        setUpSnapshot()
        configureAddButtons()
        configureSearch()
    }
    
    func updateStorageData() {
        configureRefrigeraterList()
    }
    
    private func configureUI() {
        self.view.backgroundColor = UIColor(named: "white")
        
        headerView.addArrangedSubview(plusRefrigeratorButton)
        headerView.addArrangedSubview(logoLabel)
        headerView.addArrangedSubview(alertButton)
        
        filterBox.addArrangedSubview(refrigeraterFilter)
        filterBox.addArrangedSubview(listSortFilter)
        
        buttonBox.addArrangedSubview(addFoodButton)
        buttonBox.addArrangedSubview(addFoodToBarcodeButton)
        
        mainView.addArrangedSubview(headerView)
        mainView.addArrangedSubview(segmentControl)
        mainView.addArrangedSubview(searchField)
        mainView.addArrangedSubview(filterBox)
        mainView.addArrangedSubview(foodListView)
        mainView.addArrangedSubview(noDataLabel)
        mainView.addArrangedSubview(buttonBox)
        
        self.view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 50),
            refrigeraterFilter.heightAnchor.constraint(equalToConstant: 30),
            addFoodButton.heightAnchor.constraint(equalToConstant: 50),
            searchField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configurePlusRefrigeratorButton() {
        plusRefrigeratorButton.addTarget(self, action: #selector(addRefrigerator), for: .touchUpInside)
    }
    
    @objc private func addRefrigerator() {
        let storageView = StorageListTableViewController(viewModel: viewModel, delegate: self)
        storageView.modalPresentationStyle = .fullScreen
        present(storageView, animated: true)
    }
    
    // MARK: - Drop down filter Setting
    private func configureFilter() {
        configureRefrigeraterList()
        configureSortFilter()
    }
    
    private func configureRefrigeraterList() {
        var menuChildren: [UIMenuElement] = []
        menuChildren.append(UIAction(title: "전체 냉장고", handler: { select in
            self.viewModel.changeStorageName(name: select.title)
            self.setUpSnapshot()
        }))
        for refrigerater in viewModel.getStorageList() {
            menuChildren.append(UIAction(title: refrigerater, handler: { select in
                self.viewModel.changeStorageName(name: select.title)
                self.setUpSnapshot()
            }))
        }
        
        refrigeraterFilter.menu = UIMenu(options: .displayInline, children: menuChildren)
        refrigeraterFilter.showsMenuAsPrimaryAction =  true
        refrigeraterFilter.changesSelectionAsPrimaryAction =  true
    }
    
    private func configureSortFilter() {
        var sortMenuChildren: [UIMenuElement] = []
        for sort in viewModel.getSortTypeList() {
            sortMenuChildren.append(UIAction(title: sort, handler: { select in
                guard let type = ListSortType(rawValue: select.title) else { return }
                self.viewModel.changeSortType(type: type)
                self.setUpSnapshot()
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
        guard let type = StorageType(rawValue: sender.selectedSegmentIndex) else { return }
        viewModel.changeStorageType(type: type)
        setUpSnapshot()
    }
    
    // MARK: - snapshot
    private func setUpSnapshot() {
        let foods = self.viewModel.getFoodData()
        var snapshot = NSDiffableDataSourceSnapshot<Section, FoodData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(foods)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        foodListView.isHidden = foods.isEmpty
        noDataLabel.isHidden = !foods.isEmpty
    }
    
    private func configurationCell() {
        foodListView.delegate = self
        
        let foodBoxRegistration = UICollectionView.CellRegistration<FoodCell, FoodData> { cell, indexPath, itemIdentifier in
            cell.setFoodCell(food: itemIdentifier)
        }
        
        dataSource = DataSource(collectionView: foodListView) { (collectionView, indexPath, identifier) -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: foodBoxRegistration, for: indexPath, item: identifier)
        }
    }
    
    // MARK: - add Food Button
    private func configureAddButtons() {
        addFoodButton.addTarget(self, action: #selector(addFood), for: .touchUpInside)
        addFoodToBarcodeButton.addTarget(self, action: #selector(addFoodToBarcode), for: .touchUpInside)
    }
    
    @objc func addFood() {
        if viewModel.getStorageList().count == 0 {
            // TODO: Error Popup
            print("Error, 냉장고를 먼저 추가해주세요")
        } else {
            let foodAddView = FoodDetailViewController(viewModel: viewModel)
            foodAddView.modalPresentationStyle = .fullScreen
            foodAddView.delegate = self
            present(foodAddView, animated: true)
        }
    }
    
    @objc func addFoodToBarcode() {
        if viewModel.getStorageList().count == 0 {
            // TODO: Error Popup
            print("Error, 냉장고를 먼저 추가해주세요")
        } else {
            let foodAddToBarcodeView = BarcodeReaderViewController(viewModel: viewModel)
            foodAddToBarcodeView.modalPresentationStyle = .fullScreen
//            foodAddView.delegate = self
            present(foodAddToBarcodeView, animated: true)
        }
    }
    
    func updateMainViewData() {
        setUpSnapshot()
    }
    
    // MARK: - search
    private func configureSearch() {
        searchField.delegate = self
    }
}

// MARK: - Collection View Layout
extension MainViewController {
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

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = indexPath.row
        let foodData = viewModel.getFoodData()[idx]
        
        let foodAddView = FoodDetailViewController(viewModel: viewModel)
        foodAddView.modalPresentationStyle = .fullScreen
        foodAddView.mode = .update
        foodAddView.savedData = foodData
        foodAddView.delegate = self
        present(foodAddView, animated: true)
    }
}

extension MainViewController: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
        viewModel.changeSearchText(text: searchText)
        setUpSnapshot()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.changeSearchText(text: "")
        setUpSnapshot()
        return true
    }
}
