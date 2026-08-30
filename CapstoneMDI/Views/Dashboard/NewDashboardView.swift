//
//  NewDashboardView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/13/26.
//

import SwiftUI

struct NewDashboardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupName = ""
    @State private var selectedIcon = "house.fill"
    let icons = ["house.fill", "heart.fill" , "book.fill" , "star.fill"]
    var onSave: (DashboardGroup) -> Void
    
    var body:some View{
        NavigationStack {
            Form {
                Section("Group Name") {
                    TextField("E.g.Work, School ...", text: $groupName)
                }
                
                Section("Select Icon"){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]){
                        ForEach(icons,id: \.self) { icon in
                            Image(systemName: icon)
                                .frame(width: 40, height: 40)
                                .background(selectedIcon == icon ?
                                            Color.blue.opacity(0.2) : Color.clear)
                                .foregroundStyle(selectedIcon == icon ? .blue : .gray)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                }
            }
            .navigationTitle("New Group")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        let newGroup = DashboardGroup(title: groupName, symbolName: selectedIcon, tasks: [])
                        onSave(newGroup)
                        dismiss()
                    }
                    .disabled(groupName.isEmpty)
                }
                
            }//end toolbar
        }//end navigation
        .padding()
    }//end body
}//end struct
