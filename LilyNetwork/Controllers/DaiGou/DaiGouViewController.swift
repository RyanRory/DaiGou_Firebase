//
//  DaiGouViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 12/3/18.
//

import UIKit
import LYEmptyView
import MJRefresh
import FTPopOverMenu

class DaiGouViewController: UIViewController {
    
    @IBOutlet var tView: UITableView!
    var dataSource: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(image: UIImage(named: "barButtonMenu"), style: .plain, target: self, action: #selector(showMenu))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.tView.ly_emptyView = LYEmptyView.empty(withImageStr: "caiGouEmpty", titleStr: "都买完啦!!", detailStr: "\n\n\n")
        self.tView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        self.tView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        self.dataSource = []
        DataHandler.sharedInstance.dataWithQuery(from: [ORDER], parameter: ["shipped": false]) { (result, args) in
            if let result = result {
                var unbought: [String: Int?] = [:]
                var bought: [String: Int?] = [:]
                var unboughtImage: [String: String?] = [:]
                var boughtImage: [String: String?] = [:]
                for item in result {
                    let dic = item.value as! [String: Any]
                    if (dic["bought"] as! Bool) {
                        bought[dic["productName"] as! String] = bought[dic["productName"] as! String] == nil ? (dic["productAmount"] as! Int) : bought[dic["productName"] as! String]!! + (dic["productAmount"] as! Int)
                        boughtImage[dic["productName"] as! String] = dic["imageUrl"] as? String
                    }
                    else {
                        unbought[dic["productName"] as! String] = unbought[dic["productName"] as! String] == nil ? (dic["productAmount"] as! Int) : unbought[dic["productName"] as! String]!! + (dic["productAmount"] as! Int)
                        unboughtImage[dic["productName"] as! String] = dic["imageUrl"] as? String
                    }
                }
                
                for item in unbought {
                    let imageUrl = (unboughtImage[item.key] as? String) == nil ? "" : unboughtImage[item.key] as? String
                    self.dataSource.append(["name": item.key,
                                            "amount": item.value!,
                                            "bought": false,
                                            "imageUrl": imageUrl!])
                }
                
                for item in bought {
                    let imageUrl = (boughtImage[item.key] as? String) == nil ? "" : boughtImage[item.key] as? String
                    self.dataSource.append(["name": item.key,
                                            "amount": item.value!,
                                            "bought": true,
                                            "imageUrl": imageUrl!])
                }
                
                self.tView.reloadData()
            }
            self.tView.mj_header.endRefreshing()
        }
    }

}

extension DaiGouViewController {

    @objc func showMenu(sender: UIBarButtonItem, event: UIEvent) {
        FTPopOverMenu.show(from: event, withMenuArray: ["     下单", "     发货", "     囤货"], imageArray: ["barButtonPlaceOrder", "barButtonShipping", "barButtonStock"], doneBlock: { selectIndex in
            switch selectIndex {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "XiaDanViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShippingViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockViewController")
                self.navigationController?.pushViewController(vc!, animated: true)
            default:
                print(selectIndex)
            }
        }, dismiss: nil)
    }
    
    @objc func setBought(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
        }
    }
}

extension DaiGouViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "DaiGouTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath) as! DaiGouTableViewCell
        
        cell.nameLabel.text = self.dataSource[indexPath.section]["name"] as? String
        cell.qualityLabel.text = "数量: " + "\(self.dataSource[indexPath.section]["amount"]!)"
        cell.productImageView.sd_setImage(with: URL(string: self.dataSource[indexPath.section]["imageUrl"] as! String), placeholderImage: UIImage(named: DEFAULT_IMAGE), options: [], completed: nil)
        
        if !(self.dataSource[indexPath.section]["bought"] as! Bool) {
            cell.boughtButton.isSelected = false
        }
        else {
            cell.boughtButton.isSelected = true
        }
        
        cell.boughtButton.tag = indexPath.section
        cell.boughtButton.addTarget(self, action: #selector(setBought), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
