//
//  SearchHandler.swift
//  LilyNetwork
//
//  Created by 赵润声 on 6/4/18.
//

import Foundation
import UIKit

class SearchHandler {
    static let sharedInstance = SearchHandler()
    
    func search(from: Array<[String: Any]>, forString: String) -> Array<[String: Any]> {
        var result: Array<[String: Any]> = []
        for item in from {
            for (_, val) in item {
                if let str = val as? String {
                    if str.range(of: forString) != nil {
                        result.append(item)
                        break
                    }
                }
            }
        }
        return result
    }
}
