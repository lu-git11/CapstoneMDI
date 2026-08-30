//
//  ListItem.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI

struct ListItems: View {
    var routine: Routine
    
    var body: some View {
        HStack(spacing: 16){
            Image(routine.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            VStack(alignment: .leading, spacing: 2){
                Text(routine.title)
                    .font(.headline)
                    .foregroundStyle(Color(.label))
                Text("by: \(routine.coach)")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
        .padding(.vertical, 4)
    }
}
