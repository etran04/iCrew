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
    var selectedMinistry: MinistryData?
    var ministryId = ""
    var questionCount = 0

    @IBOutlet weak var dayPicker: MWSegmentedControl!
    
    @IBOutlet weak var ministryPicker: UIPickerView!
    var selectedMinistryName: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ministryPicker.dataSource = self;
        self.ministryPicker.delegate = self;
        
        
        
        ministriesCollection = UserProfile.getMinistries();
        
        for ministry in ministriesCollection {
            pickerData.append(ministry.name)
        }
        
        selectedMinistryName = pickerData[0]
        selectedMinistry = ministriesCollection[0]
    }
    
    
    @IBAction func nextButtonTransition(sender: AnyObject) {
        DBClient.getData("ministryquestions", dict: setQuestions)
        
    }
    
    //obtain information from the database to an Object
    func setQuestions(questions: NSArray) {
        self.questionCount = 0
        for question in questions {
            if let ministryId = question["ministry"] as! String? {
                if (ministryId == self.selectedMinistry!.id && question["type"] as! String == "select") {
                    self.questionCount += 1
                }
            }
        }
        
        if (self.questionCount == 0) {
            let storyboard = UIStoryboard(name: "GetInvolved", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("joinCGTVC") as! JoinCommunityGroupTVC
            
            controller.selectedMinistry = selectedMinistry
            self.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        
        let controller = QuestionController()
        
        for ministry in ministriesCollection {
            if (selectedMinistryName == ministry.name) {
                controller.selectedMinistry = ministry
                selectedMinistry = ministry
            }
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
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
        selectedMinistryName = pickerData[row]
        selectedMinistry = ministriesCollection[row]
    }


}
