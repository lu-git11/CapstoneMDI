//
//  StarView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/18/26.
//

import SwiftUI

struct StarView: View {
    
    let rating: Int
    private let successColor = Color(red: 0.35, green: 1.0, blue: 0.55)

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1...5, id: \.self) { number in
                Image(systemName: number <= self.rating ? "figure.strengthtraining.traditional" : "figure.strengthtraining.traditional.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(successColor)
            }
        }
    }
}

#Preview("StarView Examples") {
    VStack(alignment: .leading, spacing: 12) {
        HStack { StarView(rating: 4) }
    }
    .padding()
}
