//
//  GoogleKeys.swift
//  CruApp
//
//  Created by Jordan Tang on 5/30/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

class GoogleKeys {
    //Keys for accessing Google API
    //These will need to be changed upon release
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "466090597779-cqphfvmo2focdg82kpm2rh5qg4u0vgkd.apps.googleusercontent.com"
    private let kSecret = "fyM1MvYHSkXPl9plSlkYgYcw"
    
    func getKeyChain() -> String {
        return kKeychainItemName
    }
    
    func getClientID() -> String{
        return kClientID
    }
    
    func getSecret() -> String{
        return kSecret
    }
    
}