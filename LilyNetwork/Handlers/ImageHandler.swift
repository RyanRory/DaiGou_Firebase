//
//  ImageHandler.swift
//  LilyNetwork
//
//  Created by 赵润声 on 30/3/18.
//

import Foundation
import UIKit

class ImageHandler {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func generateBarCode128(barCodeStr:String,barCodeSize:CGSize) ->UIImage? {
        //将传入的string转成nsstring，再编码
        let stringData = barCodeStr.data(using: String.Encoding.utf8)
        
        
        //系统自带能生成的码
        //        CIAztecCodeGenerator 二维码
        //        CICode128BarcodeGenerator 条形码
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator     二维码
        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        let outputImage:CIImage? = qrFilter?.outputImage
        
        /*
         生成的条形码需要对其进行消除模糊处理，本文提供两种方法消除模糊，其原理都是放大条码，但项目中需要在条码底部加上条码内容文字，使用其方法一会模糊并变小文字，所以使用方法二，需要各位去研究下原因哈。。。
         
         */
        
        // 消除模糊方法
        let scaleX:CGFloat = barCodeSize.width/outputImage!.extent.size.width; // extent 返回图片的frame
        let scaleY:CGFloat = barCodeSize.height/outputImage!.extent.size.height;
        let resultImage = outputImage?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
        let image = UIImage.init(ciImage: resultImage!)
        
        let size = CGSize(width: image.size.width, height: image.size.height+30)
        
        UIGraphicsBeginImageContextWithOptions (size, false , 0.0 )
        
        image.draw(at: CGPoint.zero)
        
        // 获得一个位图图形上下文
        
        let context = UIGraphicsGetCurrentContext ()
        context?.drawPath(using: .stroke)
        
        //绘制文字
        let barText:NSString = barCodeStr as NSString
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.alignment = .center
        
        barText.draw(in: CGRect(x: 0, y: image.size.height-4, width: size.width, height: 30), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.backgroundColor:UIColor.clear,NSAttributedStringKey.paragraphStyle:textStyle])
        
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}
