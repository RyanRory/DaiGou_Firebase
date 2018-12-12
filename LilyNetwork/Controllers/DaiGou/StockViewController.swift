//
//  StockViewController.swift
//  LilyNetwork
//
//  Created by 赵润声 on 1/4/18.
//

import UIKit
import ActionSheetPicker_3_0
import SCLAlertView_Objective_C

class StockViewController: UIViewController {
    
    @IBOutlet var tView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    
    var products: Array<String> = []
    var qualities: Array<String> = []
    var locations: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 5
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

extension StockViewController {
    @objc func confirm(sender: UIButton) {
        let builder = SCLAlertViewBuilder().shouldDismissOnTapOutside(false)
        let show = SCLAlertViewShowBuilder().style(.notice)?.title("(┙>∧<)┙へ┻┻")?.subTitle("\n正在上传数据\n")
        show?.show(builder?.alertView, on: self)
        
        for i in 0...self.products.count-1 {
            let para = ["name": self.products[i],
                        "amount": self.qualities[i],
                        "location": self.locations[i]]
        }
    }
}

extension StockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identiferStr:String = "StockTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identiferStr, for: indexPath)
        
        if indexPath.row == self.products.count {
            cell.textLabel?.text = "+ 添加商品"
            cell.textLabel?.textColor = BUTTON_BLUE
        }
        else {
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = self.products[indexPath.row] + " × " + self.qualities[indexPath.row] + " @ " + self.locations[indexPath.row]
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
        
        if indexPath.row == self.products.count {
            ActionSheetManager.sharedInstance.showActionSheet(vc: self, vcClass: "StockViewController")
        }
        else {
            let picker = ActionSheetMultipleStringPicker(title: "请选择数量/地点", rows: [PICKER_AMOUNT_ARRAY, PICKER_LOCATION_ARRAY], initialSelection: [0,0], doneBlock: { (picker, indexes, values) in
                self.qualities[indexPath.row] = PICKER_AMOUNT_ARRAY[indexes![0] as! Int].trimmingCharacters(in: .whitespaces)
                self.locations[indexPath.row] = PICKER_LOCATION_ARRAY[indexes![1] as! Int].trimmingCharacters(in: .whitespaces)
                self.tView.reloadData()
            }, cancel: {_ in return}, origin: self.view)
            picker?.pickerTextAttributes[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 20)
            picker?.pickerBackgroundColor = SEPERATOR_GRAY
            picker?.show()
        }
    }
}
