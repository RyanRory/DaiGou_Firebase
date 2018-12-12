//
//  ProductViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 1/4/18.
//

import UIKit
import MJRefresh

class ProductViewController: UIViewController {
    
    @IBOutlet var tView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    var dataSource: Array<[String: Any]> = []
    var ctrls: Array<[String: Any]> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.getData()
        })
        self.tView.mj_header.beginRefreshing()
    }
    
    func getData() {
        self.dataSource = []
        DataHandler.sharedInstance.dataFromServer(from: [PRODUCT]) { result in
            if let result = result {
                for item in result {
                    let dic = item.value as! [String: Any]
                    self.dataSource.append(dic)
                }
                if !(self.searchTextField.text?.isEmpty)! {
                    self.ctrls = SearchHandler.sharedInstance.search(from: self.dataSource, forString: self.searchTextField.text!)
                }
                else {
                    self.ctrls = self.dataSource
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

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ctrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "ProductTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath) as! ProductTableViewCell
        
        cell.productImageView.sd_setImage(with: URL(string: self.ctrls[indexPath.section]["imageUrl"] as! String), placeholderImage: UIImage(named: DEFAULT_IMAGE), options: [], completed: nil)
        cell.nameLabel.text = self.ctrls[indexPath.section]["name"] as? String
        cell.costLabel.text = "成本: " + (self.ctrls[indexPath.section]["cost"] as! String)
        cell.priceLabel.text = "售价: " + (self.ctrls[indexPath.section]["price"] as! String)
        cell.barcodeImageView.image = ImageHandler.generateBarCode128(barCodeStr: (self.ctrls[indexPath.section]["barcode"] as! String), barCodeSize: CGSize(width: 300, height: 70))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text?.isEmpty)! {
            self.ctrls = self.dataSource
        }
        else {
            self.ctrls = SearchHandler.sharedInstance.search(from: self.dataSource, forString: textField.text!)
        }
        self.tView.reloadData()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.ctrls = []
    }
}
