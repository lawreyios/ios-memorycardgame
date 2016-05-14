//
//  Device.swift
//  MySingTel
//
//  Created by 2359 Lawrence on 4/1/16.
//
//

import Foundation
import UIKit

class Device: NSObject {
    
    // MARK: Singletons
    
    static var TheCurrentDevice: UIDevice {
        struct Singleton {
            static let device = UIDevice.currentDevice()
        }
        return Singleton.device
    }
    
    static var TheCurrentDeviceHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.mainScreen().bounds.size.height
        }
        return Singleton.height
    }
    
    static var FontSizeToIncreaseBy: CGFloat {
        if self.IS_4_7_INCHES(){
            return 1
        }else if self.IS_5_5_INCHES_OR_LARGER(){
            return 2
        }else{
            return 0
        }
    }
    
    // MARK: iOS version
    
    static func IS_IOS8_OR_ABOVE() -> Bool {
        let result = (UIDevice.currentDevice().systemVersion as NSString).compare("8.0", options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
        return result
    }
    
    // MARK: - Device Size Checks
    
    enum Heights: CGFloat {
        case Inches_3_5 = 480
        case Inches_4 = 568
        case Inches_4_7 = 667
        case Inches_5_5 = 736
    }
    
    static func isSize(height: Heights) -> Bool {
        return TheCurrentDeviceHeight == height.rawValue
    }
    
    static func isSizeOrLarger(height: Heights) -> Bool {
        return TheCurrentDeviceHeight >= height.rawValue
    }
    
    static func isSizeOrSmaller(height: Heights) -> Bool {
        return TheCurrentDeviceHeight <= height.rawValue
    }
    
    static var CURRENT_SIZE: String {
        if IS_3_5_INCHES() {
            return "3.5 Inches"
        } else if IS_4_INCHES() {
            return "4 Inches"
        } else if IS_4_7_INCHES() {
            return "4.7 Inches"
        } else if IS_5_5_INCHES() {
            return "5.5 Inches"
        }
        return "\(TheCurrentDeviceHeight) Points"
    }
    
    // MARK: Retina Check
    
    static func IS_RETINA() -> Bool {
        return UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale))
    }
    
    static func isPhone() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .Phone
    }
    
    // MARK: 3.5 Inch Checks
    
    static func IS_3_5_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_3_5)
    }
    
    static func IS_3_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.Inches_3_5)
    }
    
    // MARK: 4 Inch Checks
    
    static func IS_4_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_4)
    }
    
    static func IS_4_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4)
    }
    
    static func IS_4_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrSmaller(.Inches_4)
    }
    
    // MARK: 4.7 Inch Checks
    
    static func IS_4_7_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4_7)
    }
    
    static func IS_4_7_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_4_7)
    }
    
    // MARK: 5.5 Inch Checks
    
    static func IS_5_5_INCHES() -> Bool {
        return isPhone() && isSize(.Inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_LARGER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_5_5)
    }
    
    static func IS_5_5_INCHES_OR_SMALLER() -> Bool {
        return isPhone() && isSizeOrLarger(.Inches_5_5)
    }
    
    func changeLabelFontSize (label: UILabel, size: CGFloat) -> UIFont {
        let font: UIFont = UIFont(name: label.font.fontName, size: size)!
        return font
    }
}