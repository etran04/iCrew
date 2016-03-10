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
    
    init(firstName: String, lastName: String, id: String, email: String, phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.email = email
        self.phone = phone
        
        if (email.isEmpty) {
            self.email = ""
        }
        
        if (phone.isEmpty) {
            self.phone = ""
        }
    }
}