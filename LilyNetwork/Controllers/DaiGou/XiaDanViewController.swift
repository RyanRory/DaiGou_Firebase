//
//  XiaDanViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 12/3/18.
//

import UIKit
import ActionSheetPicker_3_0
import SCLAlertView_Objective_C

class XiaDanViewController: UIViewController {
    
    @IBOutlet var tView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    
    var names: Array<[String: Any]> = []
    var products: Array<[String: Any]> = []
    var qualities: Array<String> = []
    var productNames: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XiaDanViewController {
    @objc func confirm(sender: UIButton) {
        if self.names.count == 0 || self.products.count == 0 {
            return
        }
        
        if self.names.count > 1 {
            self.handleMutipleNames()
        }
        else {
            self.handleMutipleProducts()
        }
    }
    
    func handleMutipleNames() {
        let builder = SCLAlertViewBuilder().shouldDismissOnTapOutside(false)
        let show = SCLAlertViewShowBuilder().style(.notice)?.title("(┙>∧<)┙へ┻┻")?.subTitle("\n正在上传数据\n")
        show?.show(builder?.alertView, on: self)
        
        var para: [String: Any] = ["shipped": false,
                                   "bought": false,
                                   "productName": self.products[0]["name"]!,
                                   "productAmount": (self.qualities[0] as NSString).integerValue,
                                   "imageUrl": self.products[0]["imageUrl"]!,
                                   "time": Date().formattedString()]
        
        var flag = 0
        for item in self.names {
            para["memberName"] = item["name"]
            para["memberNo"] = item["id"]
            
            DataHandler.sharedInstance.setDataWithAutoId(to: [ORDER], parameters: para) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    flag += 1
                    if flag == self.names.count {
                        builder?.alertView.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func handleMutipleProducts() {
        let builder = SCLAlertViewBuilder().shouldDismissOnTapOutside(false)
        let show = SCLAlertViewShowBuilder().style(.notice)?.title("(┙>∧<)┙へ┻┻")?.subTitle("\n正在上传数据\n")
        show?.show(builder?.alertView, on: self)
        
        var para: [String: Any] = ["shipped": false,
                                   "bought": false,
                                   "memberName": self.names[0]["name"]!,
                                   "memberNo": self.names[0]["id"]!,
                                   "time":Date().formattedString()]
        var index = 0
        var flag = 0
        for item in self.products {
            para["productName"] = item["name"]
            para["productAmount"] = (self.qualities[index] as NSString).integerValue
            para["imageUrl"] = item["imageUrl"]
            
            print(self.products)
            
            DataHandler.sharedInstance.setDataWithAutoId(to: [ORDER], parameters: para) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    flag += 1
                    if flag == self.products.count {
                        builder?.alertView.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            index += 1
        }
    }
}

extension XiaDanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 + self.names.count
        }
        else {
            return 1 + self.products.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "XiaDanTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath) 
        
        if indexPath.section == 0 {
            if indexPath.row == self.names.count {
                cell.textLabel?.text = "+ 添加购买人"
                cell.textLabel?.textColor = BUTTON_BLUE
            }
            else {
                cell.textLabel?.text = self.names[indexPath.row]["name"] as? String
                cell.textLabel?.textColor = UIColor.black
            }
        }
        else {
            if indexPath.row == self.products.count {
                cell.textLabel?.text = "+ 添加商品"
                cell.textLabel?.textColor = BUTTON_BLUE
            }
            else {
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.text = (self.products[indexPath.row]["name"] as! String) + " × " + self.qualities[indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ZERO
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == self.names.count {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseViewController") as! ChooseViewController
                vc.title = "选择购买人"
                vc.vc = self
                self.navigationController?.show(vc, sender: nil)
            }
        }
        else {
            if indexPath.row == self.products.count {
                ActionSheetManager.sharedInstance.showActionSheet(vc: self, vcClass: "XiaDanViewController")
            }
            else {
                let picker = ActionSheetMultipleStringPicker(title: "请选择数量", rows: [PICKER_AMOUNT_ARRAY], initialSelection: [0], doneBlock: { (picker, indexes, values) in
                    self.qualities[indexPath.row] = PICKER_AMOUNT_ARRAY[indexes![0] as! Int].trimmingCharacters(in: .whitespaces)
                    self.tView.reloadData()
                }, cancel: {_ in return}, origin: self.view)
                picker?.pickerTextAttributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 20)
                picker?.pickerBackgroundColor = SEPERATOR_GRAY
                picker?.show()
            }
        }
    }
}
