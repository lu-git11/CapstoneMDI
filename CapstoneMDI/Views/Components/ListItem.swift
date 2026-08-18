//
//  ListItem.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct ListItems: View {
    var workout: Workout
    
    var body: some View {
        HStack(spacing: 20){
            Image(workout.image)
                .resizable()
                .cornerRadius(10)
                .frame(width: 70, height: 80)
                .padding(4)
                .padding(.trailing, 16)
                
            VStack(alignment: .leading, spacing: 2){
                Text(workout.title)
                    .font(.title.bold())
                    .foregroundStyle(Color(.label))
                Text("by: \(workout.coach)")
                    .font(.title2)
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
        .padding(.vertical, -6)
    }
}
