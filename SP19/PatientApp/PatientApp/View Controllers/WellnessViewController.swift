//
//  WellnessViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/18/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class WellnessViewController: UIViewController {
    
    //local variables
    var questionList = [String]()
    var isSliderList = [Bool]()
    var yesNoResults = [Bool?]()
    var sliderValues = [Float]()
            
    // private variables
    private let colorTheme = UIColor(named: "purple")!
    private let cellIdentifier: String = "wellnessDatacell"
    
    // subviews
    let headerView = Header()
    let wellnessTableView = UITableView()
    let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // provide delegate and datasource sources
        wellnessTableView.delegate = self
        wellnessTableView.dataSource = self
        
        //Loads previous question and response data
        reloadQuestionData()
        reloadResponseData()
        
        //initialize a question and isSlider list made up of strings/bools
        questionList = presetQuestionStringList
        isSliderList = presetQuestionSliderList

        //calls everything that will appear on screen
        setupViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //clears the responses to prepare for new questionaire
        yesNoResults.removeAll()
        sliderValues.removeAll()
        
        //initializes the questions and responses given the amount of questions there are
        for _ in questionList {
            yesNoResults.append(nil)
            sliderValues.append(5)
        }
        
        //Reloads everything from scratch. Redisplays visible rows
        wellnessTableView.reloadData()
    }
}

// MARK: button actions
extension WellnessViewController {
    @objc func submitButtonTapped(_ sender: UIButton) {
        if yesNoResults.contains(nil) {
            let unansweredAlert = UIAlertController(title: "Notice", message: "Please answer all of the questions before submitting", preferredStyle: .alert)
            unansweredAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(unansweredAlert, animated: true)
            
        } else {
            submitButton.setTitleColor(.gray, for: .normal)
            submitButton.setButtonFrame(borderWidth: 1.0, borderColor: .systemPink, cornerRadius: 15, fillColor: .clear)
                        
            let submitAlert = UIAlertController(title: "Ready to submit?", message: "Your answers will be recorded.", preferredStyle: .actionSheet)
            
            
            submitAlert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: {
                action in
                let id = generateID()
                for i in 0..<self.questionList.count {
                    //add questions and responses to the core data
                    addQuestionData(id: id, text: self.questionList[i], bool: self.isSliderList[i])
                    addResponseData(id: id, value: self.sliderValues[i], bool: self.yesNoResults[i]!, question: questions[i])
                    
                }
                //clears the responses to prepare for new questionaire
                self.yesNoResults.removeAll()
                self.sliderValues.removeAll()
                
                //initializes the questions and responses given the amount of questions there are
                for _ in self.questionList {
                    self.yesNoResults.append(nil)
                    self.sliderValues.append(5)
                }
                
                let receivedAlert = UIAlertController(title: "Responses received!", message: "Thank you for your response.", preferredStyle: .alert)
                receivedAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                    self.wellnessTableView.reloadData()
                    self.submitButton.setTitleColor(.gray, for: .normal)
                    self.submitButton.setButtonFrame(borderWidth: 1.0, borderColor: .gray, cornerRadius: 15, fillColor: .clear)
                }))
                self.present(receivedAlert, animated: true)
            }))
            
            submitAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.submitButton.setTitleColor(.gray, for: .normal)
                self.submitButton.setButtonFrame(borderWidth: 1.0, borderColor: .gray, cornerRadius: 15, fillColor: .clear)
            }))
            
            self.present(submitAlert, animated: true)
        }
    }
}

// MARK: cell button and slider interactivitiy
extension WellnessViewController: WellnessTableViewCellDelegate {
    func yesInteract(_ tag: Int) {
        print("pressed yesButton")
        if yesNoResults[tag] == false || yesNoResults[tag] == nil {
            yesNoResults[tag] = true
        } else {
            yesNoResults[tag] = nil
        }
        wellnessTableView.reloadData()
    }
    
    func noInteract(_ tag: Int) {
        print("pressed noButton")
        if yesNoResults[tag] == true || yesNoResults[tag] == nil {
            yesNoResults[tag] = false
        } else {
            yesNoResults[tag] = nil
        }
        sliderValues[tag] = 0
        wellnessTableView.reloadData()
    }
    
    func sliderInteract(_ tag: Int, _ value: Float) {
        print("slider interaction")
        sliderValues[tag] = value
        wellnessTableView.reloadData()
    }
}

// MARK: create UI
extension WellnessViewController: ViewConstraintProtocol {
    internal func setupViews() {
        // update the header view
        headerView.updateHeader(text: "Wellness", color: hsbShadeTint(color: colorTheme, sat: 0.25), fsize: 30)
        self.view.addSubview(headerView)

        // setup the table view
        wellnessTableView.frame = .zero
        wellnessTableView.backgroundColor = .clear
        wellnessTableView.register(WellnessTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        wellnessTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //wellnessTableView.numberOfRows(inSection: questionList.count)
        self.view.addSubview(wellnessTableView)
 
        
        // setup the submit button
        submitButton.setButtonParams(color: .gray, string: "Submit Responses", ftype: "Montserrat-Regular", fsize: 20, align: .center)
        submitButton.setButtonFrame(borderWidth: 1.0, borderColor: .gray, cornerRadius: 15, fillColor: .clear)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        self.view.addSubview(submitButton)
    }
    
    internal func setupConstraints() {
        // set up header view constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        //set up submit button constraints
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        // setup table view constraints
        wellnessTableView.translatesAutoresizingMaskIntoConstraints = false
        wellnessTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        wellnessTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -55).isActive = true
        wellnessTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        wellnessTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
    }
    
    
    
    
}



// MARK: load cells with data
extension WellnessViewController: UITableViewDelegate, UITableViewDataSource {


    // required for table: number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // required for table: number of cells in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    //changes height of cells in table to accommodate sliders when they are needed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSliderList[indexPath.row] {
            return 120
        } else {
            return 80
        }
    }
    
    // required for table: sets up dequeue for cell, fills each cell with information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! WellnessTableViewCell
        let colorView = UIView()

        colorView.frame = .zero
        colorView.backgroundColor = .clear
        cell.selectedBackgroundView = colorView
        
        cell.wellnessCellDelegate = self
        cell.yesButton.tag = indexPath.row
        cell.noButton.tag = indexPath.row
        cell.slider.tag = indexPath.row
        
        //updates question cell after user clicks something like the slider or a yes or no to show that it is selected
        cell.updateQuestionCell(color: colorTheme,
                                questionNum: (indexPath.row + 1),
                                text: questionList[indexPath.row],
                                slider: isSliderList[indexPath.row],
                                answer: yesNoResults[indexPath.row],
                                sliderVal: sliderValues[indexPath.row])
        
        return cell
    }
}

