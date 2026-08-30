//
//  NewReviewView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/22/26.
//

import SwiftUI

struct NewReviewView: View {
    
    let user: User
    
    @Environment(\.dismiss) var dismiss

    @State var rating: Int = 0
    @State var reviewTitle: String = ""
    @State var reviewText: String = ""
    
    init(user: User){
        self.user = user
    }
    
    var body: some View {
        NavigationStack{
            Form{
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
                }
            }//end form
            .navigationTitle("New Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let newReview = Review(
                            reviewTitle: reviewTitle,
                            reviewText: reviewText,
                            rating: rating > 0 ? rating : nil
                        )
                        user.reviews.append(newReview)
                        dismiss()
                    }.disabled(reviewTitle.isEmpty)
                }
            }
        }//end nav stack
    }//end view
}//end struct
