//
//  Utils.swift
//  CruApp
//
//  Created by Tammy Kong on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import Foundation

#if TARGET_OS_SIMULATOR
    //simulator
let gcm_id = "1234567"
#else
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let gcm_id = appDelegate.registrationToken
#endif

class Utils {
    
    static func parsePhoneNumber(phoneNum : String) -> String {
        // split by '-'
        let full = phoneNum.componentsSeparatedByString("-")
        let left = full[0]
        let right = full[1]
        
        // get area code from ()
        var index1 = left.startIndex.advancedBy(1)
        let delFirstParen = left.substringFromIndex(index1)
        let index2 = delFirstParen.startIndex.advancedBy(3)
        let areaCode = delFirstParen.substringToIndex(index2)
        
        // get first three digits
        index1 = left.startIndex.advancedBy(6)
        let threeDigits = left.substringFromIndex(index1)
        
        // get last four digits
        // = right
        
        let finalPhoneNum = areaCode + threeDigits + right
        return finalPhoneNum
        
    }
//    static func validPhoneNumber(phoneNum:String) -> Boolean {
//        let full = phoneNum.componentsSeparatedByString("-")
//        
//    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}