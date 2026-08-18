//
//  ReviewView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/14/26.
//

import SwiftUI

struct ReviewView: View {
    @Binding var workout: Workout

    var body: some View {
        ZStack{
            Background.gradient2.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Reviews")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                if workout.reviewText.isEmpty {
                    Text("No review yet")
                        .foregroundStyle(.yellow)
                        .font(.body)
                } else {
                    HStack {
                        Text(workout.reviewTitle)
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        Spacer()
                        if let rating = workout.rating, rating > 0 {
                            Label("\(rating)", systemImage: "figure.strengthtraining.traditional")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                    }
                    Text(workout.reviewText)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding()
        }
        
    }
}

#Preview {
    ReviewView(workout: .constant(Workout(
        title: "Full Body Strength",
        coach: "Alex Trainer",
        summary: "A balanced routine targeting all major muscle groups.",
        image: "workout_placeholder",
        reviewTitle: "Great Workout",
        reviewText: "Felt strong throughout. Good pacing and form cues.",
        rating: 4
    )))
}
