//
//  Offer.swift
//  iSokoBeta
//
//  Created by Joffrey Armellini on 2016-02-27.
//  Copyright © 2016 Joffrey Armellini. All rights reserved.
//

import Foundation

class Offer {
    
    var provider: String
    var monthlyRate: Float
    
    init(provider: String, monthlyRate: Float) {
        
        self.provider = provider
        self.monthlyRate = monthlyRate
        
    }
    
}
