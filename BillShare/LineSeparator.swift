//
//  LineSeparator.swift
//  BillShare
//
//  Created by Tyler Bobella on 9/4/17.
//  Copyright © 2017 Tyler Bobella. All rights reserved.
//

import Foundation
import UIKit


enum Line {
    case horizontal
    case vertical
}

class LineSeparator {
    
    
    func draw(_ direction: Line) -> UIView? {
        
        switch direction {
        case .horizontal:
            let lineView = UIView()
            lineView.layer.borderWidth = 1.0
            lineView.layer.borderColor = UIColor.black.cgColor
            lineView.translatesAutoresizingMaskIntoConstraints = false
            return lineView
        default:
            break
        }
        
        return nil
    }
}
