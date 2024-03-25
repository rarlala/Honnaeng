//
//  FoodDetailViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/18/24.
//

import UIKit

final class FoodDetailViewController: UIViewController {
    
    enum PageMode {
        case add, update
    }
    
    var mode: PageMode = .add
    var viewModel: MainViewModel
    var delegate: MainViewDelegate?
    var savedData: FoodData?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if mode == .update {
            setData()
        }
        configureButton()
        configurePicker()
    }
    
    private let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = mode == .add ? "직접 입력" : "재료 수정"
        label.textAlignment = .center
        label.font = .Heading3
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor(named: "red02"), for: .normal)
        return button
    }()
    
    private let storageLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let storageLabel: UILabel = {
        let label = UILabel()
        label.text = "냉장고명"
        return label
    }()
    
    private let storageName: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.titleLabel?.font = .Paragraph3
        button.titleLabel?.textAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let groupName: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .Paragraph4
        button.backgroundColor = UIColor(named: "purple02")
        button.setTitleColor(UIColor(named: "white"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.textAlignment = .right
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let countControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["개", "g"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let dateLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "유통기한"
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.locale = Locale(identifier: "ko-KR")
        return view
    }()
    
    private let emojiLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "이모지"
        return label
    }()
    
    private let emojiTextField: EmojiTextField = {
        let textField = EmojiTextField()
        textField.placeholder = "이모지를 입력하세요."
        textField.textAlignment = .right
        return textField
    }()
    
    private let memoLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.distribution = .fillProportionally
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
        textField.textAlignment = .right
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let title = self.mode == .add ? "추가" : "저장"
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(named: "blue03")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private func configureUI() {
        storageLineStackView.addArrangedSubview(storageLabel)
        storageLineStackView.addArrangedSubview(storageName)
        
        nameLineStackView.addArrangedSubview(groupName)
        nameLineStackView.addArrangedSubview(nameTextField)
        
        countLineStackView.addArrangedSubview(countLabel)
        countLineStackView.addArrangedSubview(countTextField)
        countLineStackView.addArrangedSubview(countControl)
        
        dateLineStackView.addArrangedSubview(dateLabel)
        dateLineStackView.addArrangedSubview(datePicker)
        
        emojiLineStackView.addArrangedSubview(emojiLabel)
        emojiLineStackView.addArrangedSubview(emojiTextField)
        
        memoLineStackView.addArrangedSubview(memoLabel)
        memoLineStackView.addArrangedSubview(memoTextField)
        
        buttonLineStackView.addArrangedSubview(cancelButton)
        buttonLineStackView.addArrangedSubview(addButton)
        
        mainView.addArrangedSubview(titleLabel)
        mainView.addArrangedSubview(storageLineStackView)
        mainView.addArrangedSubview(typeLabel)
        mainView.addArrangedSubview(nameLineStackView)
        mainView.addArrangedSubview(countLineStackView)
        mainView.addArrangedSubview(dateLineStackView)
        mainView.addArrangedSubview(emojiLineStackView)
        mainView.addArrangedSubview(memoLineStackView)
        
        mainView.addArrangedSubview(deleteButton)
        mainView.addArrangedSubview(buttonLineStackView)
        
        view.backgroundColor = UIColor(named: "white")
        view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            deleteButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            storageName.widthAnchor.constraint(equalTo: nameLineStackView.widthAnchor, multiplier: 0.5),
            groupName.widthAnchor.constraint(equalTo: nameLineStackView.widthAnchor, multiplier: 0.3),
            
            memoTextField.heightAnchor.constraint(equalToConstant: 40),
            
            buttonLineStackView.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalTo: buttonLineStackView.widthAnchor, multiplier: 0.6),
        ])
    }
    
    private func setData() {
        guard let type = savedData?.storageType,
              let name = savedData?.name,
              let count = savedData?.count,
              let unit = savedData?.unit,
              let exDate = savedData?.exDate
        else { return }
        
        typeLabel.selectedSegmentIndex = type == .fridge ? 0 : 1
        nameTextField.text = name
        countTextField.text = String(count)
        countControl.selectedSegmentIndex = unit == .quantity ? 0 : 1
        datePicker.date = exDate
        
        if let emogi = savedData?.emogi {
            emojiTextField.text = emogi
        }
        
        if let memo = savedData?.memo {
            memoTextField.text = memo
        }
    }
    
    // MARK: - Picker
    private func configurePicker() {
        let storageTitle = mode == .update ? savedData?.storageName : viewModel.getRefrigeraterList()[0]
        storageName.setTitle(storageTitle, for: .normal)
        storageName.addTarget(self, action: #selector(showRefrigeraterPicker), for: .touchUpInside)
        
        let groupTitle = mode == .update ? savedData?.group.rawValue : FoodGroup.allCases[0].rawValue
        groupName.setTitle(groupTitle, for: .normal)
        groupName.addTarget(self, action: #selector(showGroupPicker), for: .touchUpInside)
    }
    
    @objc private func showRefrigeraterPicker() {
        guard let currentSelect = storageName.titleLabel?.text else { return }
        showPickerPopup(datas: viewModel.getRefrigeraterList(), selectOption: currentSelect) { selectOption in
            self.storageName.setTitle(selectOption, for: .normal)
        }
    }
    
    @objc private func showGroupPicker() {
        guard let currentSelect = groupName.titleLabel?.text else { return }
        
        var datas: [String] = []
        for group in FoodGroup.allCases {
            datas.append(group.rawValue)
        }
                    
        showPickerPopup(datas: datas, selectOption: currentSelect) { selectOption in
            self.groupName.setTitle(selectOption, for: .normal)
        }
    }
    
    private func showPickerPopup(datas: [String], selectOption: String ,completionHandler: @escaping (String) -> Void) {
        let popup = PickerPopupViewController(datas: datas, selectOption: selectOption)
        popup.completionHandler = completionHandler
        self.present(popup, animated: true)
    }
    
    // MARK: - Button Action
    private func configureButton() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isHidden = mode == .add ? true : false
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        // TODO: 삭제 전 안내 팝업
        guard let uid = savedData?.uuid else { return }
        self.viewModel.deleteFoodData(uid: uid)
        self.delegate?.updateMainViewData()
        self.dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        
        let type: StorageType = typeLabel.selectedSegmentIndex == 0 ? .fridge : .frozen
        
        // TODO : 추가할 수 있을때만 추가
        // TODO : error 처리
        if let name = nameTextField.text,
           let count = countTextField.text,
           let countNum = Int(count),
           let selectGroup = groupName.titleLabel?.text,
           let group = FoodGroup(rawValue: selectGroup),
           let storageName = storageName.titleLabel?.text,
           let emoji = emojiTextField.text,
           let memo = memoTextField.text {
            
            var food = FoodData(name: name,
                                count: countNum,
                                unit: .quantity,
                                group: group,
                                exDate: datePicker.date,
                                storageType: type,
                                storageName: storageName,
                                emogi: emoji,
                                memo: memo)
            
            switch mode {
            case .add:
                viewModel.addFoodData(food: food)
                delegate?.updateMainViewData()
            case .update:
                guard let data = savedData else { return }
                food.uuid = data.uuid
                food.createDate = data.createDate
                viewModel.updateFoodData(food: food)
                delegate?.updateMainViewData()
            }
            
            self.dismiss(animated: true)
        }
    }
}
