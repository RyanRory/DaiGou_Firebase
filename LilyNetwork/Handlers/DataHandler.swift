//
//  DataHandler.swift
//  LilyNetwork
//
//  Created by 赵润声 on 31/3/18.
//

import Foundation
import UIKit
import Firebase

class DataHandler {
    static let sharedInstance = DataHandler()
    
    func dataFromServer(from: Array<String>, callback: @escaping (_ result: [String: Any]? ) ->()) {
        var ref = Database.database().reference()
        for item in from {
            ref = ref.child(item)
        }
        ref.observeSingleEvent(of: .value, with: { snapshot in
            callback(snapshot.value as? [String: Any])
        }) { error in
            print(error.localizedDescription)
            callback(nil)
        }
    }
    
    func dataWithQuery(from: Array<String>, parameter: [String: Any], args: [String: Any]? = nil, callback: @escaping (_ result: [String: Any]?, _ args: [String: Any]? ) ->()) {
        var ref = Database.database().reference()
        for item in from {
            ref = ref.child(item)
        }
        for (key, val) in parameter {
            let query = ref.queryOrdered(byChild: key).queryEqual(toValue: val)
            print(query)
            query.observeSingleEvent(of: .value, with: { snapshot in
                callback(snapshot.value as? [String: Any], args)
            }) { error in
                print(error.localizedDescription)
                callback(nil, args)
            }
        }
    }
    
    func setDataWithAutoId(to: Array<String>, parameters: [String: Any], callback: @escaping (_ error: Error? ) -> ()) {
        var ref = Database.database().reference()
        for item in to {
            ref = ref.child(item)
        }
        ref = ref.childByAutoId()
        var para = parameters
        para["id"] = ref.key
        var flag = 0
        for (key, val) in para {
            ref = ref.child(key)
            ref.setValue(val) { (error, reference) in
                if let error = error {
                    print(error.localizedDescription)
                    callback(error)
                    ref.removeValue()
                    return
                }
                else {
                    flag += 1
                    if flag == para.count {
                        callback(nil)
                    }
                }
            }
            ref = ref.parent!
        }
    }
    
    func setData(to: Array<String>, parameters: [String: Any], callback: @escaping () -> ()) {
        var ref = Database.database().reference()
        for item in to {
            ref = ref.child(item)
        }
        
        for (key, val) in parameters {
            ref = ref.child(key)
            ref.setValue(val)
            ref = ref.parent!
        }
    }
    
    func deleteData(from: Array<String>) {
        var ref = Database.database().reference()
        for item in from {
            ref = ref.child(item)
        }
        ref.removeValue()
    }
}
