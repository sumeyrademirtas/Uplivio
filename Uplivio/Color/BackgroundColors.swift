//
//  BackgroundColors.swift
//  Uplivio
//
//  Created by Sümeyra Demirtaş on 10/17/24.
import UIKit

enum BackgroundColors: CaseIterable {
    case mediumOliveGreen
    case mediumMustard
    case oceanAqua
    case teal
    case coral
    case royalBlue
    case peach
    case turkishRose
    case slateBlue
    case pastelGreen

    // Farklı renkleri döndüren fonksiyon
    func color() -> UIColor {
        switch self {
        case .mediumOliveGreen:
            return UIColor(hex: "#7DA05F", alpha: 1.0) // Medium Olive Green (Orta Zeytin Yeşili)
        case .mediumMustard:
            return UIColor(hex: "#D4A528", alpha: 1.0) // Medium Mustard (Orta Hardal)
        case .oceanAqua:
            return UIColor(hex: "#00CED1", alpha: 1.0) // Ocean Aqua
        case .teal:
            return UIColor(hex: "#008080", alpha: 1.0) // Teal
        case .coral:
            return UIColor(hex: "#FF7F50", alpha: 1.0) // Coral
        case .royalBlue:
            return UIColor(hex: "#4169E1", alpha: 1.0) // Royal Blue
        case .peach:
            return UIColor(hex: "#FFDAB9", alpha: 1.0) // Peach
        case .turkishRose:
            return UIColor(hex: "#B57281", alpha: 1.0) // Turkish Rose
        case .slateBlue:
            return UIColor(hex: "#6A5ACD", alpha: 1.0) // Slate Blue
        case .pastelGreen:
            return UIColor(hex: "#A3C586", alpha: 1.0) // Pastel Green
        }
    }

    // İki farklı rastgele renk seçen fonksiyon
    static func randomTwoColors() -> (color1: UIColor, color2: UIColor) {
        let firstColor = BackgroundColors.allCases.randomElement()!
        var secondColor = BackgroundColors.allCases.randomElement()!

        // İkinci rengin birinciyle aynı olmadığından emin ol
        while firstColor == secondColor {
            secondColor = BackgroundColors.allCases.randomElement()!
        }

        return (color1: firstColor.color(), color2: secondColor.color())
    }
}
