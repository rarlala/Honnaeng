//
//  StorageListTableViewController.swift
//  Honnaeng
//
//  Created by Rarla on 3/22/24.
//

import UIKit

class StorageListTableViewController: UITableViewController {
    
    let viewModel: MainViewModel?
    let delegate: MainViewDelegate?
    
    init(viewModel: MainViewModel, delegate: MainViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.getRefrigeraterList().count else { return 0 }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = viewModel?.getRefrigeraterList()[indexPath.row]
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Table Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.text = "냉장고 관리"
        label.textAlignment = .center
        label.font = .Heading3
        headerView.addSubview(label)
        
        let largeFont = UIFont.systemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        
        let backButton = UIButton()
        backButton.frame = CGRectMake(10, 10, 30, 30)
        backButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: configuration), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        let button = UIButton()
        button.frame = CGRectMake(headerView.frame.width - 40, 10, 30, 30)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        headerView.addSubview(button)
        
        return headerView
    }
    
    @objc private func backButtonTapped() {
        delegate?.updateStorageData()
        self.dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let confirmAction: (_ name: String, _ idx: Int?) -> Void = {name, idx in
            self.viewModel?.addRefrigeraterList(name: name)
        }
        
        showPopup(title: "냉장고 추가", message: "추가할 냉장고 이름을 입력하세요",  confirmButtonTitle: "추가", defaultText: nil, idx: nil, confirmAction: confirmAction)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    // MARK: - Table Cell Edit
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let text = viewModel?.getRefrigeraterList()[indexPath.row]
        let editConfirmAction: (_ name: String, _ idx: Int?) -> Void = {[self] name, idx in
            self.viewModel?.updateRefrigeraterList(name: name, idx: idx)
        }
        let editItem = UIContextualAction(style: .normal, title: "수정") { contextualAction, view, boolValue in
            self.showPopup(title: "냉장고 이름 수정", message: "수정할 이름을 입력하세요", confirmButtonTitle: "수정", defaultText: text, idx: indexPath.row, confirmAction: editConfirmAction)
        }
        editItem.image = UIImage(systemName: "pencil")
        
//        let deleteConfirmAction: (_ name: String) -> Void = {[self] name in
////            self.viewModel?.delete(name: name)
//        }
//        let deleteItem = UIContextualAction(style: .destructive, title: "삭제") { contextualAction, view, boolValue in
//             print("delete")
//        }
//        deleteItem.image = UIImage(systemName: "trash")
        
//        let swipeAction = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
        let swipeAction = UISwipeActionsConfiguration(actions: [editItem])
        return swipeAction
    }
    
    // MARK: - show popup
    private func showPopup(title: String, message: String, confirmButtonTitle: String,  defaultText: String?, idx: Int?, confirmAction: @escaping (_ name: String, _ idx: Int?) -> Void) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addTextField()
        
        if let text = defaultText {
            popup.textFields?.first?.text = text
        }
        
        let confirmAlertAction = UIAlertAction(title: confirmButtonTitle, style: .default) { [self] _ in
            guard let name = popup.textFields?.first?.text else { return }
            confirmAction(name, idx)
            self.tableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
        popup.addAction(cancelAlertAction)
        popup.addAction(confirmAlertAction)
        
        self.present(popup, animated: true)
    }
}
