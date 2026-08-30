//
//  WorkoutView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/25/26.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    let user: User
    
    @Environment(\.modelContext) private var modelContext
    @Query private var routines: [Routine]
    
    @State private var showAddRoutine: Bool = false
    @State private var newRoutine: Routine
    
    init(user: User) {
        self.user = user
        let userID = user.id
        _routines = Query(
            filter: #Predicate<Routine> { $0.userID == userID },
            sort: \Routine.title
        )
        _newRoutine = State(initialValue: Routine(title: "", coach: "", summary: "", image: "push", user: user))
    }

    var body: some View {
         ZStack {
             Background.gradient2.ignoresSafeArea()
             
             List {
                 if routines.isEmpty {
                     ContentUnavailableView(
                         "No Workouts",
                         systemImage: "figure.cross.training",
                         description: Text("Tap the plus button above to add your first workout routine.")
                     )
                     .listRowBackground(Color.clear)
                 } else {
                     ForEach(routines) { routine in
                         NavigationLink(destination: RoutineDetailView(routine: routine, user: user)) {
                             HStack(spacing: 16) {
                                 Image(routine.image.isEmpty ? "push" : routine.image)
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: 56, height: 56)
                                     .clipShape(RoundedRectangle(cornerRadius: 12))
                                 
                                 VStack(alignment: .leading, spacing: 4) {
                                     Text(routine.title.capitalized)
                                         .font(.headline)
                                         .foregroundStyle(.primary)
                                     
                                     if !routine.coach.isEmpty {
                                         Text("Coach: \(routine.coach)")
                                             .font(.caption)
                                             .foregroundStyle(.secondary)
                                     }
                                 }
                                 Spacer()
                             }
                             .padding(12)
                             .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                         }
                         .buttonStyle(.plain)
                         .listRowBackground(Color.clear)
                         .listRowSeparator(.hidden)
                         .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                     }
                     .onDelete(perform: deleteRoutines)
                 }
             }
             .listStyle(.plain)
             .scrollContentBackground(.hidden)
         }
         .toolbar {
             ToolbarItem(placement: .principal) {
                 Text("Routines")
                     .font(.system(size: 20, weight: .bold))
                     .lineLimit(1)
                     .minimumScaleFactor(0.8)
             }
             
             ToolbarItem(placement: .primaryAction) {
                 Button {
                     showAddRoutine = true
                 } label: {
                     Image(systemName: "plus")
                 }
             }
         }
         .sheet(isPresented: $showAddRoutine) {
             AddEditView(
                 routine: newRoutine,
                 user: user
             )
         }
     }
         
     private func deleteRoutines(at offsets: IndexSet) {
         for index in offsets {
             let routine = routines[index]
             modelContext.delete(routine)
         }
     }
 }
     
 #Preview {
     NavigationStack {
         RoutineView(user: User(username: "test", name: "Test User", password: User.hashPassword("password")))
     }
 }
