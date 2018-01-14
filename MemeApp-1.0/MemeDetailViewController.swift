//
//  MemeDetailViewController.swift
//  MemeApp-1.0
//
//  Created by Felipe Valdivia on 1/14/18.
//  Copyright © 2018 Felipe Valdivia. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImage.image = meme.memedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
