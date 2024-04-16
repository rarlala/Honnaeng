//
//  FoodDetailViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/18/24.
//

import UIKit
import AVKit
import PhotosUI

final class FoodDetailViewController: UIViewController {
    
    var viewModel: MainViewModel
    var mode: FoodDetailPageMode = .add
    var delegate: MainViewUpdateDelegate?
    var savedData: FoodData?
    var name: String?
    
    var activeTextField: UITextField?
    
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
        if mode == .addToBarcode {
            setName()
        }
        configureButton()
        configurePicker()
        configureTextField()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
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
    
    private let imageBox = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "gray00")?.cgColor
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        view.tintColor = UIColor(named: "gray00")
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        label.text = "냉장고명 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let storageName: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .Paragraph3
        button.backgroundColor = UIColor(named: "gray01")
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.square.badge.camera"), for: .normal)
        button.tintColor = UIColor(named: "white")
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "blue03")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let typeLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "보관 방법 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let typeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["냉장", "냉동", "실온"])
        control.selectedSegmentIndex = 0
        if let font: UIFont = .Paragraph3 {
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .font: font
            ]
            control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        }
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let groupLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "분류 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let groupName: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .Paragraph3
        button.backgroundColor = UIColor(named: "gray01")
        button.setTitleColor(UIColor(named: "black"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "재료명 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재료명을 입력하세요"
        textField.font = .Paragraph3
        textField.textAlignment = .right
        textField.returnKeyType = .done
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
        label.text = "수량 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let countTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "숫자를 입력하세요"
        textField.font = .Paragraph3
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let countControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["개", "g"])
        control.selectedSegmentIndex = 0
        if let font: UIFont = .Paragraph3 {
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .font: font
            ]
            control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        }
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
        label.text = "유통기한 *"
        label.font = .Paragraph3
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko-KR")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let memoLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .Paragraph3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let memoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모를 입력하세요"
        textField.font = .Paragraph3
        textField.textAlignment = .right
        textField.setContentHuggingPriority(.defaultLow, for: .vertical)
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let buttonLineStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor(named: "red01"), for: .normal)
        button.layer.borderColor = UIColor(named: "red01")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .Paragraph3
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(named: "gray03")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .Paragraph2
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let title = self.mode == .add ? "추가" : "저장"
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(named: "blue03")
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .Paragraph2
        return button
    }()
    
    private func configureUI() {
        storageLineStackView.addArrangedSubview(storageLabel)
        storageLineStackView.addArrangedSubview(storageName)
        
        imageBox.addSubview(imageView)
        imageBox.addSubview(addImageButton)
        
        groupLineStackView.addArrangedSubview(groupLabel)
        groupLineStackView.addArrangedSubview(groupName)
        
        typeLineStackView.addArrangedSubview(typeLabel)
        typeLineStackView.addArrangedSubview(typeSegmentedControl)
        
        nameLineStackView.addArrangedSubview(nameLabel)
        nameLineStackView.addArrangedSubview(nameTextField)
        
        countLineStackView.addArrangedSubview(countLabel)
        countLineStackView.addArrangedSubview(countTextField)
        countLineStackView.addArrangedSubview(countControl)
        
        dateLineStackView.addArrangedSubview(dateLabel)
        dateLineStackView.addArrangedSubview(datePicker)
        
        memoLineStackView.addArrangedSubview(memoLabel)
        memoLineStackView.addArrangedSubview(memoTextField)
        
        buttonLineStackView.addArrangedSubview(deleteButton)
        buttonLineStackView.addArrangedSubview(cancelButton)
        buttonLineStackView.addArrangedSubview(addButton)
        
        mainView.addArrangedSubview(titleLabel)
        mainView.addArrangedSubview(imageBox)
        mainView.addArrangedSubview(storageLineStackView)
        mainView.addArrangedSubview(typeLineStackView)
        mainView.addArrangedSubview(groupLineStackView)
        mainView.addArrangedSubview(nameLineStackView)
        mainView.addArrangedSubview(countLineStackView)
        mainView.addArrangedSubview(dateLineStackView)
        mainView.addArrangedSubview(memoLineStackView)
        mainView.addArrangedSubview(buttonLineStackView)
        mainView.addArrangedSubview(buttonLineStackView)
        
        scrollView.addSubview(mainView)
        
        view.backgroundColor = UIColor(named: "white")
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.centerXAnchor.constraint(equalTo: imageBox.centerXAnchor),
            
            addImageButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            addImageButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: 30),
            addImageButton.heightAnchor.constraint(equalToConstant: 30),
            
            imageBox.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            storageName.widthAnchor.constraint(equalToConstant: 150),
            typeSegmentedControl.widthAnchor.constraint(equalToConstant: 150),
            groupName.widthAnchor.constraint(equalToConstant: 150),
            datePicker.widthAnchor.constraint(equalToConstant: 230),
            datePicker.heightAnchor.constraint(equalToConstant: 100),
            memoTextField.heightAnchor.constraint(equalToConstant: 40),
            
            buttonLineStackView.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalTo: buttonLineStackView.widthAnchor, multiplier: 0.2),
            addButton.widthAnchor.constraint(equalTo: buttonLineStackView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func setName() {
        guard let name = name else { return }
        nameTextField.text = name
    }
    
    private func setData() {
        guard let type = savedData?.storageType,
              let name = savedData?.name,
              let count = savedData?.count,
              let unit = savedData?.unit,
              let exDate = savedData?.exDate
        else { return }
        
        typeSegmentedControl.selectedSegmentIndex = type.rawValue - 1
        nameTextField.text = name
        countTextField.text = String(count)
        countControl.selectedSegmentIndex = unit == .quantity ? 0 : 1
        datePicker.date = exDate
        
        if let imageUrl = savedData?.imageUrl {
            let image = ImageFileManager.shared.loadImageFromFileSystem(fileName: imageUrl)
            displayImage(image)
        } else {
            displayEmptyImage()
        }
        
        if let memo = savedData?.memo {
            memoTextField.text = memo
        }
    }
    
    // MARK: - Picker
    private func configurePicker() {
        let storageTitle = mode == .update ? savedData?.storageName : viewModel.getStorageList()[0]
        storageName.setTitle(storageTitle, for: .normal)
        storageName.addTarget(self, action: #selector(showRefrigeraterPicker), for: .touchUpInside)
        
        let groupTitle = mode == .update ? savedData?.group.rawValue : FoodGroup.allCases[0].rawValue
        groupName.setTitle(groupTitle, for: .normal)
        groupName.addTarget(self, action: #selector(showGroupPicker), for: .touchUpInside)
    }
    
    @objc private func showRefrigeraterPicker() {
        guard let currentSelect = storageName.titleLabel?.text else { return }
        showPickerPopup(datas: viewModel.getStorageList(), selectOption: currentSelect) { selectOption in
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
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isHidden = mode == .update ? false : true
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addImageButtonTapped() {
        presentPicker()
    }
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        guard let food = savedData else { return }
        
        PopUp.shared.showTwoButtonPopUp(self: self,
                                        title: "재료를 삭제하시겠습니까?",
                                        message: "삭제 시 복구 불가능합니다.") { [weak self] in
            self?.viewModel.deleteFoodData(food: food)
            self?.delegate?.updateMainViewData()
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        if let storageName = storageName.titleLabel?.text,
           let type = StorageType(rawValue: typeSegmentedControl.selectedSegmentIndex + 1),
           let selectGroup = groupName.titleLabel?.text,
           let group = FoodGroup(rawValue: selectGroup),
           let name = nameTextField.text,
           let count = countTextField.text,
           let countNum = Int(count),
           let unit: FoodUnit = countControl.selectedSegmentIndex == 0 ? .quantity : .weight {
            
            var food = FoodData(name: name,
                                count: countNum,
                                unit: unit,
                                group: group,
                                exDate: datePicker.date,
                                storageType: type,
                                storageName: storageName)
            
            if let memo = memoTextField.text {
                food.memo = memo
            }
            
            if let image = imageView.image {
                let path = ImageFileManager.shared.saveImageToFileSystem(image: image)
                food.imageUrl = path
            }
            
            switch mode {
            case .add, .addToBarcode:
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
        } else {
            PopUp.shared.showOneButtonPopUp(self: self, title: "재료 추가 실패", message: "필수 항목(*)을 모두 입력해야 합니다.")
        }
    }
    
    // MARK: - TextField
    private func configureTextField() {
        nameTextField.delegate = self
        countTextField.delegate = self
        memoTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        countTextField.inputAccessoryView = createToolbar(for: countTextField)
    }
    
    private func createToolbar(for textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            
            if let activeTextField = self.activeTextField {
                var aRect = self.view.frame
                aRect.size.height -= keyboardHeight
                if !aRect.contains(activeTextField.frame.origin) {
                    scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
                }
            }
        }
    }
    
    @objc private func keyboarWillHide() {
        view.frame.origin.y = 0
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension FoodDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 20
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

extension FoodDetailViewController: PHPickerViewControllerDelegate {
    func displayImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        imageView.contentMode = .scaleAspectFill
    }
    
    func displayDefaultImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        imageView.contentMode = .scaleAspectFit
    }
    
    func displayEmptyImage() {
        displayDefaultImage(UIImage(systemName: "photo.on.rectangle.angled"))
    }
    
    func displayErrorImage() {
        displayDefaultImage(UIImage(systemName: "exclamationmark.circle"))
    }
    
    func displayUnknownImage() {
        displayDefaultImage(UIImage(systemName: "questionmark.circle"))
    }
    
    func handleCompletion(object: Any?, error: Error? = nil) {
        if let image = object as? UIImage {
            displayImage(image)
        } else if let error = error {
            print("Couldn't display with error: \(error)")
            displayErrorImage()
        } else {
            displayUnknownImage()
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        if results.isEmpty {
            displayEmptyImage()
        } else {
            let currentSelection = results[0]
            let itemProvider = currentSelection.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.handleCompletion(object: image, error: error)
                    }
                }
            }
        }
    }
}

