//
//  DateModel.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 28/07/23.
//

import Foundation


struct DateModel: Identifiable, Hashable {
    let id: String
    var date: Date
    var weekday: Int = 0
    var isSelected: Bool
    
    init(id: String = UUID().uuidString ,date: Date, isSelected: Bool = false) {
        self.id = id
        self.date = date
        self.weekday = Calendar.current.component(.weekday, from: date)
        self.isSelected = isSelected
    }
    
    func updateCompletion(isFalsing: Bool) -> DateModel {
        if isFalsing == true {
            return DateModel(id: id, date: date)
        } else {
            return DateModel(id: id, date: date, isSelected: !isSelected)
        }
    }
    
}
