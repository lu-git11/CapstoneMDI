//
//  AddEditView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct AddEditView: View {
    
    @Binding var workout: Workout
    
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = ""
    @State var coach: String = ""
    @State var summary: String = ""
    @State var rating: Int = 0
    @State var reviewTitle: String = ""
    @State var reviewText: String = ""
    @State var image: String = "push"
    @State private var newReview: Bool = false
    
    init(workout: Binding<Workout>){
        self._workout = workout
        self._title = .init(wrappedValue:workout.wrappedValue.title)
        self._coach = .init(wrappedValue:workout.wrappedValue.coach)
        self._summary = .init(wrappedValue:workout.wrappedValue.summary)
        self._rating = .init(wrappedValue:workout.wrappedValue.rating != nil ? workout.wrappedValue.rating! : 0)
        self._reviewTitle = .init(wrappedValue:workout.wrappedValue.reviewTitle)
        self._reviewText = .init(wrappedValue:workout.wrappedValue.reviewText)
        self._image = .init(wrappedValue:workout.wrappedValue.image)
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
                Section(header: Text("Review")){
                    Picker("Rating", selection: $rating){
                        Text("No Rating Selected").tag(0)
                        ForEach(1...5, id: \.self){ num in
                            Text(String(num)).tag(num)
                        }//end foreach
                    }//end picker
                    ZStack{
                        TextEditor(text:$reviewTitle)
                        
                        if reviewTitle.isEmpty{
                            Text("Review Title")
                                .foregroundStyle(.secondary)
                        }
                    }//end Zstack
                    ZStack{
                        TextEditor(text:$reviewText)
                            .frame(height: 100)
                        if reviewText.isEmpty{
                            Text("Write Review Here")
                                .foregroundStyle(.secondary)
                        }
                    }//end ZStack
                    .navigationTitle(workout.title.isEmpty ? "Add Book" : "Edit Book")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar{
                        ToolbarItem(placement: .confirmationAction){
                            Button("Save"){
                                workout.title = title
                                workout.coach = coach
                                workout.summary = summary
                                workout.rating = rating
                                workout.reviewTitle = reviewTitle
                                workout.reviewText = reviewText
                                workout.image = image
                                dismiss()
                            }.disabled(title.isEmpty)
                        }
                    }
                }
            }//end form
        }//end nav stack
    }//end view
}//end struct
