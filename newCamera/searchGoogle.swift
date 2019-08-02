//
//  searchGoogle.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/08/02.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Vision
import SafariServices
import WebKit

class searchGoogle: UIViewController,WKUIDelegate,UINavigationControllerDelegate {
    
    var myLeftButton : UIBarButtonItem!
    var webView : WKWebView!
    
    //google.comのネット検索
    override func viewDidLoad() {
        super.viewDidLoad()
        weburl()
        
    }
    
    func weburl() {
        
        webView = WKWebView(frame: CGRect(x:0 , y:0 , width: self.view.bounds.size.width , height: self.view.bounds.size.height-50))
        
        let uslString = "https://www.google.com/"
        let encodedUrlString = uslString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        
        webView.load(request as URLRequest)
        
        self.view.addSubview(webView)
        
        
        let footerBarHeight: CGFloat = 40
        //toolbar本体のインスタンス化
        let toolbar = UIToolbar(frame: CGRect(x:0, y:self.view.bounds.size.height - footerBarHeight,width: self.view.bounds.width,height: footerBarHeight))
        
        toolbar.layer.position = CGPoint(x: self.view.bounds.width/2 , y:self.view.bounds.height-20)
        
        //ツールバースタイルの設定
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.blue
        
        let screenShot = UIButton(frame: CGRect(x:0 , y:0 , width: 50 , height: 24))
        //screenShot.setBackgroundImage(UIImage(named: "screen"), for: .normal)
        screenShot.addTarget(self, action: #selector(self.getScreenShot(_ :)), for: .touchUpInside)
        let screen = UIBarButtonItem(customView: screenShot)
        
        
        toolbar.items = [screen]
        self.view.addSubview(toolbar)
        
        
        myLeftButton = UIBarButtonItem(barButtonSystemItem:  .search, target: self, action: "getScreenShot:")
        
        toolbar.items?.append(myLeftButton)
        
    }
    
    @objc func getScreenShot(_ sender:UIBarButtonItem) {
        
        let rect = view.bounds
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false , 0.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        self.view.layer.render(in: context)
        
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        print(screenShot)
        
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil)
        
        //遷移先のViewControllerを取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //親クラスと子供クラスのインスタンスを取得
        let screenImage = storyboard.instantiateViewController(withIdentifier: "UsePic") as! UsePictureViewController
        
        screenImage.image = screenShot
        
        screenImage.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        
        self.navigationController?.pushViewController(screenImage, animated: true)
    }
    
}


