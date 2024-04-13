//
//  FoodCardCell.swift
//  Honnaeng
//
//  Created by Rarla on 3/16/24.
//

import UIKit

final class FoodCardCell: UICollectionViewCell {
    
    private let shadowBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "white")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    private let borderBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackBox: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let infoLine: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()
    
    private let frozenEmoji: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "food")
        imageView.tintColor = UIColor(named: "gray00")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Paragraph3
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray04")
        label.font = .Paragraph4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .Paragraph4
        label.textColor = UIColor(named: "white")
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - function
    private func configuration() {
        NSLayoutConstraint.activate([
            shadowBox.topAnchor.constraint(equalTo: stackBox.topAnchor),
            shadowBox.leadingAnchor.constraint(equalTo: stackBox.leadingAnchor),
            shadowBox.trailingAnchor.constraint(equalTo: stackBox.trailingAnchor),
            shadowBox.bottomAnchor.constraint(equalTo: stackBox.bottomAnchor),
            
            borderBox.topAnchor.constraint(equalTo: stackBox.topAnchor),
            borderBox.leadingAnchor.constraint(equalTo: stackBox.leadingAnchor),
            borderBox.trailingAnchor.constraint(equalTo: stackBox.trailingAnchor),
            borderBox.bottomAnchor.constraint(equalTo: stackBox.bottomAnchor),
            
            stackBox.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            infoLine.leadingAnchor.constraint(equalTo: stackBox.leadingAnchor),
            infoLine.trailingAnchor.constraint(equalTo: stackBox.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: stackBox.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            exDateLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 4),
            exDateLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4),
            exDateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
    
            nameLabel.leadingAnchor.constraint(equalTo: stackBox.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: stackBox.trailingAnchor),
        ])
    }
    
    func setFoodCardCell(food: FoodData) {
        if let imageUrl = food.imageUrl {
            let image = ImageFileManager.shared.loadImageFromFileSystem(fileName: imageUrl)
            imageView.image = image
        } else {
            imageView.image = food.defaultImage
        }
        stackBox.addArrangedSubview(imageView)
        addShadowToView(shadowBox)
        
        frozenEmoji.text = food.storageType == .frozen ? "❄️" : " "
        countLabel.text = String(food.count) + (food.unit == .quantity ? "개" : "g")
        
        infoLine.addArrangedSubview(frozenEmoji)
        infoLine.addArrangedSubview(countLabel)
        stackBox.addArrangedSubview(infoLine)
    
        nameLabel.text = food.name
        stackBox.addArrangedSubview(nameLabel)
        
        exDateLabel.text = getDday(date: food.exDate)
        imageView.addSubview(exDateLabel)
        
        contentView.addSubview(shadowBox)
        shadowBox.addSubview(borderBox)
        borderBox.addSubview(stackBox)
        
        configuration()
    }
    
    func getDday(date: Date) -> String {
        let calendar = Calendar.current
        let startDate = Date()
        let endDate = date
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let dayCount = components.day else { return "" }
        
        if dayCount >= 7 {
            exDateLabel.backgroundColor = UIColor(named: "blue03")
        } else if dayCount > 3 {
            exDateLabel.backgroundColor = UIColor(named: "green02")
        } else if dayCount > 0 {
            exDateLabel.backgroundColor = UIColor(named: "red01")
        } else {
            exDateLabel.backgroundColor = UIColor(named: "black")
        }
        
        return "\(dayCount)일"
    }
    
    func addShadowToView(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        view.clipsToBounds = false
    }
}
