//
//  WorkoutDetailView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @Binding var workout: Workout
    
    @State private var showEdit: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                heroSection
                infoSection
                    .padding(.horizontal, 70)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                reviewSection
//                    .padding(.horizontal, 60)
//                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Background.gradient2)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit"){ showEdit.toggle() }
            }
        }
        .sheet(isPresented: $showEdit){
            AddEditView(workout: $workout)
        }
    }
    private var heroSection: some View {
        Image(workout.image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, Color(red: 0x11/255.0, green: 0x11/255.0, blue: 0x11/255.0)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            )
    }
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                VStack{
                    Text(workout.title.capitalized)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    
                    Label(workout.coach, systemImage: "person.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.08), in: Capsule())
                }
                Spacer()
                //StarView(rating: workout.rating ?? 0)
            }
            Text(workout.summary)
                .font(.body)
                .lineSpacing(6)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
                .padding(.top, 8)
                
        }
    }
                
//    private var reviewSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Reviews")
//                .font(.title2.bold())
//                .foregroundStyle(.primary)
//
//            if workout.reviewText.isEmpty {
//                Text("No review yet")
//                    .foregroundStyle(.yellow)
//                    .font(.body)
//            } else {
//                HStack {
//                    Text(workout.reviewTitle)
//                        .font(.subheadline.bold())
//                        .foregroundStyle(.primary)
//                    Spacer()
//                    if let rating = workout.rating, rating > 0 {
//                        Label("\(rating)", systemImage: "figure.strengthtraining.traditional")
//                            .font(.subheadline)
//                            .foregroundStyle(.yellow)
//                    }
//                }
//                Text(workout.reviewText)
//                    .font(.body)
//                    .foregroundStyle(.secondary)
//            }
//        }
//        .padding()
//        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
//    } //end view
}//end struct


#Preview("Sample"){
    @State var sample = Workout(
        title: "sample",
        coach: "sample",
        summary: "sample",
        image: "push"
    )
    WorkoutDetailView(workout: $sample)
}
