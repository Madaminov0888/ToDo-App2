//
//  TasksBottomView.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 04/08/23.
//

import SwiftUI

struct TasksBottomView: View {
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @Binding var offsetOfAll: CGFloat
    
    var body: some View {
        VStack {
        
            if tasksViewModel.getExactdaysTasks(date: tasksViewModel.getEnabledButton().date).count < 1 {
                noItemsView()
                    .transition(.scale)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(tasksViewModel.getExactdaysTasks(date: tasksViewModel.getEnabledButton().date)) { task in
                            ItemRectangleView(task: task)
                                .transition(.scale)
                        }
                    }
                    .padding(.horizontal)
                }
                .transition(.scale)
            }
        }
    }
}

struct TasksBottomView_Previews: PreviewProvider {
    static var previews: some View {
        TasksBottomView(offsetOfAll: .constant(0))
            .environmentObject(TasksViewModel())
    }
}



struct ItemRectangleView: View {
    @State var task: TasksEntity
    @EnvironmentObject var vm: TasksViewModel
    @State var offsetX: CGFloat = 0
    @State var currentX: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            if offsetX > 30 {
                DoneButton
                    .animation(.spring(), value: 1)
                    .transition(.asymmetric(insertion: .move(edge: .leading),
                                            removal: .move(edge: .leading)))
                    .padding(.trailing, 10)
            } else if offsetX < -30 || vm.offsetIncreaseBool{
                HStack {
                    Spacer()
                    deleteButton
                        .padding(.leading, 10)
                }
                .animation(.spring(), value: 1)
                .transition(.asymmetric(insertion: .move(edge: .trailing),
                                        removal: .move(edge: .trailing)))
            }
            Spacer()

            
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: task.doneTask ? 328 : 12, height: 80)
                    .padding()
                    .padding(.leading,6)
                    .foregroundColor(.green)
                
                
                HStack {
                    
                    textsVstack
                        .padding(.leading, 48)
                        .padding(.trailing, 20)
                        .foregroundColor(.primary)
                        .padding(.vertical)
//                    Text(task.time?.description ?? "")
                    
                    VStack {
                        Text(vm.getFixedTimeOfDate(date: task.time ?? Date()))
                        Text("|")
                        Text(vm.getFixedTimeOfDate(date: task.endTime ?? Date()))
                    }
                    .fontDesign(.rounded)
                    .padding(.trailing, 25)
                }
                
                
                
                Spacer()
            }
            .frame(minWidth: 360, maxWidth: 380,maxHeight: 100)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .offset(x: vm.offsetIncreaseBool ? -130 : offsetX, y: 0)
            .gesture(
                DragGes
            )
        }
    }
}

//MARK: Extensions

extension ItemRectangleView {
    private var DoneButton: some View {
        Button {
            withAnimation(.spring()) {
                vm.updateDoneTask(task: task)
                offsetX = 0
                HapticManager.instance.notification(type: .success)
            }
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 110)
                .foregroundColor(task.doneTask ? .orange : .green)
                .padding(.trailing, 5)
                .offset(x: 0, y: 0)
                .overlay {
                    VStack {
                        Image(systemName: task.doneTask ? "xmark.circle" : "checkmark.circle")
                            .font(.largeTitle)
                        Text(task.doneTask ? "Undo" : "Done")
                            .fontDesign(.rounded)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                }
        }
    }
    
    private var deleteButton: some View {
        Button {
            withAnimation(.spring()) {
                vm.deleteTaskEntity(index: IndexSet(), task: task)
                offsetX = 0
                HapticManager.instance.notification(type: .warning)
            }
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 110)
                .foregroundColor(.red)
                .padding(.trailing, 5)
                .offset(x: 0, y: 0)
                .overlay {
                    VStack {
                        Text("Delete")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                    }
                    .foregroundColor(.white)
                }
        }
    }
    
    
    private var DragGes: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged({ value in
                withAnimation(.spring()) {
                    offsetX = value.translation.width
                }
            })
            .onEnded({ value in
                withAnimation(.spring()) {
                    if currentX == 0 {
                        if !(offsetX > 30) && offsetX > 0 {
                            offsetX = 0
                            currentX = 0
                        } else if offsetX > 30 {
                            offsetX = 120
                            currentX = 120
                        } else if offsetX < -30 {
                            offsetX = -130
                            currentX = -130
                        } else {
                            offsetX = 0
                            currentX = 0
                        }
                    } else {
                        offsetX = 0
                        currentX = 0
                    }
                }
            })
    }
    
    private var textsVstack: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.title ?? "Error")
                    .fontDesign(.rounded)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom, 0.5)
            
            Text(task.target ?? "Target")
                .fontDesign(.rounded)
                .font(.title3)
                .fontWeight(.semibold)

            Spacer()
        }
    }
}


