//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Arjun Kodur on 10/26/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: UIImage?
    
    @IBOutlet weak var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memedImage = meme{
            
            memeImage.image = memedImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
