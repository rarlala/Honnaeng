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
        view.backgroundColor = UIColor(named: "white")
        view.layer.cornerRadius = 10
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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        view.layer.borderColor = UIColor(named: "gray01")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let count: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "gray02")
        label.font = .Paragraph4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .Paragraph4
        label.textColor = UIColor(named: "white")
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
            
            countView.leadingAnchor.constraint(equalTo: count.leadingAnchor, constant: -2),
            countView.trailingAnchor.constraint(equalTo: count.trailingAnchor, constant: 2),
            
            count.centerYAnchor.constraint(equalTo: countView.centerYAnchor),
            count.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: box.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            exDate.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            exDate.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -2),
    
            name.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: box.trailingAnchor),
        ])
    }
    
    func setFoodCell(food: FoodData) {
        box.addArrangedSubview(imageView)
        if let imageUrl = food.imageUrl {
            let image = ImageFileManager.shared.loadImageFromFileSystem(fileName: imageUrl)
            imageView.image = image
        } else {
            imageView.image = food.defaultImage
        }
        addShadowToView(box)
        
        frozenEmoji.text = food.storageType == .frozen ? "❄️" : " "
        count.text = String(food.count) + (food.unit == .quantity ? "개" : "g")
        countView.addSubview(count)
        
        infoLine.addArrangedSubview(frozenEmoji)
        infoLine.addArrangedSubview(countView)
        box.addArrangedSubview(infoLine)
    
        name.text = food.name
        box.addArrangedSubview(name)
        
        exDate.text = getDday(date: food.exDate)
        imageView.addSubview(exDate)
        
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
            exDate.backgroundColor = UIColor(named: "blue03")
        } else if dayCount > 3 {
            exDate.backgroundColor = UIColor(named: "green02")
        } else {
            exDate.backgroundColor = UIColor(named: "red01")
        }
        
        return "D-\(dayCount)"
    }
    
    func addShadowToView(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        view.clipsToBounds = false
    }
}
