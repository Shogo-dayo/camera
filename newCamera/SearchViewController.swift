//
//  SearchViewController.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/07/31.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import AVFoundation
import UIKit
import SwiftyJSON
import Vision
import SafariServices
import Alamofire


//構造体を用意する
//Json型にエンコードするときのCodable
struct searchData:Codable {
    var app_id: String
    var title :String
    var body :String
    
}


class SearchViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var searchView: UITextView!
    
    var searchString: String = ""
    let session3 = URLSession.shared
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.searchView.text = self.searchString.description
        //文字数カウント
        //print(searchString.count)
        getApiRequest()
        }

    func getApiRequest(){
        
        //POSTで送信したい情報をセット
        //let searchData2 = searchData(app_id: "52170588dc2c63830b30591fdd321749c22c768f0f09428d12c3562573bcf4d9", title: "aaaa", body: searchString)
        
        let gooUrl = "https://labs.goo.ne.jp/api/keyword"
        let headers: HTTPHeaders = ["Contenttype": "application/json"]
        let parameters:[String: Any] = [
            "app_id": "52170588dc2c63830b30591fdd321749c22c768f0f09428d12c3562573bcf4d9",
            "title": "aaaa",
            "body": searchString,
            "max_num":5,
            "focus": String(),
        ]
        
        //nullが入る場合は？にする必要がある optional型に
        Alamofire.request(gooUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if var result = response.result.value as? [String: Any] {
                self.searchView.text = result.description
                
                //Dictionary型をJson型に
                let searchResult = JSON(result)
//
                //JSON型のkey値取得
                var item2 : [String] = []
                for item in searchResult["keywords"] {
//                    print(item.1.rawValue)
                    
                    for (key, value) in item.1 {
                        print(key)
                        item2.append(key)
                    }
                }
                
                //5つの単語が返ってくる
                print(item2)
                //配列の1番目が抽出
                print(item2[0])
                
                
                let item3 = item2[0]
                let item4 = item2[1]
                let item5 = item2[2]
                let item6 = item2[3]
                
                
                print(item3)
                
                
                
                var scholarURL : URL{
                    return URL(string: "https://scholar.google.co.jp/scholar?hl=ja&as_sdt=0%2C5&q=\(item3)+\(item4)+\(item5)&btnG=")!
                }
                
                if UIApplication.shared.canOpenURL(scholarURL){
                    UIApplication.shared.openURL(scholarURL)
                }
            }
        }
        }
}
