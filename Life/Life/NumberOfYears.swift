//
//  NumberOfYears.swift
//  Life
//
//  Created by Arjun Kodur on 10/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import Foundation

struct Boxes {
    
    var dateOfBirth: NSDate
    
    func numberOfBoxes() -> Int {
        
        let secondsInYear:Double = 365*24*60*60
        
        let todaysDate = NSDate()
        
        let timeDiffernceInYears = Int((todaysDate.timeIntervalSince(dateOfBirth as Date)/secondsInYear))
        
        return timeDiffernceInYears
    }
}
