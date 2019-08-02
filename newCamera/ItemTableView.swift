//
//  ItemTableView.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/08/02.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import Foundation
import UIKit

class ItemTableView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    let itemSource = ["楽天", "Amazon" , "価格.com" , "Yahoo" , "メルカリ" , "ヨドバシカメラ" , "Uniqlo"]
    var itemString: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        tableView.delegate  =  self
        tableView.dataSource = self
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //セルの個数を指定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSource.count
    }
    
    //セルに値を設定するデータメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルを取得する
        let cell:  UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //セルに表示する値を設定する
        cell.textLabel!.text = itemSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました")
        
        let encodedString = (itemString[0]).urlEncoding
        let encodedString1 = (itemString[1]).urlEncoding
        let encodedString2 = (itemString[2]).urlEncoding
        print(encodedString)
        
        switch indexPath.row {
        case 0:
            var rakutenURL: URL{
                return URL(string: "https://search.rakuten.co.jp/search/mall/\(encodedString)/")!
            }
            
            if UIApplication.shared.canOpenURL(rakutenURL){
                UIApplication.shared.openURL(rakutenURL)
            }
        // 処理
        case 1:
            var amazonURL: URL{
                return URL(string: "https://www.amazon.co.jp/s?k=\(encodedString)/")!
            }
            
            if UIApplication.shared.canOpenURL(amazonURL){
                UIApplication.shared.openURL(amazonURL)
            }
            
        case 2:
            
            var kakakuURL: URL{
                return URL(string: "https://kakaku.com/search_results/\(encodedString)/")!
            }
            
            if UIApplication.shared.canOpenURL(kakakuURL){
                UIApplication.shared.openURL(kakakuURL)
            }
            
        case 3:
            var yahooURL: URL{
                return URL(string:"https://shopping.yahoo.co.jp/search?first=1&tab_ex=commerce&fr=shp-prop&oq=&aq=&mcr=cd31a13da27acc297980bbb174e1b2b3&ts=1564740087&p=\(encodedString)&pf=&pt=&area=13&dlv=&sc_i=shp_pc_top_searchBox_2&sretry=0")!
            }
            
            if UIApplication.shared.canOpenURL(yahooURL){
                UIApplication.shared.openURL(yahooURL)
            }
        
        case 4:
            var mercariURL: URL{
                return URL(string:"https://www.mercari.com/jp/search/?keyword=\(encodedString)")!
            }
            
            if UIApplication.shared.canOpenURL(mercariURL){
                UIApplication.shared.openURL(mercariURL)
            }
            
        case 5:
            var yodobashiURL: URL{
                return URL(string:"https://www.yodobashi.com/?word=\(encodedString)")!
            }
            
            if UIApplication.shared.canOpenURL(yodobashiURL){
                UIApplication.shared.openURL(yodobashiURL)
            }
        
        case 6:
            var uniqloURL: URL{
                return URL(string:"https://www.uniqlo.com/jp/store/search?qtext=\(encodedString)&x=0&y=0&qstart=0&sort=goods_disp_priority&fid=header_search&qbrand=10&customer_search=true")!
            }
            
            if UIApplication.shared.canOpenURL(uniqloURL){
                UIApplication.shared.openURL(uniqloURL)
            }
            
        default:
            print("error")
        }
    }
}

