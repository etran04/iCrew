//
//  CGQuestionnaireVC.swift
//  CruApp
//
//  Created by Daniel Lee on 2/29/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit
import Foundation



class CGQuestionnaireVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var ministriesCollection: [MinistryData] = []
    var pickerData: [String] = []
    

    @IBOutlet weak var dayPicker: MWSegmentedControl!
    
    @IBOutlet weak var ministryPicker: UIPickerView!
    var selectedMinistry: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ministryPicker.dataSource = self;
        self.ministryPicker.delegate = self;
        
        ministriesCollection = UserProfile.getMinistries();
        
        for ministry in  ministriesCollection {
            pickerData.append(ministry.name)
        }
        
        selectedMinistry = pickerData[0]
        
    }
    
    
    @IBAction func nextButtonTransition(sender: AnyObject) {
        let controller = QuestionController()
        
        for ministry in ministriesCollection {
            if (selectedMinistry == ministry.name) {
                controller.selectedMinistryId = ministry.id
                
            }
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

                
//        let joinCG = segue.destinationViewController as!  JoinCommunityGroupTVC
//        joinCG.days = selectedDaysToInt()
//        joinCG.selectedMinistry = ministriesCollection[ministryPicker.selectedRowInComponent(0)]
        
//        let moreQuestions = segue.destinationViewController as!  QuestionController
//        for ministry in ministriesCollection {
//            if (selectedMinistry == ministry.name) {
//                moreQuestions.selectedMinistryId = ministry.id
//                
//            }
//        }
        
        
        
    }
    
    func selectedDaysToInt() -> [Int]{
    
        var selectedInt: [Int] = []
        let selectedDays = dayPicker.getSelected()
        
        for day in selectedDays {
            switch (day) {
                case ("Sun"):
                    selectedInt.append(0)
                case("M"):
                    selectedInt.append(1)
                case("Tu"):
                    selectedInt.append(2)
                case("W"):
                    selectedInt.append(3)
                case ("Th"):
                    selectedInt.append(4)
                case("F"):
                    selectedInt.append(5)
                case("Sat"):
                    selectedInt.append(6)
                default:
                    break
                
            }
        }
        
        return selectedInt
        
    }
    
    // MARK: Picker View Delegate Methdods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMinistry = pickerData[row]
    }


}
