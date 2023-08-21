//
//  TasksViewModel.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 28/07/23.
//

import Foundation
import CoreData



class TasksViewModel: ObservableObject {
    @Published var offsetIncreaseBool: Bool = false
    var selectedInt: Int = 7
    let container: NSPersistentContainer
    @Published var tasksList: [TasksEntity] = []
    @Published var dates: [DateModel] = []
    
    
    //init
    init() {
        container = NSPersistentContainer(name: "TasksCoreData")
        container.loadPersistentStores { descr, error in
            if let error = error {
                print("Error loeading: \(error)")
            }
        }
        fetchItems()
        getDateFromNow()
    }
    
    
    //MARK: Date functinos
    func getNumberOfSelections() -> Int {
        var s = 0
        for i in dates {
            if i.isSelected == true {
                s += 1
            }
        }
        return s
    }
    
    func gtb(date1: Date, date2: Date) -> Bool{
        return date1.timeIntervalSince(date2).sign != FloatingPointSign.minus
    }
    
    func checkForId(date1: Date, id: String) -> Bool {
        for i in tasksList {
            if equalityOfTwoDates(date1: i.time ?? Date(), date2: date1) && i.id == id {
                return true
            }
        }
        return false
    }
    
    func multiplyTasksByRepeating() {
        let dateOfLimit: Date = Calendar.current.date(byAdding: .day, value: 21, to: Date()) ?? Date()
        for i in tasksList {
            if i.repeatWeek {
                let date1Of: Date = Calendar.current.date(byAdding: .day, value: 7, to: i.time ?? Date()) ?? Date()
                if gtb(date1: dateOfLimit, date2: date1Of) && !checkForId(date1: date1Of, id: i.id ?? "") {
                    addTaskEntity(time: date1Of, descriptionOfTask: i.descriptionOfTask!, title: i.title ?? "Title2", doneTask: false, id: i.id ?? UUID().uuidString, target: i.target ?? "Target2", endTime: i.endTime ?? Date(), repeatWeek: i.repeatWeek, repeatMonth: i.repeatMonth)
                }
            }
        }
    }
    
    
    func equalityOfTwoDates(date1: Date, date2: Date) -> Bool {
        return Calendar.current.component(.day, from: date1) == Calendar.current.component(.day, from: date2) && Calendar.current.component(.month, from: date1) == Calendar.current.component(.month, from: date2) && Calendar.current.component(.year, from: date1) == Calendar.current.component(.year, from: date2)
    }
    
    
    func getExactdaysTasks(date: Date) -> [TasksEntity] {
        var newTasksList: [TasksEntity] = []
        for i in tasksList {
            if equalityOfTwoDates(date1: i.time!, date2: date) {
                print(i.time!.description)
                print(date.description)
                newTasksList.append(i)
            }
//            else if i.repeatWeek && Calendar.current.component(.weekday, from: date) == Calendar.current.component(.weekday, from: i.time ?? Date()) && gtb(date1: date, date2: i.time ?? Date()){
//                newTasksList.append(i)
//            } else if i.repeatMonth && Calendar.current.component(.day, from: date) == Calendar.current.component(.day, from: i.time ?? Date()) && gtb(date1: date, date2: i.time ?? Date()){
//                newTasksList.append(i)
//            }
        }
        return newTasksList
    }
    
    
    func getEnabledButton() -> DateModel {
        for i in dates {
            if i.isSelected {
                return i
            }
        }
        return DateModel(date: Date())
    }
    
    func voidOnAppear() {
        for i in dates {
            if Calendar.current.isDateInToday(i.date) {
                if let index = dates.firstIndex(where: { $0.id == i.id }) {
                    dates[index] = i.updateCompletion(isFalsing: false)
                }
            }
        }
    }
    
    
    func updateDateItem(item: DateModel, isFalsing: Bool) {
        if let index = dates.firstIndex(where: { $0.id == item.id }) {
            dates[index] = item.updateCompletion(isFalsing: isFalsing)
        }
    }
    
    
    func getWeekdayfromInt(num: Int) -> String {
        let dct: [Int: String] = [
            1: "Sun",
            2: "Mon",
            3: "Tu",
            4: "Wed",
            5: "Thr",
            6: "Fri",
            7: "Sat"
        ]
        return dct[num] ?? "Error"
    }
    
    
    func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    
    func getDateFromNow() {
        let today: Date = Date()
        let fromDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        let toDate: Date = Calendar.current.date(byAdding: .day, value: 21, to: today) ?? Date()
        for date1 in dates(from: fromDate, to: toDate) {
            if Calendar.current.isDateInToday(date1) {
                dates.append(DateModel(date: date1, isSelected: true))
            } else {
                dates.append(DateModel(date: date1, isSelected: false))
            }
        }
        
    }
    
    
    func getFixedTimeOfDate(date: Date) -> String {
        let hourOfDate: String = String(Calendar.current.component(.hour, from: date))
        let minuteOfDate: String = String(Calendar.current.component(.minute, from: date))
        return hourOfDate + ":" + (minuteOfDate.count < 2 ? "0\(minuteOfDate)" : minuteOfDate)
    }
    
    
    ///end of date functions


    
    //MARK: Core data functions
    func fetchItems() {
        let request = NSFetchRequest<TasksEntity>(entityName: "TasksEntity")
        
        do {
            tasksList = try container.viewContext.fetch(request)
        } catch let error {
            print("Error while fetching: \(error)")
        }
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchItems()
        } catch let error {
            print("Error occured while saving: \(error)")
        }
    }
    
    func updateDoneTask(task: TasksEntity) {
        for i in 0..<tasksList.count {
            if tasksList[i].id == task.id && equalityOfTwoDates(date1: tasksList[i].time!, date2: task.time!) {
                print("\(String(describing: tasksList[i].id))"+"\(String(describing: tasksList[i].time?.description))")
                print("\(String(describing: task.id))"+"\(task.time!.description)")
                task.doneTask = !task.doneTask
                tasksList[i] = task
            }
        }
        saveData()
    }
    
    
    func addTaskEntity(time: Date, descriptionOfTask: String, title: String, doneTask: Bool = false, id: String = UUID().uuidString, target: String, endTime: Date, repeatWeek: Bool, repeatMonth: Bool) {
        let newTaskEntity: TasksEntity = TasksEntity(context: container.viewContext)
        newTaskEntity.time = time
        newTaskEntity.descriptionOfTask = descriptionOfTask
        newTaskEntity.title = title
        newTaskEntity.doneTask = doneTask
        newTaskEntity.id = id
        newTaskEntity.target = target
        newTaskEntity.endTime = endTime
        newTaskEntity.repeatWeek = repeatWeek
        newTaskEntity.repeatMonth = repeatMonth
        saveData()
    }
    
    
    func deleteTaskEntity(index: IndexSet, task: TasksEntity) {
        container.viewContext.delete(task)
        saveData()
        fetchItems()
    }
    
    func getSelectedDateInfo() -> String {
        let date: DateModel = getEnabledButton()
        var text: String = ""
        let monthInt = Calendar.current.component(.month, from: date.date)
        text += Calendar.current.monthSymbols[monthInt-1]
        text += " " + String(Calendar.current.component(.day, from: date.date))
        return text
    }
    //end of core data functions
    
}
