//
//  ExtensionDate.swift
//  LilyNetwork
//
//  Created by 赵润声 on 6/4/18.
//

import Foundation
import UIKit

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: self)
    }
}
