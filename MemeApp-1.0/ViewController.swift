//
//  ViewController.swift
//  MemeApp-1.0
//
//  Created by Felipe Valdivia on 11/13/17.
//  Copyright © 2017 Felipe Valdivia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Setting up the text for the textfields
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        // setting attributes
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0 ]
        
        // setting the attributes to the textfields
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        // set text alignment
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        // delegate for textField
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Function to clean text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" {
            topText.text = ""
        } else if textField.text == "BOTTOM" {
            bottomText.text = ""
        }
    }
    
    // MARK: Function to launch photo library
    @IBAction func pickImage(_ sender: Any) {
        let chooseImage = UIImagePickerController()
        chooseImage.delegate = self
        chooseImage.sourceType = .photoLibrary
        self.present(chooseImage, animated: true, completion: nil)
    }
    
    // MARK: Function to take a picture
    @IBAction func takePicture(_ sender: Any) {
        let pictureTaken = UIImagePickerController()
        pictureTaken.delegate = self
        pictureTaken.sourceType = .camera
        self.present(pictureTaken, animated: true, completion: nil)
    }
    
    // MARK: Function to pick and assing a photo from library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageContent.image = image
            dismiss(animated: true, completion: nil)
        }
    }

    
    func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    

}

