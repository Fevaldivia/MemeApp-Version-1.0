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
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBard: UIToolbar!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memes = [Meme]()
    
    func configure(textField:UITextField, withText text: String) {
        // setting attributes
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0 ]
        
        // setting the attributes to the textfields
        textField.defaultTextAttributes = memeTextAttributes
        
        // textField text
        textField.text = text
        
        // set text alignment
        textField.textAlignment = .center
        
        // delegate for textField
        textField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configure(textField: topText, withText: "TOP")
        configure(textField: bottomText, withText: "BOTTOM")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // share button is enable
        shareButton.isEnabled = (imageContent.image != nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Cancel button action
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Function to clean text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" {
            topText.text = ""
        } else if textField.text == "BOTTOM" {
            bottomText.text = ""
        }
    }

    
    // MARK: Present Picker function
    func presentPicker(withSource: UIImagePickerControllerSourceType){
        // configure and present image picker with source type
        let presentImagePicker = UIImagePickerController()
        presentImagePicker.delegate = self
        presentImagePicker.sourceType = withSource
        self.present(presentImagePicker, animated: true, completion: nil)
    }
    
    // MARK: Function to launch photo library
    @IBAction func pickImage(_ sender: Any) {
        presentPicker(withSource: .photoLibrary)
    }
    
    // MARK: Function to take a picture
    @IBAction func takePicture(_ sender: Any) {
        presentPicker(withSource: .camera)
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
    // MARK: Hide Keyboard Function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageContent.image!, memedImage: generateMemedImage())
    
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func navAndToolBarHide(_ hide: Bool){
        self.navigationController?.setNavigationBarHidden(hide, animated: hide)
        toolBard.isHidden = hide
        navBar.isHidden = hide
        albumButton.accessibilityElementsHidden = hide
        cameraButton.accessibilityElementsHidden = hide
    }
    
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        navAndToolBarHide(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
         navAndToolBarHide(false)
        
        return memedImage
    }
    
    
    // MARK: Share Meme
    @IBAction func shareMeme(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil) {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else if (error != nil){
                print("ERRORRRRR !")
            }
        }
    }
    
    
    
}

