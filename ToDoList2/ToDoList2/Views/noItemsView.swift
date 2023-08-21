//
//  noItemsView.swift
//  ToDoList2
//
//  Created by Muhammadjon Madaminov on 04/08/23.
//

import SwiftUI

struct noItemsView: View {
    @State var animate: Bool = false
    let secondaryAccentColor = Color("onWave")
    let accentColor = Color("onWave2")
    
    
    var body: some View {
        ScrollView {
            Image(systemName: "note.text.badge.plus")
                .resizable()
                .foregroundColor(.secondary)
                .scaledToFit()
                .frame(width: 200, height: 100)
                .padding(.top, 30)
            Text("There is not tasks !")
                .font(.title)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                
                .padding(.horizontal, 30)
//            Text("Are you a productive person? I think you should click add button")
//                .foregroundColor(.secondary)
//                .padding(.horizontal,30)
            NavigationLink {
                AddTaskView()
            } label: {
                Text("Add something 🥳")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(animate ? secondaryAccentColor : accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal, animate ? 60 : 90)
            .shadow(color: animate ? secondaryAccentColor.opacity(0.7) : accentColor.opacity(0.7),
                    radius: animate ? 30 : 20,
                    x: 0,
                    y: animate ? 50 : 30)
            .scaleEffect(animate ? 1.1 : 1.0)
            .offset(y: animate ? -7 : 0)
            Spacer()

        }
        .frame(maxWidth: 400)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: addAnimation)
    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}


struct noItemsView_Previews: PreviewProvider {
    static var previews: some View {
        noItemsView()
    }
}
