//
//  ResponseDataManagement.swift
//  PatientApp
//
//  Created by Darien Joso on 4/4/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit
import CoreData

// MARK: Response Data Management
var responses = [WellnessResponse]()

func getResponseData(_ sort: [NSSortDescriptor]) -> [WellnessResponse] {
    let fetchRequest: NSFetchRequest<WellnessResponse> = WellnessResponse.fetchRequest()
    fetchRequest.sortDescriptors = sort
    
    do {
        let responseArr = try context.fetch(fetchRequest)
        print("Fetched response data successfully")
        return responseArr
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return []
}

func reloadResponseData() {
    responses = getResponseData( [NSSortDescriptor(key: #keyPath(WellnessResponse.id), ascending: true)] )
}

func reloadResponseData(_ sort: [NSSortDescriptor]) {
    responses = getResponseData(sort)
}

func addResponseData(id: String, value: Float, bool: Bool, question: WellnessQuestion?) {
    let response = WellnessResponse(context: context)
    response.id = id
    response.date = Date()
    response.sliderResult = value
    response.yesNoResult = bool
    question?.addToWellnessResponse(response)
    
    do {
        try context.save()
        print("Response saved")
    } catch {
        print("Failed saving")
    }
}

func deleteResponseData(_ index: Int) {
    let sortByID = NSSortDescriptor(key: #keyPath(WellnessResponse.id), ascending: true)
    let fetchRequest: NSFetchRequest<WellnessResponse> = WellnessResponse.fetchRequest()
    fetchRequest.sortDescriptors = [sortByID]
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest)
        if items.count > index {
            if let question = items[index].wellnessQuestion {
                question.removeFromWellnessResponse(items[index])
            }
            context.delete(items[index])
        }
        try context.save()
        print("Deleted response data successfully")
    } catch {
        print("Failed saving")
    }
}

func clearResponseData() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Response")
    fetchRequest.includesPropertyValues = false
    
    do {
        let items = try context.fetch(fetchRequest) as! [NSManagedObject]
        if items.count > 0 {
            for index in 0..<items.count {
                context.delete(items[index])
            }
            try context.save()
        }
        print("Cleared response data successfully")
    } catch {
        print("Failed saving")
    }
}

var questionResponses = [[WellnessResponse]]()

func getQuestionResponseData() -> [[WellnessResponse]] {
    let questionArray = getQuestionData([NSSortDescriptor(key: #keyPath(WellnessQuestion.id), ascending: true)])
    var responseArrayArray = [[WellnessResponse]]()
    for question in questionArray {
        responseArrayArray.append(Array(question.wellnessResponse))
    }
    
    return responseArrayArray
}

func reloadQuestionResponseData() {
    questionResponses.removeAll()
    questionResponses = getQuestionResponseData()
    questionResponses.append(getNilQuestionResponseData())
}

func getNilQuestionResponseData() -> [WellnessResponse] {
    let fetchRequest: NSFetchRequest<WellnessResponse> = WellnessResponse.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "question == nil")
    
    do {
        let nilResponseArray = try context.fetch(fetchRequest)
        return nilResponseArray
    } catch {
        print("No data")
    }
    
    return []
}

func deleteQuestionResponseData(_ section: Int, _ row: Int) {
    var responseArrayArray = getQuestionResponseData()
    responseArrayArray.append(getNilQuestionResponseData())
    
    if section < responseArrayArray.count {
        if row < responseArrayArray[section].count {
            context.delete(responseArrayArray[section][row])
        }
    }
    
    do {
        try context.save()
        print("Deleted response data successfully")
    } catch {
        print("Failed saving")
    }
}
