//
//  AddTaskView.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 02/08/23.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskViewModel: TasksViewModel
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var description: String = ""
    @State var dateOfTask: Date = Date()
    @State var endTimeOfTask: Date = Date()
    @State var target: String = ""
    @State var everyWeek: Bool = false
    @State var everyMonth: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section {
                        TextField("Title", text: $title)
                            .font(.title3)
                            .padding(.vertical, 5)
                        TextField("Target", text: $target)
                            .font(.title3)
                            .padding(.vertical, 5)
                        TextField("Description", text: $description, axis: .vertical)
                            .font(.title3)
                            .lineLimit(4...)
                            .padding(5)
                    }
                    .onAppear {
                        dateOfTask = taskViewModel.getEnabledButton().date
                    }
                    Section {
                        DatePicker("Date of Task", selection: $dateOfTask, displayedComponents: .date)
                            .font(.title3)
                            .padding(5)
                        DatePicker("Start time", selection: $dateOfTask, displayedComponents: .hourAndMinute)
                            .font(.title3)
                            .padding(5)
                        DatePicker("End time", selection: $endTimeOfTask, displayedComponents: .hourAndMinute)
                            .font(.title3)
                            .padding(5)
                    }
                    
                    Section {
                        Toggle("Repeat Every week", isOn: $everyWeek)
                            .font(.title3)
                            .padding(.vertical, 5)
                            .disabled(everyMonth)
                        Toggle("Repeat Every month", isOn: $everyMonth)
                            .font(.title3)
                            .padding(.vertical, 5)
                            .disabled(everyWeek)
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .background(
                    Image("BackgroundPhoto")
                        .resizable()
                        .ignoresSafeArea()
                )
                
                Button {
                    taskViewModel.addTaskEntity(time: dateOfTask,
                                                descriptionOfTask: description,
                                                title: title,
                                                doneTask: false,
                                                target: target,
                                                endTime: endTimeOfTask,
                                                repeatWeek: everyWeek,
                                                repeatMonth: everyMonth)
                    dismiss.callAsFunction()
                } label: {
                    Text("Save".uppercased())
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
                
            }
            .background(
                Image("BackgroundPhoto")
                    .resizable()
                    .ignoresSafeArea()
            )
            
            
        }

    }
}




struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTaskView()
                .environmentObject(TasksViewModel())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                }
        }
    }
}
