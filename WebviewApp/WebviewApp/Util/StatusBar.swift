//
//  StatusBar.swift
//  WebviewApp
//
//  Created by 심 승민 on 2018. 6. 18..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit

struct StatusBar {
    static func setBackgroundColor(_ color: UIColor) {
        if let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
}
