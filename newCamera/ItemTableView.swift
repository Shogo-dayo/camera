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
    
    let itemSource = ["楽天", "Amazon" , "価格.com" , "Yahoo"]
    
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
        
        let itemString = "額"
        let encodedString = (itemString).urlEncoding
        
        if indexPath.row == 1{
            
            var rakutenURL: URL{
                return URL(string: "https://search.rakuten.co.jp/search/mall/\(encodedString)/")!
            }
        
        tableView.deselectRow(at: indexPath , animated:true)
        
        performSegue(withIdentifier: "toRakuten", sender: nil)
    }
}
}
