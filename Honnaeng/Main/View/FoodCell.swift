//
//  FoodCell.swift
//  Honnaeng
//
//  Created by Rarla on 3/16/24.
//

import UIKit

final class FoodCell: UICollectionViewCell {
    
    private let box: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.alignment = .center
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoLine: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    private let typeEmoji: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let image: UIImageView = {
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
    
    private let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Paragraph3
        return label
    }()
    
    private let countView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue03")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let count: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .Paragraph4
        label.textColor = UIColor(named: "white")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .Paragraph4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - function
    private func configuration() {
        NSLayoutConstraint.activate([
            box.topAnchor.constraint(equalTo: contentView.topAnchor),
            box.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            box.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            box.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            infoLine.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            infoLine.trailingAnchor.constraint(equalTo: box.trailingAnchor),
            
            count.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
            
            name.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: box.trailingAnchor),
        ])
    }
    
    func setFoodCell(food: FoodData) {
        typeEmoji.text = food.storageType == .fridge ? "💨" : "❄️"
        count.text = String(food.count) + (food.unit == .quantity ? "개" : "g")
        countView.addSubview(count)
        infoLine.addArrangedSubview(typeEmoji)
        infoLine.addArrangedSubview(countView)
        box.addArrangedSubview(infoLine)
        
        name.text = food.name
        box.addArrangedSubview(name)
        
        if food.emogi != nil {
            foodEmoji.text = food.emogi
            box.addArrangedSubview(foodEmoji)
        }
        
        if food.image != nil {
            box.addArrangedSubview(image)
        }
        
        exDate.text = getDday(date: food.exDate)
        box.addArrangedSubview(exDate)
        
        contentView.addSubview(box)
        
        configuration()
    }
    
    func getDday(date: Date) -> String {
        let calendar = Calendar.current
        let startDate = Date()
        let endDate = date
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let dayCount = components.day else { return "" }
        
        if dayCount >= 7 {
            exDate.textColor = UIColor(named: "blue03")
        } else if dayCount > 3 {
            exDate.textColor = UIColor(named: "green02")
        } else {
            exDate.textColor = UIColor(named: "red01")
        }
        
        return "\(dayCount)일 남음"
    }
}
