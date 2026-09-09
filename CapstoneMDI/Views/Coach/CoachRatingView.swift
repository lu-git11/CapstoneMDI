//
//  CoachRatingView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 9/1/26.
//

import SwiftUI
import SwiftData

struct InteractiveStarPicker: View {
    @Binding var rating: Int
    var starSize: CGFloat = 34
    private let successColor = Color(red: 0.35, green: 1.0, blue: 0.55)
    private let unselectedColor = Color(red: 0.35, green: 0.8, blue: 0.95)

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { number in
                Image(systemName: "figure.strengthtraining.traditional")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starSize, height: starSize)
                    .foregroundStyle(number <= rating ? successColor : unselectedColor)
                    .opacity(number <= rating ? 1.0 : 0.6)
                    .scaleEffect(number <= rating ? 1.05 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.7), value: rating)
                    .onTapGesture { rating = number }
            }
        }
    }
}

struct CoachRatingView: View {
    let coach: Coach

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var rating: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Background.gradient2.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Image(systemName: coach.imageSystemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.white)
                                .padding(20)
                                .background(Color.gray, in: Circle())
                                

                            Text(coach.name)
                                .font(.title2.bold())

                            Text(coach.specialty)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 12)

                        Text(coach.bio)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            Text("Your Rating").font(.headline)
                            InteractiveStarPicker(rating: $rating)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        coach.savedRating = rating
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(rating == 0)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                rating = coach.savedRating ?? 0
            }
        }
    }
}

#Preview {
    CoachRatingView(coach: Coach.sampleCoaches[0])
        .modelContainer(for: [Coach.self], inMemory: true)
}
