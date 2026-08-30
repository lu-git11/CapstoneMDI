//
//  RoutineDetailView.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/11/26.
//

import SwiftUI
import SwiftData

struct RoutineDetailView: View {
    
    let routine: Routine
    let user: User
    
    @State private var showEdit: Bool = false
    //@State private var showExercisePicker: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                heroSection
                infoSection
                    .padding(.horizontal, 70)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Background.gradient2)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit"){ showEdit.toggle() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Label("Finish", systemImage: "checkmark")
                }
            }
        }
        .sheet(isPresented: $showEdit){
            AddEditView(routine: routine, user: user)
        }
    }
    private var heroSection: some View {
        Image(routine.image)
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
                    Text(routine.title.capitalized)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    
                    Label(routine.coach, systemImage: "person.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.08), in: Capsule())
                }
                Spacer()
                StarView(rating: routine.rating ?? 0)
            }
            Text(routine.summary)
                .font(.body)
                .lineSpacing(6)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
                .padding(.top, 8)
                
        }
    }
  }//end struct


#Preview("Sample") {
    let sample = Routine(
        title: "sample",
        coach: "sample",
        summary: "sample",
        image: "push"
    )
    RoutineDetailView(
        routine: sample,
        user: User(username: "test", name: "Test User", password: User.hashPassword("password"))
    )
}

