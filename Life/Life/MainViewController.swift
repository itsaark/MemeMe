//
//  ViewController.swift
//  Life
//
//  Created by Arjun Kodur on 10/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        datePicker.datePickerMode = .date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePicked(_ sender: AnyObject) {
        
        let boxes = Boxes(dateOfBirth: datePicker.date as NSDate)
        
        let lifeViewController = storyboard?.instantiateViewController(withIdentifier: "Life") as! LifeViewController
        lifeViewController.numberOfBoxes = boxes.numberOfBoxes()
        
        performSegue(withIdentifier: "JumpToLifeViewController", sender: sender)
        
        
    }
    

}

