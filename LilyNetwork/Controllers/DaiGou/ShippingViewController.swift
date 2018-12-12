//
//  ShippingViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 1/4/18.
//

import UIKit
import MJRefresh
import LYEmptyView

class ShippingViewController: UIViewController {

    @IBOutlet var tView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var selectAllButton: UIButton!
    
    var dataSource: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.selectAllButton.addTarget(self, action: #selector(selectAllCell), for: .touchUpInside)
        
        self.tView.allowsSelectionDuringEditing = true
        self.tView.setEditing(true, animated: true)
        
        self.tView.ly_emptyView = LYEmptyView.empty(withImageStr: "caiGouEmpty", titleStr: "都寄走啦!!", detailStr: "\n\n\n")
        self.tView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        self.tView.mj_header.beginRefreshing()
    }
    
    func getData() {
        self.dataSource = []
        DataHandler.sharedInstance.dataWithQuery(from: [ORDER], parameter: ["shipped": false]){ (result, args) in
            if let result = result {
                for item in result {
                    let dic = item.value as! [String: Any]
                    if (dic["bought"] as! Bool) {
                        self.dataSource.append(dic)
                    }
                }
                if self.dataSource.count == 0 {
                    self.selectAllButton.isEnabled = false
                }
                else {
                    self.selectAllButton.isEnabled = true
                }
                self.tView.reloadData()
            }
            self.tView.mj_header.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShippingViewController {
    @objc func selectAllCell(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            for i in 0...self.dataSource.count {
                let indexPath = IndexPath(row: 0, section: i)
                self.tView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        else {
            for i in 0...self.dataSource.count {
                let indexPath = IndexPath(row: 0, section: i)
                self.tView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    @objc func confirm(sender: UIButton) {
        
    }
}

extension ShippingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "ShippingTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath) as! ShippingTableViewCell
        
        cell.memberNameLabel.text = self.dataSource[indexPath.section]["memberName"] as? String
        cell.memberNoLabel.text = "No. " + (self.dataSource[indexPath.section]["memberNo"] as! String)
        cell.productNameLabel.text = self.dataSource[indexPath.section]["productName"] as? String
        cell.productAmountLabel.text = "数量: " + "\(self.dataSource[indexPath.section]["productAmount"]!)"
        cell.timeLabel.text = self.dataSource[indexPath.section]["time"] as? String
        cell.productImageView.sd_setImage(with: URL(string: self.dataSource[indexPath.section]["imageUrl"] as! String), placeholderImage: UIImage(named: DEFAULT_IMAGE), options: [], completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
}
