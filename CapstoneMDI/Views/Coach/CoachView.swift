//
//  CoachView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/14/26.
//

import SwiftUI

struct CoachView: View {
    @State private var selectedCoach: Coach? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        ZStack{
            Background.gradient3.ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(Coach.sampleCoaches.enumerated()), id:        \.element.id) { index, coach in
                        Button {
                            selectedCoach = coach
                        } label: {
                            CoachTile(coach: coach, accent: CoachTile.palette[index % CoachTile.palette.count])
                            }
                            .buttonStyle(.plain)
                        }
                   }
                   .padding(20)
               }
           }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("Coaches")
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
            }
        }
        .sheet(item: $selectedCoach) {coach in
            CoachRatingView(coach: coach)
        }
    }
}

private struct CoachTile: View {
    let coach: Coach
    let accent: [Color]

    static let palette: [[Color]] = [
        [Color(hex: "#40576D"), Color(hex: "#7890A7")],
        [Color(hex: "#716B83"), Color(hex: "#2F7E9A")],
        [Color(hex: "#3B8D99"), Color(hex: "#40576D")],
        [Color(hex: "#2F7E9A"), Color(hex: "#716B83")]
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: accent, startPoint: .topLeading, endPoint: .bottomTrailing)

                Image(systemName: coach.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.opacity(0.18))
                    .frame(width: geo.size.width * 0.85, height: geo.size.width * 0.85)
                    .offset(x: geo.size.width * 0.18, y: geo.size.width * 0.1)

                VStack {
                    HStack {
                        Spacer()
                        if let saved = CoachRatingStorage.rating(for: coach) {
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                Text("\(saved)")
                                    .font(.caption2.bold())
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.black.opacity(0.35), in: Capsule())
                            .padding(8)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text(coach.name)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Text(coach.specialty)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(.black.opacity(0.28))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    NavigationStack {
        CoachView()
    }
}
