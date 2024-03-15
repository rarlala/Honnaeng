//
//  FoodCell.swift
//  Honnaeng
//
//  Created by Rarla on 3/16/24.
//

import UIKit

final class FoodCell: UICollectionViewCell {
    
    private let foodBox: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.alignment = .center
        view.spacing = 4
        view.layer.borderColor = UIColor(named: "blue02")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    TODO: - 첫번째 음식 항목에는 ADD 버튼 만들기
//    let foodAddButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "plus_icon"), for: .normal)
//        return button
//    }()
    
    private let foodImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "food")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let foodEmoji: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let foodName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Paragraph4
        return label
    }()
    
    // MARK: - function
    private func configuration() {
        NSLayoutConstraint.activate([
            foodBox.topAnchor.constraint(equalTo: contentView.topAnchor),
            foodBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            foodBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            foodBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            foodName.leadingAnchor.constraint(equalTo: foodBox.leadingAnchor),
            foodName.trailingAnchor.constraint(equalTo: foodBox.trailingAnchor),
        ])
    }
    
    func setFoodCell(food: FoodData) {
        foodName.text = food.name
        foodEmoji.text = food.emogi
        
        foodBox.addSubview(foodName)
        
        if food.emogi != nil {
            foodBox.addSubview(foodEmoji)
        }
        
        if food.image != nil {
            foodBox.addSubview(foodImage)
        }
        
        contentView.addSubview(foodBox)
        
        configuration()
    }
}
