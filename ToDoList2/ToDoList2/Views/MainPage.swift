//
//  MainPage.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 28/07/23.
//

import SwiftUI

struct MainPage: View {
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @State var offsetOfAll: CGFloat = 0.0
    
    
    var body: some View {
        ZStack {
            //Background
            Image("BackgroundPhoto")
                .resizable()
                .ignoresSafeArea()
            
            
            VStack {
                //isselectedni togle atganda o'chishi mumkin!!!
                DatesScrollView()
                    .frame(height: 90)
                
                Divider()
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                TasksView(offsetOfAll: $offsetOfAll)
                    .transition(.scale)
            
                Spacer()
            }
            .toolbar {
                addButton
                editButton
            }
        }
        .onAppear(perform: tasksViewModel.multiplyTasksByRepeating)
        .fontDesign(.rounded)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle(tasksViewModel.getSelectedDateInfo())
        .navigationBarTitleDisplayMode(.inline)
    }
}

//MARK: MainPage extentions
extension MainPage {
    private var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation(.spring()) {
                    tasksViewModel.offsetIncreaseBool = !tasksViewModel.offsetIncreaseBool
                }
            } label: {
                HStack {
                    if offsetOfAll < 0 {
                        Text("Done")
                            .fontWeight(.semibold)
                    } else {
                        Image(systemName: "square.and.pencil")
                            .padding(.trailing, -5)
                        Text("Edit")
                    }
                }
            }
            .tint(.primary)

        }
    }
    
    private var addButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                AddTaskView()
            } label: {
                HStack {
                    if offsetOfAll >= 0 {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.primary)
                    } else {
                        Text("Cancel")
                            .font(.headline)
                    }
                }
            }
            .disabled(tasksViewModel.selectedInt < 7)
            .opacity(tasksViewModel.selectedInt < 7 ? 0.7 : 1)
            .tint(.primary)
        }
    }
}


struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            MainPage()
        })
        .environmentObject(TasksViewModel())
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct TasksView: View {
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @State var offset: CGFloat = 0
    @Binding var offsetOfAll: CGFloat
    
    var body: some View {
        VStack {
            TasksBottomView(offsetOfAll: $offsetOfAll)
        }
        .offset(x: offset, y: 0)
        .onTapGesture { }
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation(.spring()) {
                        offset = value.translation.width
                    }
                })
                .onEnded({ value in
                    withAnimation(.spring()) {
                        if value.translation.width < -40 {
                            datePressButton(i: tasksViewModel.selectedInt+1)
                            offset = 0
                        } else if value.translation.width > 60 {
                            datePressButton(i: tasksViewModel.selectedInt-1)
                            offset = 0
                        } else {
                            offset = 0
                        }
                        offset = 0
                    }
                })
        )
    }
    
    
    func datePressButton(i: Int) {
        for _ in 0..<tasksViewModel.getNumberOfSelections() {
            tasksViewModel.updateDateItem(item: tasksViewModel.getEnabledButton(), isFalsing: true)
        }
        tasksViewModel.selectedInt = i
        tasksViewModel.updateDateItem(item: tasksViewModel.dates[i], isFalsing: false)
    }
}
