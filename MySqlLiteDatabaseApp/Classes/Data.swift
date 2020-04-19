//
//  Data.swift
//  MySqlLiteDatabaseApp
//
//  Created by Sherwin on 2020-03-22.
//  Copyright © 2020 Sherwin. All rights reserved.
//

import UIKit

class Data: NSObject {

    var Id : Int?
    var name : String?
    var email : String?
    var food : String?
    
    func initWithData(theRow i : Int, theName n : String, theEmail e : String, theFood f : String)
    {
        
        Id = i
        name = n
        email = e
        food = f
        
    }
    
}
