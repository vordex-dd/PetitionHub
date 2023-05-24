//
//  ConfigColor.swift
//  PetitionHub
//
//  Created by Dmitry on 10.05.2023.
//

import Foundation
import UIKit


struct CONFIG {
    static let backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)

    static let deviderColor = UIColor(red: 40 / 255, green: 40 / 255, blue: 40 / 255, alpha: 1)
    static let secondaryBackgroudColor: UIColor = UIColor(red: 30 / 255,
                                                          green: 30 / 255,
                                                          blue: 30 / 255, alpha: 1)
    static let borderColor = CGColor(gray: 0.3, alpha: 1)
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 5
    static let cornerRadiusForSearch: CGFloat = 16
    static let segmentSelectedColor: UIColor = .systemGreen

    static let searchFieldTextColor: UIColor = .white
    static let segmentNotSelectedTextColor: UIColor = .white
    static let segmentSelectedTextColor: UIColor = .black
    
    static let cellTitleFontSize: CGFloat = 23
}
