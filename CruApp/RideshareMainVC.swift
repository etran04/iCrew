//
//  RideshareMainVC.swift
//  CruApp
//
//  Created by Eric Tran on 5/25/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

class RideshareMainVC: UIViewController {

    @IBOutlet weak var swiftPagesView: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let VCIDs : [String] = ["OfferedVC", "RequestedVC"]
        let buttonTitles : [String] = ["Offered Rides", "Requested Rides"]
        
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)

    }

}
