//
//  CGCustomQuestionsTVC.swift
//  CruApp
//
//  Created by Mariel Sanchez on 5/11/16.
//  Copyright © 2016 iCrew. All rights reserved.
//

import UIKit

struct Question {
    var questionString: String?
    var answers: [String]?
    var selectedAnswerIndex: Int?
}

//var questionsList: [Question] = [Question(questionString: "What is your favorite type of food?", answers: ["Sandwiches", "Pizza", "Seafood", "Unagi"], selectedAnswerIndex: nil), Question(questionString: "What do you do for a living?", answers: ["Paleontologist", "Actor", "Chef", "Waitress"], selectedAnswerIndex: nil), Question(questionString: "Were you on a break?", answers: ["Yes", "No"], selectedAnswerIndex: nil)]

var questionsList = [QuestionData]()


class QuestionController: UITableViewController {
    
    var selectedMinistry: MinistryData!
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DBClient.getData("ministryquestions", dict: setQuestions)
        
        navigationItem.title = "Question"
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        tableView.registerClass(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.registerClass(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView()
        
    }
    
    //obtain information from the database to an Object
    func setQuestions(questions: NSArray) {
        questionsList = [QuestionData]()
        
        for question in questions {
            if let ministryId = question["ministry"] as! String? {
                if (selectedMinistry.id == question["ministry"] as! String
                    && question["type"] as! String == "select") {
                    let questionObj = QuestionData(ministry: selectedMinistry.id, question: question["question"]! as! String, type: question["type"] as! String, options: question["selectOptions"] as! [NSDictionary])
                    questionsList.append(questionObj)
                }
            }
            
        }
        
    
        if (questionsList.count == 0) {
            let storyboard = UIStoryboard(name: "GetInvolved", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("joinCGTVC") as! JoinCommunityGroupTVC
            
            controller.selectedMinistry = selectedMinistry
            self.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        //print(questionsList[0].question)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(questionsList.count > 0) {
        
            if let index = navigationController?.viewControllers.indexOf(self) {
                let question = questionsList[index - 2]  //index
                return question.options.count
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! AnswerCell
        
        if(questionsList.count > 0) {
            if let index = navigationController?.viewControllers.indexOf(self) {
                let question = questionsList[index - 2]
                let dict = question.options[indexPath.row] as NSDictionary
                let option = dict["value"] as! String
                cell.nameLabel.text = option
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(headerId) as! QuestionHeader
        
        if(questionsList.count > 0) {
            if let index = navigationController?.viewControllers.indexOf(self) {
                let question = questionsList[index - 2]
                header.nameLabel.text = question.question
                
            }
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let index = navigationController?.viewControllers.indexOf(self) {
            questionsList[index-2].selectedAnswerIndex = indexPath.item
            print("questions = \(questionsList.count)")
            print(index)
            if index - 2 < questionsList.count - 1 {
                let questionController = QuestionController()
                questionController.selectedMinistry = selectedMinistry
                self.navigationController?.pushViewController(questionController, animated: true)

            } else {
                let storyboard = UIStoryboard(name: "GetInvolved", bundle: nil)
                let controller = storyboard.instantiateViewControllerWithIdentifier("joinCGTVC") as! JoinCommunityGroupTVC
                
                controller.selectedMinistry = selectedMinistry
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        
//        
//        //        let joinCG = segue.destinationViewController as!  JoinCommunityGroupTVC
//        //        joinCG.days = selectedDaysToInt()
//        //        joinCG.selectedMinistry = ministriesCollection[ministryPicker.selectedRowInComponent(0)]
//        
//        let moreQuestions = segue.destinationViewController as!  QuestionController
//        moreQuestions.selectedMinistryId = selectedMinistryId
//        
//        let results = segue.destinationViewController as!  ResultsController
//        results.selectedMinistry = selectedMinistry.id
//        
//    }
    
}

class ResultsController: UIViewController {
    
    var selectedMinistry = String()
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations, you're a total Ross!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "done")
        
        navigationItem.title = "Results"
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultsLabel]))
        
        let names = ["Ross", "Joey", "Chandler", "Monica", "Rachel", "Phoebe"]
        
        var score = 0
//        for question in questionsList {
//            if let ndx = question.selectedAnswerIndex {
//                score += ndx
//            }
        
//        }
        
        let result = names[score % names.count]
        resultsLabel.text = "Congratulations, you're a total \(result)!"
    }
    
    func done() {
        
        let storyboard = UIStoryboard(name: "GetInvolved", bundle: NSBundle.mainBundle())
        let vc : UIViewController = storyboard.instantiateViewControllerWithIdentifier("CGSuccess") as UIViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }

    
}

class QuestionHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.font = UIFont.boldSystemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AnswerCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
}