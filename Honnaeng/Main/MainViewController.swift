//
//  MainViewController.swift
//  Honnaeng
//
//  Created by Rarla on 2024/03/05.
//

import UIKit

final class MainViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let mainView = MainView(frame: self.view.frame)
        self.view = mainView
        
        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
    }

}
