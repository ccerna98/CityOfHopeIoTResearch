//
//  PresetData.swift
//  PatientApp
//
//  Created by Darien Joso on 3/26/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//  Edited by Douglas Raigosa and Celeste Cerna 05/2020

import UIKit

// Exercise
let presetExerciseList = ["Front Arm Raise",
                          "Side Arm Raise",
                          "Medicine Ball Overhead Circles",
                          "Arnold Shoulder Press",
                          "Dumbell Shoulder Press"]

// Exercise Session Statistics
struct ExerciseStatsStruct {
    var rangeOfMotion: Float
    var repetitions: Int16
    var exercise: Exercise
}

let presetExerciseStats = [ExerciseStatsStruct(rangeOfMotion: 15.5, repetitions: 2, exercise: Exercise(context: context))]

// Goals
let presetGoalList = ["Cook for all of my kids",
                      "Put on makeup by myself",
                      "Tie up my hair",
                      "Shower by myself",
                      "Drive myself to work"]

// preset question list and whether or not they're sliders
// used to create wellness views

let presetQuestionStringList = ["Do you have any pain?",
                                "Do you have tightness?",
                                "Are you experiencing any hardening, thickening, or redness of the skin?",
                                "Are you experiencing any swelling in your arms?",
                                "Are you experiencing any heaviness in your arms?",
                                "Do you have anxiety pain?",
                                "Can you put on your shirt without assistance?",
                                "Can you put on your pants without assistance?",
                                "Can you comb your hair without assistance?",
                                "Can you shower without assistance?",
                                "Can you use the toilet without assistance?",
                                "Can you perform light cooking without assistance?",
                                "Can you perform light house cleaning without assistance?"]

let presetQuestionSliderList = [true, true, false, false, false, true, false, false, false, false, false, false, false, false]

// Wellness Response
