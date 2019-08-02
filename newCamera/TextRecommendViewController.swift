//
//  TextRecommendViewController.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/07/29.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SwiftyJSON
import Vision
import SafariServices
class TextRecommendViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let session = URLSession.shared
    let imagePicker = UIImagePickerController()
    var getJSON: NSDictionary!
    
    var image2 :UIImage?  = nil
    var googleAPIKey = "AIzaSyD2ox0ih5H0d0st7Ggnvs6jPm5opDYSqQg"
    var googleURL: URL{
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    
    @IBOutlet weak var picture2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picture2.image = self.image2
        imagePicker.delegate = self
        
    }
    
    
    @IBAction func analyzeButtonTapped2(_ sender: UIButton) {
        
        picture2.contentMode = .scaleAspectFit
        picture2.isHidden = true// You could optionally display the image here by setting imageView.image = pickedImage
        
        
        // Base64 encode the image and create the request
        let binaryImageData2 = base64EncodeImage2(picture2.image!)
        createRequest2(with: binaryImageData2)
        
    }
    
}

extension TextRecommendViewController{
    
    //APIが応答すると関数が呼び出される．このメソッドはAPIに返されたラベルの文字列を構成する
    func analyzeResults2(_ dataToParse:Data){
        
        //Update UI on the main thread スレッドを作ったら定義する時にはselfが必要
        DispatchQueue.main.async(execute:{
            
            //use SwiftyJSON to parse results
            //結果を説明するためにJSONを使う
            let json = try! JSON(data:dataToParse)
            let errorObj: JSON = json["error"]
            
            //結果出力の際に，ラベルと画像を出力するか
            self.picture2.isHidden = false
            
            //check for errors
            if(errorObj.dictionaryValue != [:]){
                //self.labelResults2.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            }else {
                //Parse the response
                let responses: JSON = json["responses"][0]["textAnnotations"]
                //print(responses)
                //"locale" , "description" が抽出されている
                
                
                //"descriptionをSearchViewControllerに渡す
                let responses2: JSON = json["responses"][0]["textAnnotations"][0]["description"]
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let searchRecommend = storyboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
                
                //配列[String]にするか，文字列Stringにするか
                searchRecommend.searchString = responses2.description
                
                
                self.navigationController?.pushViewController(searchRecommend, animated: true)
                
                
                
                // Get label annotations response以降で何を読み取るかを選ぶ
                let labelAnnotations: JSON = responses["text"]

                //let jsonEntities: JSON = labelAnnotations["Document"]
                
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    
                    var labelResultsText:String = "Labels found: "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    
                }
            }
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

/// Networking base64は画像をエンコードし，大きすぎる場合はサイズを変更してAPIに送信する
extension TextRecommendViewController {
    func base64EncodeImage2(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    //CloudVisionAPIへのラベル要求を作成して実行する
    func createRequest2(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults2(data)
            
        }
        
        task.resume()
        
    }
    
    
}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
    
    
    
    
}

