//
//  EditKidViewController.swift
//  MyKidApp
//
//  Created by Sourabh Jamlapuram on 1/12/15.
//  Copyright (c) 2015 Sourabh Jamlapuram. All rights reserved.
//

import UIKit

class EditKidViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var mediaPicker :MKSImagePicker?
    var delegate:EditDoneProtocol!
    var CurrentKid:Kid!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.CurrentKid != nil{
            self.nameField.text = self.CurrentKid.Name
            if let image = self.CurrentKid!.ThumbnailImage{
                self.imageView.image = self.CurrentKid.ThumbnailImage
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditPhoto(sender: AnyObject) {
        intializePhotoPicker(self)
        String.cleanCapturedImages("CapturedImages")

    }

    
    func intializePhotoPicker(sender:AnyObject){
        
        if(self.mediaPicker == nil){
            
            self.mediaPicker = MKSImagePicker(frame: self.view.frame, superVC: self, completionBlock: { (isFinshed) -> Void in
                
                if(isFinshed != nil){
                    NSLog("Image captured properly")
                    self.updateImage()
                }
                else
                {
                    NSLog("Failure in image capturing")
                    
                }
            })
        }
        
        self.mediaPicker?.showImagePickerActionSheet(sender )
        
    }
    
    func updateImage(){
        
        String.getContentsOfDirectoryAtPath("CapturedImages", block: { (filenames, error) -> () in
         
            if filenames.count > 0 {
                println("\(filenames)")
                var absoluteImagePath:String = String.savedImageDirPath(filenames.last!)!
                var image  = UIImage(contentsOfFile:absoluteImagePath)
                self.saveToThumbnail(image!)
            }
        })
    }
    
    func saveToThumbnail(image: UIImage)
    {
        var destinationSize = CGSize(width: 40, height: 40)
        var rect1 = CGRect(x: 0, y: 0, width: 40, height: 40)
        UIGraphicsBeginImageContext(destinationSize);
        // [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        image.drawInRect(rect1)
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //println(newImage.length)
        self.imageView.image  =  newImage
        var imageData = UIImagePNGRepresentation(newImage)
        println(imageData.length)
        
    }
    
    
    @IBAction func onDone(sender: AnyObject) {
        if self.CurrentKid != nil {
            self.CurrentKid.Name = self.nameField.text
            self.CurrentKid.ThumbnailImage = self.imageView.image
            self.delegate!.onEditDone(self, object:CurrentKid, isNew: false )
        }else{
            var kid =  Kid()
            kid.Name = self.nameField.text
            kid.ThumbnailImage = self.imageView.image
            self.delegate!.onEditDone(self, object:kid, isNew:true )
        }
    }
}
