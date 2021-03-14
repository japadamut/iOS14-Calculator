//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Juan A. Pujante Adamut on 13/03/2021.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    
    // Rounded border
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Shine
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    
    // Appearance of operation button selection
    func selectOperation(_ selected: Bool) {
        backgroundColor = selected ? .white : orange
                setTitleColor(selected ? orange : .white, for: .normal)    }
}
