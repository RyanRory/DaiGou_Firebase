//
//  ActionSheetManager.swift
//  LilyNetwork
//
//  Created by 赵润声 on 30/3/18.
//

import UIKit
import zhPopupController
import BarcodeScanner
import SCLAlertView_Objective_C
import SDWebImage

class ActionSheetManager: NSObject {
    static let sharedInstance = ActionSheetManager()
    var viewController: UIViewController? = nil
    var barcodeScanner: BarcodeScannerViewController? = nil
    var vcClass: String = ""
    
    func showActionSheet(vc: UIViewController, vcClass: String) {
        self.viewController = vc
        self.vcClass = vcClass
        let actionSheet = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 163.5))
        actionSheet.backgroundColor = SEPERATOR_GRAY
        
        let takePhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        takePhotoButton.setTitle("扫一扫", for: .normal)
        takePhotoButton.setTitleColor(.black, for: .normal)
        takePhotoButton.setTitleColor(.white, for: .highlighted)
        takePhotoButton.setBackgroundImage(ImageHandler.imageWithColor(color: .white), for: .normal)
        takePhotoButton.setBackgroundImage(ImageHandler.imageWithColor(color: .lightGray), for: .highlighted)
        takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        let choosePhotoButton = UIButton(frame: CGRect(x: 0, y: 50.5, width: SCREEN_WIDTH, height: 50))
        choosePhotoButton.setTitle("从页面选择", for: .normal)
        choosePhotoButton.setTitleColor(.black, for: .normal)
        choosePhotoButton.setTitleColor(.white, for: .highlighted)
        choosePhotoButton.setBackgroundImage(ImageHandler.imageWithColor(color: .white), for: .normal)
        choosePhotoButton.setBackgroundImage(ImageHandler.imageWithColor(color: .lightGray), for: .highlighted)
        choosePhotoButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 108.5, width: SCREEN_WIDTH, height: 50))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.setTitleColor(.white, for: .highlighted)
        cancelButton.setBackgroundImage(ImageHandler.imageWithColor(color: .white), for: .normal)
        cancelButton.setBackgroundImage(ImageHandler.imageWithColor(color: .lightGray), for: .highlighted)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        
        actionSheet.addSubview(takePhotoButton)
        actionSheet.addSubview(choosePhotoButton)
        actionSheet.addSubview(cancelButton)
        
        vc.zh_popupController = zhPopupController.init(maskType: .blackTranslucent)
        vc.zh_popupController.layoutType = .bottom
        vc.zh_popupController.allowPan = true
        vc.zh_popupController.maskAlpha = 0.5
        
        vc.zh_popupController.presentContentView(actionSheet)
    }
}

extension ActionSheetManager {
    @objc func cancel(sender: UIButton) {
        self.viewController?.zh_popupController.dismiss()
    }
    
    @objc func takePhoto(sender: UIButton) {
        self.viewController?.zh_popupController.dismiss()
        self.barcodeScanner = BarcodeScannerViewController()
        self.barcodeScanner?.codeDelegate = self
        self.barcodeScanner?.errorDelegate = self
        self.barcodeScanner?.dismissalDelegate = self
        self.barcodeScanner?.title = "扫一扫"
        self.barcodeScanner?.messageViewController.errorTintColor = .red
        
        self.viewController?.navigationController?.pushViewController(self.barcodeScanner!, animated: true)
        
    }
    
    @objc func choosePhoto(sender: UIButton) {
        self.viewController?.zh_popupController.dismiss()
        
        let vc = self.viewController?.storyboard?.instantiateViewController(withIdentifier: "ChooseViewController") as! ChooseViewController
        vc.title = "选择商品"
        vc.vc = self.viewController as? XiaDanViewController
        self.viewController?.navigationController?.show(vc, sender: nil)
    }
    
    func showAlertView(productName: String?, imageUrl: String, product: [String: Any]?) {
        if productName != nil {
            var products: Array<String> = []
            if self.vcClass == "XiaDanViewController" {
                products = (self.viewController as! XiaDanViewController).productNames
            }
            else {
                products = (self.viewController as! StockViewController).products
            }
            if products.contains(productName!) {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 215, height: 120))
                let imageView = UIImageView(frame: CGRect(x: 57.5, y: 0, width: 100, height: 100))
                imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: DEFAULT_IMAGE), options: [], completed: nil)
                view.addSubview(imageView)
                
                let builder = SCLAlertViewBuilder().addButtonWithActionBlock("哦哦，忘了", {
                    self.barcodeScanner?.reset(animated: true)
                })?.addCustomView(view)
                
                let show = SCLAlertViewShowBuilder().style(.warning)?.title("ㄟ( ▔, ▔ )ㄏ")?.subTitle("这个添加过了！")?.duration(0)
                
                show?.show(builder?.alertView, on: CURRENT_VIEW_CONTROLLER!)
            }
            else {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 215, height: 120))
                let imageView = UIImageView(frame: CGRect(x: 57.5, y: 0, width: 100, height: 100))
                imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: DEFAULT_IMAGE), options: [], completed: nil)
                view.addSubview(imageView)
                
                let builder = SCLAlertViewBuilder().addButtonWithActionBlock("对，就是这个", {
                    if self.vcClass == "XiaDanViewController" {
                        (self.viewController as! XiaDanViewController).productNames.append(productName!)
                        (self.viewController as! XiaDanViewController).products.append(product!)
                        (self.viewController as! XiaDanViewController).qualities.append("1")
                    }
                    else {
                        (self.viewController as! StockViewController).products.append(productName!)
                        (self.viewController as! StockViewController).qualities.append("1")
                        (self.viewController as! StockViewController).locations.append("调兵山")
                    }
                    self.viewController?.navigationController?.popViewController(animated: true)
                })?.addButtonWithActionBlock("错了，不是这个!", {
                    self.barcodeScanner?.reset(animated: true)
                })?.addCustomView(view)
                
                let show = SCLAlertViewShowBuilder().style(.success)?.title("ヾ(=^▽^=)ノ")?.subTitle("\n是不是  " + productName! + "\n")?.duration(0)
                
                show?.show(builder?.alertView, on: CURRENT_VIEW_CONTROLLER!)
            }
        }
        else {
            let builder = SCLAlertViewBuilder().addButtonWithActionBlock("傻逼，这都没有！", {
                self.barcodeScanner?.reset(animated: true)
            })
            
            let show = SCLAlertViewShowBuilder().style(.error)?.title("╮(╯_╰)╭")?.subTitle("\n没找到啊，去后台加一下吧\n")?.duration(0)
            
            show?.show(builder?.alertView, on: CURRENT_VIEW_CONTROLLER!)
        }
    }
}

extension ActionSheetManager: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        DataHandler.sharedInstance.dataFromServer(from: [PRODUCT, code]) { result in
            if let result = result {
                let imageUrl = (result["imageUrl"] as? String) == nil ? "" : result["imageUrl"] as? String
                self.showAlertView(productName: result["name"] as? String, imageUrl: imageUrl!, product: result)
            }
            else {
                self.showAlertView(productName: nil, imageUrl: "", product: nil)
            }
            
        }
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

