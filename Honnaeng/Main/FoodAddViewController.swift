//
//  FoodAddViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/18/24.
//

import UIKit

final class FoodAddViewController: UIViewController {
    
    var delegate: MainViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
        configureFilter()
    }
    
    private let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "직접 입력"
        label.textAlignment = .center
        label.font = .Heading3
        return label
    }()
    
    private let storageLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // TODO: 냉장고 구분 추가 시 작업
    //    private let storageLabel: UILabel = {
    //        let label = UILabel()
    //        label.text = "냉장고 선택"
    //        return label
    //    }()
    //
    //    private let storageTextField: UITextField = {
    //        let textField = UITextField()
    //        textField.placeholder = "냉장고"
    //        return textField
    //    }()
    
    private let storageFilter: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.titleLabel?.font = .Paragraph4
        return button
    }()
    
    private let typeLabel: UISegmentedControl = {
        let control = UISegmentedControl(items: ["💧 냉장", "🧊 냉동"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let nameLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupFilter: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.titleLabel?.font = .Paragraph4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Drop down filter Setting
    // TODO: 유저가 추가한 냉장고 목록으로 변경 필요
    var storageList: [String] = ["전체 냉장고", "냉장고1", "냉장고2"]
    var storageMenuChildren: [UIMenuElement] = []
    
    var groupMenuChildren: [UIMenuElement] = []
    
    private let countLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "수량"
        return label
    }()
    
    private let countTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "숫자를 입력하세요"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let countControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["개", "g"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date"
        return label
    }()
    
    private let dateTextField: UICalendarView = {
        let textField = UICalendarView()
        return textField
    }()
    
    private let memoLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let memoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모를 입력하세요"
        textField.layer.borderColor = UIColor(named: "gray01")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let buttonLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(named: "gray03")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.backgroundColor = UIColor(named: "blue03")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private func configureUI() {
//        storageLineStackView.addArrangedSubview(storageLabel)
//        storageLineStackView.addArrangedSubview(storageTextField)
        
        nameLineStackView.addArrangedSubview(groupFilter)
        nameLineStackView.addArrangedSubview(nameTextField)
        
        countLineStackView.addArrangedSubview(countLabel)
        countLineStackView.addArrangedSubview(countTextField)
        countLineStackView.addArrangedSubview(countControl)
        
        memoLineStackView.addArrangedSubview(memoLabel)
        memoLineStackView.addArrangedSubview(memoTextField)
        
        buttonLineStackView.addArrangedSubview(cancelButton)
        buttonLineStackView.addArrangedSubview(addButton)
        
        mainView.addArrangedSubview(titleLabel)
//        mainView.addArrangedSubview(storageLineStackView)
        mainView.addArrangedSubview(typeLabel)
        mainView.addArrangedSubview(nameLineStackView)
        mainView.addArrangedSubview(countLineStackView)
        mainView.addArrangedSubview(memoLineStackView)
        mainView.addArrangedSubview(buttonLineStackView)
        
        view.addSubview(mainView)
        view.backgroundColor = UIColor(named: "white")
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            groupFilter.widthAnchor.constraint(equalTo: nameLineStackView.widthAnchor, multiplier: 0.3),
            
            memoTextField.heightAnchor.constraint(equalToConstant: 50),
            
            buttonLineStackView.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalTo: buttonLineStackView.widthAnchor, multiplier: 0.6),
            
        ])
    }
    
    private func configureFilter() {
//        for refrigerater in storageList {
//            storageMenuChildren.append(UIAction(title: refrigerater, handler: { _ in
//                // TODO: 클릭에 따른 처리 필요
//                print("")
//            }))
//        }
//        
//        storageFilter.menu = UIMenu(options: .displayInline, children: storageMenuChildren)
//        storageFilter.showsMenuAsPrimaryAction = true
//        storageFilter.changesSelectionAsPrimaryAction = true
        
        for group in FoodGroup.allCases {
            groupMenuChildren.append(UIAction(title: group.rawValue, handler: { _ in
                // TODO: 클릭에 따른 처리 필요
                print("")
            }))
        }
        
        groupFilter.menu = UIMenu(options: .displayInline, children: groupMenuChildren)
        groupFilter.showsMenuAsPrimaryAction = true
        groupFilter.changesSelectionAsPrimaryAction = true
    }
    
    private func configureButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        
        let type = typeLabel.selectedSegmentIndex == 0 ? StorageType.fridge : StorageType.fridge
        
        // TODO : 추가할 수 있을때만
        if let name = nameTextField.text,
           let count = countTextField.text,
           let countNum = Int(count),
           let selectGroup = groupFilter.currentTitle,
           let group = FoodGroup(rawValue: selectGroup),
           let memo = memoTextField.text {
            
            let food = FoodData(name: name,
                                count: countNum,
                                unit: .quantity,
                                group: group,
                                storageType: type,
                                memo: memo)
            
            delegate?.addFoodData(food: food)
            self.dismiss(animated: true)
        }
    }
}
