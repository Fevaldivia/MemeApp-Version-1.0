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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func pickImage(_ sender: Any) {
        let chooseImage = UIImagePickerController()
        
        chooseImage.delegate = self
        
        self.present(chooseImage, animated: true, completion: nil)
    }

}

