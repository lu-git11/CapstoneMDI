//
//  WorkoutView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    
    @State private var workouts = getWorkout()
    @State private var showAddWorkout: Bool = false
    @State private var newWorkout = Workout(title:"", coach:"", summary:"", image:"push")
    
    var body: some View {
        NavigationStack{
            List($workouts) { workout in
                NavigationLink(destination: WorkoutDetailView(workout: workout)){
                        ListItems(workout: workout.wrappedValue)
                    }
                .listRowBackground(Color(uiColor: .systemBackground).opacity(0.05))
            }//end List
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Background.gradient3)
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(ColorScheme.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ Add") { showAddWorkout.toggle()}
                        .foregroundColor(Color(red: 91/255.0, green: 156/255.0, blue: 246/255.0))
                }
            }
                .sheet(isPresented: $showAddWorkout){
                    if(!newWorkout.title.isEmpty){
                        workouts.append(newWorkout)
                    }
                    newWorkout = Workout(title:"", coach:"", summary:"", image:"push" )
                }
                content:{
                    AddEditView(workout: $newWorkout)
                }
                HStack(spacing: 80) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 25))
                        .foregroundStyle(.tint)
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 25))
                        .foregroundStyle(.tint)
                    Image(systemName: "person.crop.square.fill")
                        .font(.system(size: 25))
                        .foregroundStyle(.tint)
                }
                .padding(5)
            
        }// end nav stack
    }// end view
}// end struct

#Preview {
    WorkoutView()
}
