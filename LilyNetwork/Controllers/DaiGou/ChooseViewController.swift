//
//  ChooseViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 13/3/18.
//

import UIKit
import MJRefresh

class ChooseViewController: UIViewController {
    
    var names: Array<[String: Any]> = []
    var products: Array<[String: Any]> = []
    var vc: XiaDanViewController? = nil

    @IBOutlet var tView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var selectAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.selectAllButton.addTarget(self, action: #selector(selectAllCell), for: .touchUpInside)

        self.tView.allowsSelectionDuringEditing = true
        self.tView.setEditing(true, animated: true)
        
        self.tView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        self.tView.mj_header.beginRefreshing()
    }
    
    func getData() {
        if self.title == "选择购买人" {
            self.names = []
            DataHandler.sharedInstance.dataFromServer(from: [MEMBER]) { result in
                if let result = result {
                    for item in result {
                        let dic = item.value as! [String: Any]
                        self.names.append(dic)
                    }
                    self.tView.reloadData()
                }
                self.tView.mj_header.endRefreshing()
            }
        }
        else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChooseViewController {
    @objc func selectAllCell(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let count = self.title! == "选择购买人" ? self.names.count-1 : self.products.count-1
        if sender.isSelected {
            for i in 0...count {
                let indexPath = IndexPath(row: 0, section: i)
                self.tView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        else {
            for i in 0...count {
                let indexPath = IndexPath(row: 0, section: i)
                self.tView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @objc func confirm(sender: UIButton) {
        let count = self.title! == "选择购买人" ? self.names.count-1 : self.products.count-1
        if self.title == "选择购买人" {
            for i in 0...count {
                let indexPath = IndexPath(row: 0, section: i)
                let cell = self.tView.cellForRow(at: indexPath)
                if (cell?.isSelected)! {
                    self.vc?.names.append(self.names[i])
                }
            }
        }
        else {
            for i in 0...count {
                let indexPath = IndexPath(row: 0, section: i)
                let cell = self.tView.cellForRow(at: indexPath)
                if (cell?.isSelected)! {
                    self.vc?.products.append(self.products[i])
                    self.vc?.qualities.append("1")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChooseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.title == "选择购买人" {
            return self.names.count
        }
        else {
            return self.products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "ChooseTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath)
        
        if self.title == "选择购买人" {
            cell.textLabel?.text = (self.names[indexPath.section]["name"] as! String) + "  No. " + (self.names[indexPath.section]["id"] as! String)
            cell.textLabel?.textColor = UIColor.black
        }
        else {
            cell.textLabel?.text = self.products[indexPath.section]["name"] as? String
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO
    }
}
