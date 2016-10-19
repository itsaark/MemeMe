//
//  LifeQuotes.swift
//  Life
//
//  Created by Arjun Kodur on 10/16/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import Foundation

let quotesArray = ["When a new day begins, dare to smile gratefully","When life seems to beat you down, dare to fight back","To be free and to live a free life - that is the most beautiful thing there is","It does not matter how slowly you go as long as you do not stop","Don't watch the clock; do what it does. Keep going","It always seems impossible until its done.","Don't cry because it's over, smile because it happened","You only live once, but if you do it right, once is enough.","To live is the rarest thing in the world. Most people exist, that is all","The fear of death follows from the fear of life. A man who lives fully is prepared to die at any time","Do one thing every day that scares you","The things you do for yourself are gone when you are gone, but the things you do for others remain as your legacy","Do you want to know who you are? Don't ask. Act! Action will delineate and define you","It's never too late to do something you love","There are years that ask questions and years that answer.","The only thing standing between you and your goal is the bullshit story you keep telling yourself as to why you can't achieve it.","It's hard to beat a person who never gives up.","Risks must be taken because the greatest hazard in life is to risk nothing.","A single day is enough to make us a little larger or, another time, a little smaller","Your life is an occasion. Rise to it","The first and final thing you have to do in this world is to last it and not be smashed by it.","Life gives us choices. You either grab on with both hands and just go for it, or you sit on the sidelines.","If you had started doing anything two weeks ago, by today you would have been two weeks better at it.","Obstacles are things a person sees when he takes his eyes off his goal","Be not afraid of life. Believe that life is worth living, and your belief will help create the fact.","Time you enjoy wasting, was not wasted","Let your dreams be bigger than your fears and your actions be louder than your words.","To be old & wise, you must first have to be young & stupid","Act now and change the game","It is never too late to be what you might have been","It's never too late - never too late to start over, never too late to be happy.","Don’t waste your life, take chances and make changes. It’s what we were all made to do.","A ship is safe in harbor, but that's not what ships are for"]

struct Quotes {
    
    func getOne() -> String {
        
        let randomNumber = Int(arc4random_uniform(UInt32(quotesArray.count)))
        
        let randomQuote = quotesArray[randomNumber]
        
        return randomQuote
    }
}
