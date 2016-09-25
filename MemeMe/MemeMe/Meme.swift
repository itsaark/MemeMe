//
//  Meme.swift
//  MemeMe
//
//  Created by Arjun Kodur on 9/25/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit

struct Meme {
    
    var topTextField: String?
    var bottomTextField: String?
    var image: UIImage?
    var memedImage: UIImage?
    
    init(topText: String?, bottomText: String?, image: UIImage?, memedImage: UIImage) {
        
        self.topTextField = topText
        self.bottomTextField = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}


