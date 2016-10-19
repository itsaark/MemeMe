//
//  MainViewController.swift
//  Life
//
//  Created by Arjun Kodur on 10/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

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
        
        performSegue(withIdentifier: "JumpToLifeViewController", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let boxes = Boxes(dateOfBirth: datePicker.date as NSDate)
            let lifeViewController = segue.destination as! LifeViewController
            lifeViewController.numberOfGreenBoxes = boxes.numberOfBoxes()
        
    }
    

}

