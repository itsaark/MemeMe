//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: Properties
    
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latLonSearchButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        // FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Search Actions
    
    @IBAction func searchByPhrase(sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if !phraseTextField.text!.isEmpty {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: String!] = [Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch,
                                                       Constants.FlickrParameterKeys.Text:phraseTextField.text,
                                                       Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
                                                       Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
                                                       Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod,
                                                       Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
                                                       Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback]
            displayImageFromFlickrBySearch(methodParameters)
        } else {
            setUIEnabled(true)
            photoTitleLabel.text = "Phrase Empty."
        }
    }
    
    @IBAction func searchByLatLon(sender: AnyObject) {

        userDidTapView(self)
        setUIEnabled(false)
        
        if isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange) {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: String!] = [Constants.FlickrParameterKeys.SafeSearch:Constants.FlickrParameterValues.UseSafeSearch,
                                                       Constants.FlickrParameterKeys.BoundingBox:bboxString(),
                                                       Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
                                                       Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
                                                       Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.SearchMethod,
                                                       Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
                                                       Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback]
            displayImageFromFlickrBySearch(methodParameters)
        }
        else {
            setUIEnabled(true)
            photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
    
    private func bboxString () -> String{
        
        if let latitude = Double(latitudeTextField.text!), let longitude = Double(longitudeTextField.text!){
            let minLon = max(longitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.0)
            let minLat = max(latitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLatRange.0)
            let maxLon = min(longitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLonRange.1)
            let maxLat = min(latitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLatRange.1)
            
            return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
        }else{
            return "0,0,0,0"
        }
    }
    
    // MARK: Flickr API
    
    private func displayImageFromFlickrBySearch(methodParameters: [String:AnyObject]) {
        
        // if an error occurs, print it and re-enable the UI
        func displayError(error: String) {
            print(error)
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
            }
        }
        
        // TODO: Make request to Flickr!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                displayError("we have an error")
                return
            }
            
            guard let responseCode = response as? NSHTTPURLResponse else{
                displayError("no re code found")
                return
            }
            
            if responseCode.statusCode >= 200 && responseCode.statusCode <= 250 {
                
                guard let data = data else{
                    displayError("Data is not found")
                    return
                }
                
                let parsedResults: AnyObject!
                
                do{
                    parsedResults = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                }catch{
                    displayError("coundn't parse the data")
                    return
                }
                
                guard (parsedResults[Constants.FlickrResponseKeys.Status] as? String == Constants.FlickrResponseValues.OKStatus) else{
                    displayError("something went wrong with flicker API")
                    return
                }
                
                guard let photosDictionary = parsedResults[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]], let pages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int  else{
                    displayError("coundn't find the photoDictionary")
                    return
                }
                let pageLimit = min(pages, 40)
                let randomPageNumber = Int(arc4random_uniform(UInt32(pageLimit)))
                self.displayImageFromFlickrBySearch(methodParameters, withPageNumber: randomPageNumber)
                
            }else{
                displayError("we have to take care of this status code \(responseCode.statusCode)")
            }
        }
        
        task.resume()
    }
    
    private func displayImageFromFlickrBySearch(methodParameters: [String: AnyObject], withPageNumber: Int) {
        // add the page to the method's parameters
        var methodParametersWithPageNumber = methodParameters
        methodParametersWithPageNumber[Constants.FlickrParameterKeys.Page] = withPageNumber as AnyObject?
        
        // if an error occurs, print it and re-enable the UI
        func displayError(error: String) {
            print(error)
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
            }
        }
        
        // TODO: Make request to Flickr!
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                displayError("we have an error")
                return
            }
            
            guard let responseCode = response as? NSHTTPURLResponse else{
                displayError("no re code found")
                return
            }
            
            if responseCode.statusCode >= 200 && responseCode.statusCode <= 250 {
                
                guard let data = data else{
                    displayError("Data is not found")
                    return
                }
                
                let parsedResults: AnyObject!
                
                do{
                    parsedResults = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                }catch{
                    displayError("coundn't parse the data")
                    return
                }
                
                guard (parsedResults[Constants.FlickrResponseKeys.Status] as? String == Constants.FlickrResponseValues.OKStatus) else{
                    displayError("something went wrong with flicker API")
                    return
                }
                
                guard let photosDictionary = parsedResults[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]]  else{
                    displayError("coundn't find the photoDictionary")
                    return
                }
                
                
                guard (photoArray.count != 0) else {
                    self.photoTitleLabel.text = "no images found"
                    self.setUIEnabled(true)
                    return
                }
                
                // select a random photo
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
                let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String
                
                guard let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else{
                    displayError("coundn't find the url")
                    return
                }
                
                let imageURL = NSURL(string: imageURLString)
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    
                    performUIUpdatesOnMain({
                        self.setUIEnabled(true)
                        self.photoImageView.image = UIImage(data: imageData)
                        self.photoTitleLabel.text = photoTitle ?? "untitled"
                    })
                }
                
                
            }else{
                displayError("we have to take care of this status code \(responseCode.statusCode)")
            }
        }
        
        task.resume()

        
        // [remaining code in the function]...
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
}

// MARK: - ViewController: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(phraseTextField)
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
    }
    
    // MARK: TextField Validation
    
    private func isTextFieldValid(textField: UITextField, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField.text!) where !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    private func isValueInRange(value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
}

// MARK: - ViewController (Configure UI)

extension ViewController {
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        phraseTextField.enabled = enabled
        latitudeTextField.enabled = enabled
        longitudeTextField.enabled = enabled
        phraseSearchButton.enabled = enabled
        latLonSearchButton.enabled = enabled
        
        // adjust search button alphas
        if enabled {
            phraseSearchButton.alpha = 1.0
            latLonSearchButton.alpha = 1.0
        } else {
            phraseSearchButton.alpha = 0.5
            latLonSearchButton.alpha = 0.5
        }
    }
}

// MARK: - ViewController (Notifications)

extension ViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
