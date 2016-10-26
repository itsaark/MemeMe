//
//  ViewController.swift
//  MemeMe
//
//  Created by Arjun Kodur on 9/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topText.delegate = self
        bottomText.delegate = self
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if topText.text == "" {
            
            topText.text = "TOP"
            
        }else if bottomText.text == "" {
            
            bottomText.text = "BOTTOM"
        }
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
        if imagePickerView.image == nil {
            
            shareButton.isEnabled = false
        }else {
            shareButton.isEnabled = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardHideNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
            }
        
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomText.isFirstResponder {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y = 0
            }
        
        }
    }
    
    func subscribeToKeyboardHideNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardHideNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            imagePickerView.image = image
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == topText && topText.text == "TOP" {
            
            topText.text = ""
            
        } else if textField == bottomText && bottomText.text == "BOTTOM"{
            
            bottomText.text = ""
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if textField == topText && topText.text == "" {
            
            topText.text = "TOP"
            
        } else if textField == bottomText && bottomText.text == ""{
            
            bottomText.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == topText || textField ==  bottomText {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.topToolBar.isHidden = true
        self.bottomToolBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)

        
        // TODO:  Show toolbar and navbar
        self.topToolBar.isHidden = false
        self.bottomToolBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    func saveMeme() {
        
        let memedImage = generateMemedImage()
        
        //Create the meme
        let meme = Meme(topText: self.topText.text, bottomText: self.bottomText.text, image: self.imagePickerView.image, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("Number of memes is \(appDelegate.memes.count)")
    }

    
  
    
    @IBAction func actionButtonTapped(_ sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        self.saveMeme()
        
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        
        self.present(activityVC, animated: true) {
            
            activityVC.completionWithItemsHandler = { activity, success, items, error in
                
                if success {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
     
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        
        imagePickerView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

