//
//  LifeViewController.swift
//  Life
//
//  Created by Arjun Kodur on 10/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class LifeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var numberOfGreenBoxes: Int?
    
    @IBOutlet weak var quoteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let quote = Quotes()
        
        
        self.quoteLabel.text = quote.getOne()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Box", for: indexPath)
        
        
        if indexPath.row < numberOfGreenBoxes! {
            
            cell.backgroundColor = UIColor.green
        }
        
        return cell
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
