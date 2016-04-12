//
//  UserData.swift
//  CruApp
//
//  Created by Mariel Sanchez on 3/10/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

struct UserData {
    var firstName: String
    var lastName: String
    var id: String
    var email: String
    var phone: String
    var password: String
    
    init(user: AnyObject) {
        firstName = user["name"]!!.objectForKey("first") as! String
        lastName = user["name"]!!.objectForKey("last") as! String
        id = user["_id"] as! String
        email = user["email"] as! String
        
        if user["phone"]! != nil {
            phone = user["phone"] as! String
        }
        else {
            phone = ""
        }
        
        if user["password"]! != nil {
            password = user["password"] as! String
        }
        else {
            password = ""
        }
        
    }
}