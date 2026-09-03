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

    @State private var taskGroups: [DashboardGroup] = []
    @State private var selectedGroup: DashboardGroup?
    @State private var isShowingAddGroup = false
    @State private var showBanner: Bool = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Background.gradient2.ignoresSafeArea()

                VStack(spacing: 5) {
                    if showBanner {
                        HStack(spacing: 12) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                            
                            Text("Don't forget to work out today!")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Button {
                                withAnimation { showBanner = false }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(12)
                        .background(Color.red.opacity(0.6), in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Use a simple VStack of rows instead of a nested List inside List
                    ScrollView {
                        VStack(spacing: 10) {
                            NavigationLink(destination: RoutineView(user: user)) {
                                dashboardRow(
                                    icon: "figure.cross.training",
                                    title: "Workout Description",
                                    subtitle: "Review target split specifications"
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink(destination: CoachView()) {
                                dashboardRow(
                                    icon: "star.bubble.fill",
                                    title: "Coach Review",
                                    subtitle: "Rate your coach"
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink(destination: ExerciseLogView(user: user)) {
                                dashboardRow(
                                    icon: "chart.bar.fill",
                                    title: "Exercise Log",
                                    subtitle: "Track your performance history"
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink(destination: ExerciseView(user: user)) {
                                dashboardRow(
                                    icon: "dumbbell.fill",
                                    title: "Exercises",
                                    subtitle: "Select exercises for your routine"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(16)
                    }
                }
            }
            .onAppear {
                // Fix incorrect assignment syntax
                showBanner = Reminder.shouldShowBanner()
            }
            .navigationDestination(for: DashboardGroup.self) { group in
                Text(group.title)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
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
            }
            .sheet(isPresented: $isShowingAddGroup) {
                NewDashboardView { newGroup in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        taskGroups.append(newGroup)
                    }
                    selectedGroup = newGroup
                }
            }
        }
    }

    // Move helper into non-local scope and keep it private
    @ViewBuilder
    private func dashboardRow(icon: String, title: String, subtitle: String?) -> some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.orange.gradient, in: RoundedRectangle(cornerRadius: 10))

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

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            ZStack {
                Color.blue.opacity(0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    )
            }
        )
    }
}

private extension DashboardView {
    static var previewUser: User {
        User(username: "test", name: "test user", password: User.hashPassword("password"))
    }
}

#Preview("Dashboard") {
    DashboardView(user: DashboardView.previewUser)
}
