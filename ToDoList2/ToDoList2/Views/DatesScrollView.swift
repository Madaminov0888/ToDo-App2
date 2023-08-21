//
//  DatesScrollView.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 30/07/23.
//

import SwiftUI

struct DatesScrollView: View {
    @EnvironmentObject var tasksViewModel: TasksViewModel
    @State var animate: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 17) {
                    ForEach(0..<tasksViewModel.dates.count) { i in
                        Button {
                            datePressButton(i: i)
                        } label: {
                            DateItemView(isToday: tasksViewModel.dates[i].isSelected, date1: tasksViewModel.dates[i])
                                .foregroundColor(.black)
                                .overlay(alignment: .topTrailing, content: {
                                    CircleView(i: i)
                                })
                                .overlay(alignment: .bottom, content: {
                                    TodayView(i: i, animate: $animate)
                                })
                                .opacity(i < 7 && tasksViewModel.selectedInt != i ? 0.4 : 1)
                                .animation(.spring())
                                
                        }
                        .padding(.bottom,7)
                        .id(i)
                        .tint(.primary)
                        .animation(.spring())

                    }
                }
                .padding()
                .onAppear {
                    withAnimation(.spring()) {
                        proxy.scrollTo(tasksViewModel.selectedInt, anchor: .center)
                        addAnimation()
                    }
                }
                .onChange(of: animate, perform: { newValue in
                    addAnimation()
                })
                .onChange(of: tasksViewModel.selectedInt) { newValue in
                    datePressButton(i: newValue)
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
    }
    func addAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                Animation
                    .spring()
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
    
    func datePressButton(i: Int) {
        for _ in 0..<tasksViewModel.getNumberOfSelections() {
            tasksViewModel.updateDateItem(item: tasksViewModel.getEnabledButton(), isFalsing: true)
        }
        tasksViewModel.selectedInt = i
        tasksViewModel.updateDateItem(item: tasksViewModel.dates[i], isFalsing: false)
    }
    
}



struct DatesScrollView_Previews: PreviewProvider {
    static var previews: some View {
        DatesScrollView()
            .environmentObject(TasksViewModel())
    }
}

struct DateItemView: View {
    @EnvironmentObject var tasksViewModel: TasksViewModel
    let isToday: Bool
    let date1: DateModel
    
    var body: some View {
        VStack {
            Text("\(tasksViewModel.getWeekdayfromInt(num: date1.weekday))")
            Text("\(Calendar.current.component(.day, from: date1.date))")
                .font(.title)
        }
        .foregroundColor(.primary)
        .frame(width: 60, height: 70)
        .background(
            Color(UIColor.systemBackground)
                .opacity(isToday ? 0.8 : 0.3)
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(isToday ? 0.4 : 0), radius: 5)
    }
}

struct CircleView: View {
    @EnvironmentObject var vm: TasksViewModel
    let i: Int
    
    var body: some View {
        if vm.getExactdaysTasks(date: vm.dates[i].date).count != 0 {
            Circle()
                .foregroundColor(.red)
                .frame(width: 24)
                .overlay(alignment: .center) {
                    Text("\(vm.getExactdaysTasks(date: vm.dates[i].date).count)")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .offset(x: 3, y: -8)
        }
    }
}

struct TodayView: View {
    @EnvironmentObject var vm: TasksViewModel
    let i: Int
    @Binding var animate: Bool
    
    var body: some View {
        if Calendar.current.isDateInToday(vm.dates[i].date) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.green)
                .frame(width: animate ? 50 : 55, height: animate ? 20 : 22)
                .overlay {
                    Text("Today")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                .offset(y: animate ? 10 : 13)
        }
    }
}

