//
//  ToDoList2App.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 28/07/23.
//

import SwiftUI

@main
struct ToDoList2App: App {
    @StateObject var tasksViewModel: TasksViewModel = TasksViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                MainPage()
            })
            .environmentObject(tasksViewModel)
        }
    }
}
