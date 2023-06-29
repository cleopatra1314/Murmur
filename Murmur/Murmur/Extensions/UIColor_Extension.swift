//
//  UIColor_Extension.swift
//  Murmur
//
//  Created by cleopatra on 2023/6/29.
//

import Foundation
import UIKit

private enum MURColor: String {
    // swiftlint:disable identifier_name
    case GrayScale0
    case GrayScale20
    case GrayScale40
    case GrayScale60
    case GrayScale80
    case GrayScale90
    case GrayScale100
    
    case PrimaryDefault
    case PrimaryLight
    case PrimaryMiddle
    case PrimaryDark
    
    case SecondaryDefault
    case SecondaryLight
    case SecondaryMiddle
    case SecondaryDark
    case SecondaryShine
    
    case ShadowLight
    case ShadowOfMessage
    // swiftlint:enable identifier_name
}

extension UIColor {
    
    static let GrayScale0 = murColor(.GrayScale0)
    static let GrayScale20 = murColor(.GrayScale20)
    static let GrayScale40 = murColor(.GrayScale40)
    static let GrayScale60 = murColor(.GrayScale60)
    static let GrayScale80 = murColor(.GrayScale80)
    static let GrayScale90 = murColor(.GrayScale90)
    static let GrayScale100 = murColor(.GrayScale100)
    
    static let PrimaryDefault = murColor(.PrimaryDefault)
    static let PrimaryLight = murColor(.PrimaryLight)
    static let PrimaryMiddle = murColor(.PrimaryMiddle)
    static let PrimaryDark = murColor(.PrimaryDark)
    
    static let SecondaryDefault = murColor(.SecondaryDefault)
    static let SecondaryLight = murColor(.SecondaryLight)
    static let SecondaryMiddle = murColor(.SecondaryMiddle)
    static let SecondaryDark = murColor(.SecondaryDark)
    static let SecondaryShine = murColor(.SecondaryShine)
    
    static let ShadowLight = murColor(.ShadowLight)
    static let ShadowOfMessage = murColor(.ShadowOfMessage)
    
    private static func murColor(_ color: MURColor) -> UIColor? {
        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return .gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
