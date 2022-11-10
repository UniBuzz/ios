//
//  ColorExtension.swift
//  UniBuzz
//
//  Created by Kevin ahmad on 21/09/22.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let creamyYellow = UIColor.rgb(red: 255, green: 234, blue: 143)
    static let stoneGrey = UIColor.rgb(red: 56, green: 56, blue: 56)
    static let eternalBlack = UIColor.rgb(red: 34, green: 34, blue: 34)
    static let midnights = UIColor.rgb(red: 43, green: 43, blue: 43)
    static let cloudSky = UIColor.rgb(red: 171, green: 171, blue: 171)
    static let heavenlyWhite = UIColor.rgb(red: 249, green: 249, blue: 249)
    static let storm = UIColor.rgb(red: 82, green: 82, blue: 82)
    static let warningRed = UIColor.rgb(red: 255, green: 142, blue: 142)
    static let greyBackground = UIColor.rgb(red: 83, green: 83, blue: 83)
}
