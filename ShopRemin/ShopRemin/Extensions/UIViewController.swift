//
//  UIViewController.swift
//  ShopRemin
//
//  Created by 吉原大喜 on 2022/03/03.
//

import Foundation
import UIKit

extension UIViewController {
    static let mainStoryboardName = "Main"
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: Self.mainStoryboardName, bundle: nil)
    }
    

}
