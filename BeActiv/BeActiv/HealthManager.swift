//
//  HealthManager.swift
//  BeActiv
//
//  Created by Danyal Nemati on 11/9/23.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    //refrence to health store
    let healthStore = HKHealthStore()
    
    //need a dictionary since we will be looping and displaying in the HomeView
    //and allow reuse of different views
    @Published var activities: [String : Activity] =  [:]
    
    //trying to build a mock for preview in HomeView
    @Published var mockActivities: [String : Activity] =  [
        "todaySteps" : Activity(id: 0, title: "Todays steps ", subtitle: "Goal: 10,000 ", image: "figure.walk.motion", amount: "15,317"),
        "todayCalories" : Activity(id: 1, title: "Todays Calories ", subtitle: "Goal: 900 ", image: "flame", amount: "1,852")
    ]
    
    
    init() {
        //calls step count feature of HK
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        
        //array since requesting multiple stuff
        let healthTypes: Set = [steps, calories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                //notify if there's any errors fething
            } catch {
                print("error fetching health data")
            }
        }
        
    }
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        //basically the timeline of when the steps start counting
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_,result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Todays steps ", subtitle: "Goal: 10,000 ", image: "figure.walk.motion", amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            }
            
            
            //shows steps in executable
            print(stepCount.formattedString())
        }
        healthStore.execute(query)
        
        
    }
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) {_, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }
            let calroiesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Todays Calories ", subtitle: "Goal: 900 ", image: "flame", amount:
                calroiesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            }
            
            
            //shows steps in executable
            print(calroiesBurned.formattedString())
        }
        healthStore.execute(query)
    }
}
//extensiton funcion that truns a string to a double with correct comma formatting and no decimals
extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        // Convert the double value to a formatted string
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
