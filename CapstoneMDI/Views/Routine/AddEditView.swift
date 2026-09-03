//
//  AddEditView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI
import SwiftData

struct AddEditView: View {
    
    let routine: Routine
    let user: User
        
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var title: String = ""
    @State var coach: String = ""
    @State var summary: String = ""
    @State var rating: Int = 0
    @State var image: String = "push"
    @State private var newReview: Bool = false
    
    private func resetForm() {
        title = ""
        coach = ""
        summary = ""
        rating = 0
        image = "push"
    }
    
    init(routine: Routine, user: User){
            self.routine = routine
            self.user = user
            self._title = .init(wrappedValue: routine.title)
            self._coach = .init(wrappedValue: routine.coach)
            self._summary = .init(wrappedValue: routine.summary)
            self._rating = .init(wrappedValue: routine.rating ?? 0)
            self._image = .init(wrappedValue: routine.image)
        }
        
        var body: some View {
            NavigationStack{
                Form{
                    Section(header: Text("Workout Details")){
                        TextField("Title", text: $title)
                        TextField("Coach", text: $coach)
                        TextEditor(text: $summary)
                            .frame(height: 100)
                        Picker("Image", selection: $image){
                            Text("Push").tag("push")
                            Text("Pull").tag("pull")
                            Text("Legs").tag("legs")
                        }//end picker
                    }//end section
                    Section(header: Text("Rating")){
                        Picker("Rate your workout", selection: $rating){
                            Text("No Rating Selected").tag(0)
                            ForEach(1...5, id: \.self){ num in
                                Text(String(num)).tag(num)
                            }//end foreach
                        }//end picker
                    }
                }//end form
                .navigationTitle(routine.title.isEmpty ? "Add Workout" : "Edit Workout")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .confirmationAction){
                        Button("Save"){
                            let isAdding = self.routine.title.isEmpty
                            routine.title = title
                            routine.coach = coach
                            routine.summary = summary
                            routine.image = image
                            routine.rating = rating > 0 ? rating : nil
                            routine.user = user
                            routine.userID = user.id
                            modelContext.insert(routine) // no-op if already tracked
                            try? modelContext.save()
                            if isAdding { resetForm() }
                            dismiss()
                        }
                        .disabled(title.isEmpty)
                    }
                }
            }//end nav stack
            .onDisappear {
                if routine.title.isEmpty { // Add mode
                    resetForm()
                }
            }
        }//end view
    }//end struct

    #Preview {
        AddEditView(
            routine: Routine(title: "Sample", coach: "Coach", summary: "Summary", image: "push"),
            user: User(username: "test", name: "Test User", password: User.hashPassword("password"))
        )
    }
