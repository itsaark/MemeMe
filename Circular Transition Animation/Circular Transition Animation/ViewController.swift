//
//  ViewController.swift
//  Circular Transition Animation
//
//  Created by Arjun Kodur on 10/17/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var actionButton: UIButton!
    
    let trasition = CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.layer.cornerRadius = actionButton.frame.size.width / 2
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! SecondViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        trasition.transitionMode = .present
        trasition.startingPoint = actionButton.center
        trasition.circleColor = actionButton.backgroundColor!
        
        return trasition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        trasition.transitionMode = .dismiss
        trasition.startingPoint = actionButton.center
        trasition.circleColor = actionButton.backgroundColor!
        
        return trasition

    }

}

