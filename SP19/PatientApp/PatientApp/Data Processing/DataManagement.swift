//
//  TableViewCell.swift
//  PatientApp
//
//  Created by Darien Joso on 3/25/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

var exerciseList = [Exercise]()
var exerciseStatsList = [ExerciseSessionStats]()
var goalList = [Goal]()
var wellnessQuestionList = [WellnessQuestion]()
var wellnessResponsesList = [WellnessResponse]()

let largeNumber: Int = 1000000000


func generateID() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    return formatter.string(from: date)
}

func getDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmssSSS"
    return formatter.date(from: string)!
}

func convertFormatFromID(id: String, format: String) -> String {
    let date = getDate(id)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func saveContext() {
    do {
        try context.save()
        print("Context saved")
    } catch {
        print("Failed saving")
    }
}





// general data management
func clearAllEntityData(entityName: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as! [NSManagedObject]
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
            print(entityName)
            print("data cleared")
        }
    } catch {
        print("Failed saving")
    }
}

func clearIndexedEntityData(_ index: Int, entityName: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let sort = NSSortDescriptor(key: "date", ascending: true)
    fetchRequest.sortDescriptors = [sort]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as! [NSManagedObject]
        if items.count > index {
            context.delete(items[index])
        }
        try context.save()
    } catch {
        print("Failed saving")
    }
}

func getData(entityName: String) {
    
    if entityName == "Exercise" {
        let sortByDate = NSSortDescriptor(key: #keyPath(Exercise.date), ascending: true)
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.sortDescriptors = [sortByDate]
        
        do {
            exerciseList = try context.fetch(fetchRequest)
            print("Fetched exercises successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    } else if entityName == "ExerciseSessionStats" {
        let sortByExercise = NSSortDescriptor(key: #keyPath(ExerciseSessionStats.exercise), ascending: true)
        let sortByDate = NSSortDescriptor(key: #keyPath(ExerciseSessionStats.date), ascending: true)
        let fetchRequest: NSFetchRequest<ExerciseSessionStats> = ExerciseSessionStats.fetchRequest()
        fetchRequest.sortDescriptors = [sortByExercise, sortByDate]
        
        do {
            exerciseStatsList = try context.fetch(fetchRequest)
            print("Fetched excercise stats successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    } else if entityName == "Goal" {
        let sortByDate = NSSortDescriptor(key: #keyPath(Goal.date), ascending: true)
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.sortDescriptors = [sortByDate]
        
        do {
            goalList = try context.fetch(fetchRequest)
            print("Fetched goals successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    } else if entityName == "WellnessQuestion" {
        let sortByDate = NSSortDescriptor(key: #keyPath(WellnessQuestion.date), ascending: true)
        let fetchRequest: NSFetchRequest<WellnessQuestion> = WellnessQuestion.fetchRequest()
        fetchRequest.sortDescriptors = [sortByDate]
        
        do {
            wellnessQuestionList = try context.fetch(fetchRequest)
            
            print("Fetched wellness questions successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    } else if entityName == "WellnessResponse" {
        let sortByQuestion = NSSortDescriptor(key: #keyPath(WellnessResponse.wellnessQuestion), ascending: true)
        let sortByDate = NSSortDescriptor(key: #keyPath(WellnessResponse.date), ascending: true)
        let fetchRequest: NSFetchRequest<WellnessResponse> = WellnessResponse.fetchRequest()
        fetchRequest.sortDescriptors = [sortByQuestion, sortByDate]
        
        do {
            wellnessResponsesList = try context.fetch(fetchRequest)
            print("Fetched wellness responses successfully")
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    } else {
        print("Entity name not recognized")
    }
}

// adding entity data
func addExercise(exerciseName: String, stats: ExerciseSessionStats?) {
    let exercise = Exercise(entity: Exercise.entity(), insertInto: context)
    exercise.date = Date()
    exercise.exerciseName = exerciseName
    exercise.exerciseSessionStats = stats
    
    do {
        try context.save()
        print("Goal saved")
    } catch {
        print("Failed saving")
    }
}

func addExerciseSessionStats(rom: Float, reps: Int, exercise: Exercise) {
//    let stats = ExerciseSessionStats(entity: ExerciseSessionStats.entity(), insertInto: context)
//    stats.date = Date()
//    stats.maxROM = rom
//    stats.repCount = Int16(reps)
//    stats.exercise = exercise
//
//    do {
//        try context.save()
//        print("Goal saved")
//    } catch {
//        print("Failed saving")
//    }
}

func addGoal(achieved: Bool, entry: String) {
    let goal = Goal(entity: Goal.entity(), insertInto: context)
    goal.date = Date()
    goal.achieved = achieved
    goal.entry = entry
    
    context.insert(goal)
    
    do {
        try context.save()
        print("Goal saved")
    } catch {
        print("Failed saving")
    }
}

func addWellnessQuestion(question: String, isSlider: Bool, response: Set<WellnessResponse>) {
    let wellnessQuestion = WellnessQuestion(entity: WellnessQuestion.entity(), insertInto: context)
    wellnessQuestion.date = Date()
    wellnessQuestion.question = question
    wellnessQuestion.isSlider = isSlider
    wellnessQuestion.wellnessResponse = response
    
    do {
        try context.save()
        print("Question saved")
    } catch {
        print("Failed saving")
    }
}

func addWellnessResponse(slider: Float, bool: Bool, question: WellnessQuestion) {
    let wellnessResponse = WellnessResponse(entity: WellnessResponse.entity(), insertInto: context)
    wellnessResponse.date = Date()
    wellnessResponse.sliderResult = slider
    wellnessResponse.yesNoResult = bool
    wellnessResponse.wellnessQuestion = question

    do {
        try context.save()
        print("Wellness Response saved")
    } catch {
        print("Failed saving")
    }
}
