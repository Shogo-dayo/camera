//
//  ItemRecommendViewController.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/07/29.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import AVFoundation
import UIKit
import SwiftyJSON
import Vision
import SafariServices

struct JsonSample:Codable {
    var positionRate = Int()
    var shopOfTheYearFlag = Int()
    var affiliateRate = Int()
    var asurakuFlag = Int()
    var endTime =  Int()
    var taxFlag = Int()
    var startTime =  Int()
    var itemCaption = String()
    var catchcopy = String()
    
}

class ItemRecommendViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var itemRecommendView: UITextView!
    
    var itemString: [String] = []
    var rakutenAPI_KEY = "1032025480745612819"
    //let searchRakuten:String! = itemString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    
    
    //楽天市場API
    var rakutenURL: URL{
        return URL(string: "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?format=json&applicationId=\(rakutenAPI_KEY)&keyword=\(itemString[0])&sort=%2BitemPrice")!
    }
    
   
    
    
    
    //価格.com のネット検索
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //これが最適解,本当はこれがしたい
        print(itemString[0],itemString[1],itemString[2],itemString[3],itemString[4])
        self.itemRecommendView.text = self.itemString[0]
        
        let testString0 = itemString[0]
        let testString1 = itemString[1]
        let testString2 = itemString[2]
        let testString3 = itemString[3]
        let testString4 = itemString[4]
        
        
        let encodedString = (itemString[0]).urlEncoding
        print(encodedString)
        
        var kakakuURL : URL{
            return URL(string: "https://kakaku.com/search_results/\(encodedString)")!
        }
        
        //楽天市場のネット検索
        var rakutenURL2: URL{
            return URL(string: "https://search.rakuten.co.jp/search/mall/\(encodedString)/")!
        }
        
        
        if UIApplication.shared.canOpenURL(rakutenURL2){
            UIApplication.shared.openURL(rakutenURL2)
        }
        
    }
}

extension String{
    var urlEncoding:String{
        let charset = CharacterSet.alphanumerics.union(.init(charactersIn: "/?-._~"))
        
        let removed = removingPercentEncoding ?? self
        return removed.addingPercentEncoding(withAllowedCharacters: charset) ?? removed
        
    }
}
