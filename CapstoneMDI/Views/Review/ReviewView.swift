//
//  ReviewView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/14/26.
//

import SwiftUI

struct ReviewView: View {
    let user: User
    
    @State private var showEdit: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack{
            Background.gradient2.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if user.reviews.isEmpty {
                        Text("No review yet")
                            .foregroundStyle(.orange)
                            .font(.body)
                    } else {
                        ForEach(user.reviews) { review in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(review.reviewTitle.isEmpty ? "Add a review" : review.reviewTitle)
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if let rating = review.rating, rating > 0 {
                                        StarView(rating: rating)
                                            .frame(height: 20)
                                    }
                                }
                                
                                Text(review.reviewText)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.08))
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("Reviews")
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showEdit.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showEdit){
            NewReviewView(user: user)
        }
    }
}

#Preview {
    let sampleReviews: [Review] = [
        Review(id: UUID(), reviewTitle: "Great routine", reviewText: "Really enjoyed the structure and pacing.", rating: 5),
        Review(id: UUID(), reviewTitle: "Solid", reviewText: "Good variety of exercises.", rating: 4)
    ]

    // Construct a User with String types for username and password
    let sampleUser = User(
        username: "preview_user_\(UUID().uuidString)",
        name: "Preview User",
        password: "password"
    )
    ReviewView(user: sampleUser)
}
