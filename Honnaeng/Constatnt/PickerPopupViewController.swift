//
//  PickerPopupViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/24/24.
//

import UIKit

final class PickerPopupViewController: UIViewController {

    var datas: [String] = []
    var selectOption: String
    var completionHandler: ((String) -> Void)?
    
    init(datas: [String]) {
        self.datas = datas
        self.selectOption = datas[0]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPickerView.delegate = self
        mainPickerView.dataSource = self
        
        configureUI()
        configureButton()
    }
    
    private let mainPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor(named: "white")
        pickerView.layer.cornerRadius = 10
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor(named: "blue03")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureUI() {
        view.addSubview(mainPickerView)
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            mainPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            confirmButton.topAnchor.constraint(equalTo: mainPickerView.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: mainPickerView.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalTo: mainPickerView.widthAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureButton() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func confirmButtonTapped() {
        completionHandler?(selectOption)
        self.dismiss(animated: true)
    }
}

extension PickerPopupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        datas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        datas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectOption = datas[row]
    }
}
