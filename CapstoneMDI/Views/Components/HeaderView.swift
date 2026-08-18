//
//  HeaderView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/6/26.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack {
            
            Image(systemName: icon)
                .font(.system(size: 32, weight: .semibold))
                .frame(width: 60, height: 60)
         
            Text(title)
                .font(.system(size: 37, weight: .bold, design: .rounded))
            
            Text(subtitle)
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(Color(.secondaryLabel))
        }
    }
}

#Preview {
    HeaderView(title: "test", subtitle: "Test", icon:"wallet.bifold.fill")
}
