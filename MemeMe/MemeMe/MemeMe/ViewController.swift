//
//  ViewController.swift
//  MemeMe
//
//  Created by Arjun Kodur on 9/12/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imagePickerView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }

}

