//
//  ViewController.swift
//  MemeApp-1.0
//
//  Created by Felipe Valdivia on 11/13/17.
//  Copyright © 2017 Felipe Valdivia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    

    @IBAction func pickImage(_ sender: Any) {
        let chooseImage = UIImagePickerController()
        chooseImage.delegate = self
        chooseImage.sourceType = .photoLibrary
        self.present(chooseImage, animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let pictureTaken = UIImagePickerController()
        pictureTaken.delegate = self
        pictureTaken.sourceType = .camera
        self.present(pictureTaken, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageContent.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
    }

}

