//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Arjun Kodur on 10/26/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    var selectedRow: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let size =  (self.view.frame.size.width - 2*space) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: size, height: size)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.meme.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        // Grab the DetailVC from Storyboard
//        let object: AnyObject = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC")
//        let detailVC = object as! DetailViewController
//        
//        //Populate view controller with data from the selected item
//        detailVC.memeImage.image = self.memes[indexPath.row].memedImage
        
        selectedRow = indexPath.row
        
        // Present the view controller using navigation
        performSegue(withIdentifier: "JumpToDetailVC", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "JumpToDetailVC" {
            
            let detailVC = segue.destination as! DetailViewController
            if let row = selectedRow{
                detailVC.meme = self.memes[row].memedImage
            }
        }

        
    }

}
