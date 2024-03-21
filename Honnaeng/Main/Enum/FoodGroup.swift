//
//  FoodGroup.swift
//  Honnaeng
//
//  Created by Rarla on 3/15/24.
//

import Foundation

// 식품 분류에 참고한 사이트 : https://blog.naver.com/sourbear/221413916064
enum FoodGroup: String, CaseIterable {
    case fruit = "과일"
    case vegetable = "야채"
    case seaFood = "해산물"
    case meat = "고기"
    case dairy = "유제품"
    case frozenFood = "냉동식품"
    case bakery = "빵"
    case deli = "소세지류"
    case liquor = "주류"
    case beverages = "음료"
    case cannedJarredGoods = "캔/통조림"
    case dryGoods = "건"
    case personalCare = "건강"
    case cleaners = "청소"
}
