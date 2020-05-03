//
//  CoreDataViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/23/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

class CDViewController: UIViewController {

    private let colorTheme: UIColor = hsbShadeTint(color: .orange, sat: 0.50)
    // global variable
    var selectedRowIndex: Int = largeNumber
    
    // subviews
    let headerView = Header()

    // construction variables
    let homeButton = UIButton()
    
    let entitySelection = UISegmentedControl(items: ["Exercises", "Sessions", "Goals", "Responses"])
    let fakeButton = UIButton()
    let loadButton = UIButton()
    let resetButton = UIButton()
    let addButton = UIButton()
    let removeButton = UIButton()
    let dataTable = UITableView()
    let cellIdentifier = "wellnessCell"

    var entity: String = "Exercise"
    var cellName: String = "Exercises"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.delegate = self
        dataTable.dataSource = self
        
        dataTable.register(CDTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataTable.rowHeight = 60
        
        getData(entityName: entity)
        dataTable.reloadData()
    }
}

extension CDViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = entitySelection.selectedSegmentIndex
        if section == 0 {
            return exerciseList.count
        } else if section == 1 {
            return 0
        } else if section == 2 {
            return goalList.count
        } else if section == 3 {
            return wellnessQuestionList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CDTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .short
        
        var dateString = String()
        var data0String = String()
        var data1String = String()
        var data2String = String()
        
        let section = entitySelection.selectedSegmentIndex
        print(section)
        
        if section == 0 {
            
            dateString = "date: \(dateFormatter.string(from: exerciseList[indexPath.row].date))"
            data0String = "\(indexPath.row): \(exerciseList[indexPath.row].exerciseName)"
            data1String = ""
            data2String = ""
            
        } else if section == 1 {
            return UITableViewCell()
        } else if section == 2 {
            
            dateString = "date: \(dateFormatter.string(from: goalList[indexPath.row].date))"
            data0String = "\(indexPath.row): \(goalList[indexPath.row].entry)"
            data1String = "achieved: \(goalList[indexPath.row].achieved)"
            data2String = ""

        } else if section == 3 {
            //@Ragini, we weren't able to figure out how to clear the responses correctly, we just used a band-aid if/else statement to solve it.
            if wellnessResponsesList.count == 0 {
                dateString = ""
                data0String = ""
                data1String = ""
                data2String = ""
            }
            else {
            dateString = "date: \(dateFormatter.string(from: wellnessResponsesList[indexPath.row].date))"
            data1String = "Response: \(wellnessResponsesList[indexPath.row].yesNoResult)"
            data2String = "Slider Value: \(wellnessResponsesList[indexPath.row].sliderResult)"
            data0String = "\(String(describing: wellnessQuestionList[indexPath.row].question))"
            }
            
        } else {
            return UITableViewCell()
        }
        
        cell.updateCell(date: dateString, data0: data0String, data1: data1String, data2: data2String)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRowIndex != indexPath.row {
            selectedRowIndex = indexPath.row
        } else {
            selectedRowIndex = largeNumber
            dataTable.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension CDViewController: ViewConstraintProtocol {
    func setupViews() {
        headerView.updateHeader(text: "Core Data", color: hsbShadeTint(color: colorTheme, sat: 0.20), fsize: 30)
        self.view.addSubview(headerView)
        
        homeButton.setButtonParams(color: .gray, string: "Home", ftype: "Montserrat-Regular", fsize: 16, align: .center)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        self.view.addSubview(homeButton)
        
        groupButtonSetup(button: loadButton, text: "Load", action: #selector(loadData))
        //groupButtonSetup(button: fakeButton, text: "Fake", action: #selector(fakeData))
        groupButtonSetup(button: addButton, text: "Add", action: #selector(addData))
        groupButtonSetup(button: removeButton, text: "Del", action: #selector(removeData))
        groupButtonSetup(button: resetButton, text: "Reset", action: #selector(resetData))
        
        entitySelection.selectedSegmentIndex = 0
        entitySelection.tintColor = colorTheme
        entitySelection.addTarget(self, action: #selector(entitySelectionTapped), for: .valueChanged)
        self.view.addSubview(entitySelection)
        
        self.view.addSubview(dataTable)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        homeButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        homeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        homeButton.widthAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        
        entitySelection.translatesAutoresizingMaskIntoConstraints = false
        entitySelection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        entitySelection.heightAnchor.constraint(equalToConstant: 40).isActive = true
        entitySelection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        entitySelection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
   /*     fakeButton.translatesAutoresizingMaskIntoConstraints = false
        fakeButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        fakeButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        fakeButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        fakeButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10).isActive = true
 */
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        loadButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        loadButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        loadButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10).isActive = true

        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        removeButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        removeButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 10).isActive = true

        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.topAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalTo: addButton.heightAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: removeButton.trailingAnchor, constant: 10).isActive = true
        
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.topAnchor.constraint(equalTo: entitySelection.bottomAnchor, constant: 20).isActive = true
        dataTable.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -20).isActive = true
        dataTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        dataTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func groupButtonSetup(button: UIButton, text: String, action: Selector) {
        button.setButtonParams(color: .white, string: text, ftype: "Montserrat-Regular", fsize: 14, align: .center)
        button.setButtonFrame(borderWidth: 0.25, borderColor: colorTheme, cornerRadius: 20, fillColor: colorTheme)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.view.addSubview(button)
    }
}

// button actions
extension CDViewController {
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHomeVCFromCDVC", sender: sender)
    }
    
    @objc func entitySelectionTapped(_ sender: UISegmentedControl) {
        entity = getEntityString(entitySelection.selectedSegmentIndex)
        cellName = getCellNameString(entitySelection.selectedSegmentIndex)
        
        print("\(cellName)s")
        
        switch entitySelection.selectedSegmentIndex {
        case 0: // exercise
            dataTable.rowHeight = 60
            getData(entityName: entity)
            dataTable.reloadData()
        case 1: // stats
            dataTable.rowHeight = 20
            getData(entityName: entity)
            dataTable.reloadData()
        case 2: // goal
            dataTable.rowHeight = 85
            getData(entityName: entity)
            dataTable.reloadData()
        case 3: // question
            dataTable.rowHeight = 105
            getData(entityName: "WellnessQuestion")
            getData(entityName: entity)
            dataTable.reloadData()
        default:
            print("No entity selected")
            dataTable.rowHeight = 44
            getData(entityName: entity)
            dataTable.reloadData()
        }
    }
    
    // need to implement 2 more for load, fake, and add
    @objc func loadData(_ sender: UIButton) {
        print("load data")
        if entitySelection.selectedSegmentIndex == 0 {
            for i in 0..<presetExerciseList.count {
                addExercise(exerciseName: presetExerciseList[i], stats: nil)
            }
      //  } else if entitySelection.selectedSegmentIndex == 1 {
            
        } else if entitySelection.selectedSegmentIndex == 2 {
            for i in 0..<presetGoalList.count {
                addGoal(achieved: false, entry: presetGoalList[i])
            }
      /*  } else if entitySelection.selectedSegmentIndex == 3 {
            print("load question data")
            var string: String!
            var bool: Bool!
            for i in 0..<presetWellnessQuestionList.count {
                string = presetQuestionStringList[i]
                bool = presetQuestionSliderList[i]
                addWellnessQuestion(question: string, isSlider: bool, response: Set<WellnessResponse>())

            }
        } else if entitySelection.selectedSegmentIndex == 4 {
            print("load response data")
            
        */
            
        } else {
            
        }
        
        getData(entityName: entity)
        dataTable.reloadData()
    }

    @objc func fakeData(_ sender: UIButton) {
        print("fake data")
        let number = Int.random(in: 1000..<10000)
        //let questionfake = [WellnessQuestion]()
        //questionfake[1].question = "Hi imdoug"
        if entitySelection.selectedSegmentIndex == 0 {
            addExercise(exerciseName: "Exercise number \(number)", stats: nil)
        } else if entitySelection.selectedSegmentIndex == 1 {
//            addExerciseSessionStats(rom: Float(number), reps: number, exercise: )
        } else if entitySelection.selectedSegmentIndex == 2 {
            addGoal(achieved: Bool.random(), entry: "Goal number \(number)")
        } else if entitySelection.selectedSegmentIndex == 3 {
            addWellnessQuestion(question: "Question number \(number)", isSlider: Bool.random(), response: Set<WellnessResponse>())
        } else if entitySelection.selectedSegmentIndex == 4 {
            //addWellnessResponse(slider: 5, bool: Bool.random(), question: questionfake[1])
        } else {
            
        }
        
        getData(entityName: self.entity)
        dataTable.reloadData()
    }
    
    @objc func addData(_ sender: UIButton) {
        print("add data")
        var goalText: String!

        let alert = UIAlertController(title: "Add \(cellName)", message: "Enter text here", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        if self.entitySelection.selectedSegmentIndex == 0 {
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                goalText = textField.text
                addExercise(exerciseName: goalText, stats: nil)
                getData(entityName: self.entity)
                self.dataTable.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
 /*       } else if self.entitySelection.selectedSegmentIndex == 1 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
  */
        } else if self.entitySelection.selectedSegmentIndex == 2 {
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                goalText = textField.text
                addGoal(achieved: false, entry: goalText)
                getData(entityName: self.entity)
                self.dataTable.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
   /*     } else if self.entitySelection.selectedSegmentIndex == 3 {
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                goalText = textField.text
                addWellnessQuestion(question: goalText, isSlider: false, response: Set<WellnessResponse>())
                getData(entityName: self.entity)
                self.dataTable.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        } else if self.entitySelection.selectedSegmentIndex == 4 {
            
*/        }

        //self.present(alert, animated: true, completion: nil)
    }
    
    @objc func removeData(_ sender: UIButton) {
        print("remove data")
        clearIndexedEntityData(selectedRowIndex, entityName: self.entity)
        getData(entityName: self.entity)
        self.dataTable.reloadData()
        selectedRowIndex = largeNumber
    }
    
    @objc func resetData(_ sender: UIButton) {
        print("reset data")
        let alert = UIAlertController(title: "Warning", message: "Clear All \(cellName)s", preferredStyle: .alert)
        
        
        //@Ragini, we weren't able to figure out how to clear the responses correctly, we just used a band-aid if/else statement to solve it.
        alert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { action in
            if self.entity != "WellnessResponse"{
                clearAllEntityData(entityName: self.entity)
                getData(entityName: self.entity)
                self.dataTable.reloadData()
            }
            else {
                clearAllEntityData(entityName: "WellnessQuestion")
                getData(entityName: "WellnessQuestion")
                clearAllEntityData(entityName: "WellnessResponse")
                getData(entityName: "WellnessResponse")
                self.dataTable.reloadData()
                
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func getEntityString(_ x: Int) -> String {
        if x == 0 {
            return "Exercise"
        } else if x == 1 {
            return "ExerciseSessionStats"
        } else if x == 2 {
            return "Goal"
        } else if x == 3 {
            return "WellnessResponse"
        } else {
            return ""
        }
    }
    
    func getCellNameString(_ x: Int) -> String {
        if x == 0 {
            return "Exercise"
        } else if x == 1 {
            return "Session"
        } else if x == 2 {
            return "Goal"
        } else if x == 3 {
            return "Response"
        } else {
            return ""
        }
    }
}
