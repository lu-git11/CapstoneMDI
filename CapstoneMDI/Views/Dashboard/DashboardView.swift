//
//  DashboardView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    
    let user: User
    
    @State private var taskGroups : [DashboardGroup] = []  //= TaskGroup.sampleData
    @State private var selectedGroup: DashboardGroup?
    @State private var isShowingAddGroup = false
       
    @Environment(\.dismiss) private var dismiss
       
       var body: some View {
           NavigationStack{
               ZStack {
                   Background.gradient3.ignoresSafeArea()
                   List {
                       NavigationLink(destination: RoutineView(user: user)) {
                           dashboardRow(
                               icon: "figure.cross.training",
                               title: "Workout Description",
                               subtitle: "Review target split specifications"
                           )
                       }
                       .buttonStyle(.plain)
                       .listRowBackground(Color.clear)
                       .listRowSeparator(.hidden)
                       .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                       
                       NavigationLink(destination: ReviewView(user: user)) {
                           dashboardRow(
                               icon: "star.bubble.fill",
                               title: "Reviews",
                               subtitle: nil
                           )
                       }
                       .buttonStyle(.plain)
                       .listRowBackground(Color.clear)
                       .listRowSeparator(.hidden)
                       .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                       
                        NavigationLink(destination: ExerciseLogView(user: user)) {
                            dashboardRow(
                                   icon: "chart.bar.fill",
                                   title: "Exercise Log",
                                   subtitle: "Track your daily performance history metrics"
                            )
                        }
                       .buttonStyle(.plain)
                       .listRowBackground(Color.clear)
                       .listRowSeparator(.hidden)
                       .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                   
                       NavigationLink(destination: ExerciseView(user: user)) {
                           dashboardRow(
                            icon: "dumbbell.fill",
                            title: "Exercises",
                            subtitle: "Track your daily performance history metrics"
                            
                           )
                       }// end HStack
                       .buttonStyle(.plain)
                       .listRowBackground(Color.clear)
                       .listRowSeparator(.hidden)
                       .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        } //end list
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }//end ZStack
                    .navigationDestination(for: DashboardGroup.self) { group in Text(group.title)
                       }
                       .toolbar {
                           ToolbarItem(placement: .principal){
                               Text("Dashboard")
                                   .font(.system(size: 20, weight: .bold))
                                   .lineLimit(1)
                                   .minimumScaleFactor(0.8)
                           }
                           ToolbarItem(placement: .topBarTrailing) {
                               Button {
                                   isShowingAddGroup = true
                           } label: {
                               Image(systemName: "plus")
                           }
                       }
                   }// end toolbar
                   .sheet(isPresented: $isShowingAddGroup) {
                       NewDashboardView { newGroup in
                           withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                           taskGroups.append(newGroup)
                       }
                       selectedGroup = newGroup
                       }
                   }// end sheet
               }// end navigation
           }// end view
    @ViewBuilder
        private func dashboardRow(icon: String, title: String, subtitle: String?) -> some View {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.gradient, in: RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer() // Forces the content to push left and the HStack to expand full width
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
   }// end struct


#Preview("Dashboard") {
    DashboardView(user: User(username: "test", name: "test user", password: User.hashPassword("password")))
}
