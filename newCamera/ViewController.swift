//
//  ViewController.swift
//  newCamera
//
//  Created by ShogoIsoda on 2019/07/29.
//  Copyright © 2019 ShogoIsoda. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var imageView: UIImageView!
    
    var screenShot : UIImage?
    
    
    @IBAction func prepareScreen(_ sender: UIBarButtonItem) {
        
        
        let picker = getScrrenShot(windowFrame: self.view.bounds)
        
        UIImageWriteToSavedPhotosAlbum(picker, nil, nil, nil)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = UIModalPresentationStyle.popover
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            if let popover = picker.popoverPresentationController{
                popover.sourceView = self.view
                //popover.sourceRect = loadImageButton.frame
                popover.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            self.present(picker,animated:true)
        }
        
        
        
    }
    
    @IBAction func prepareSetting(_ sender: UIBarButtonItem) {
        //カメラロールから写真イメージ取得
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = UIModalPresentationStyle.popover
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            if let popover = picker.popoverPresentationController{
                popover.sourceView = self.view
                //popover.sourceRect = loadImageButton.frame
                popover.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            self.present(picker,animated:true)
        }
        
        
    }
    
    
    
    @IBAction func launchCamera(_ sender: UIBarButtonItem) {
        
        //写真を撮ってイメージ取得
        let camera = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera){
            let picker = UIImagePickerController()
            picker.sourceType = camera
            picker.delegate = self
            self.present(picker,animated:true)
            
        } else{
            print("カメラ立ち上げのエラー")
        }
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imageView.image = image
        picker.dismiss(animated: true)
        //遷移先のViewControllerを取得
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //親クラスと子供クラスのインスタンスを取得
        let usePicture = storyboard.instantiateViewController(withIdentifier: "UsePic") as! UsePictureViewController
        
        usePicture.image = image
        
        // 遷移先のアニメーション .の後を変更できる
        usePicture.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        
        self.navigationController?.pushViewController(usePicture, animated: true)
        
        
    }
    
    func getScrrenShot(windowFrame: CGRect) -> UIImage {
       
        //context処理開始
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //contextにスクリーンショットを書き込む
        self.view.layer.render(in: context)
        
        //contextをUIImageに書き出す
        let screenShot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //context処理を終了
        UIGraphicsEndImageContext()
        
        return screenShot
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


