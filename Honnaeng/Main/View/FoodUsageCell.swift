//
//  FoodUsageCell.swift
//  Honnaeng
//
//  Created by Rarla on 4/3/24.
//

import UIKit

class FoodUsageCell: UICollectionViewCell {
    let box: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelBox: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let exDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countBox: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let countField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let countStepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()
    
    func setFoodUsageCell(food: FoodData) {
        labelBox.addArrangedSubview(nameLabel)
        labelBox.addArrangedSubview(exDateLabel)
        
        countBox.addArrangedSubview(countField)
        countBox.addArrangedSubview(countStepper)
        
        box.addArrangedSubview(imageView)
        box.addArrangedSubview(labelBox)
        box.addArrangedSubview(countBox)
        
        self.contentView.addSubview(box)
        
        configurationUI()
    }
    
    func configurationUI() {
        
    }
}
