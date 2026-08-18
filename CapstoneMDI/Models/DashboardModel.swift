//
//  DashboardModel.swift
//  CapstoneMDI
//
//  Created by jeffrey lullen on 8/13/26.
//

import Foundation
import Combine

struct DashboardGroup: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var symbolName: String
    var tasks: [DashboardItem]
}

struct DashboardItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

extension DashboardGroup {
    var completedCount: Int { tasks.filter { $0.isCompleted}.count }
    var progress: Double { tasks.isEmpty ? 0 : Double(completedCount)/Double(tasks.count)
    }
    static let sampleData: [DashboardGroup] = [
        DashboardGroup(title: "School",
                  symbolName: "book.fill",
                  tasks: [ DashboardItem(title: "Do Homework"),
                           DashboardItem(title: " Do Exam")]),
        DashboardGroup(title: "Home",
                  symbolName: "house.fill",
                  tasks: [ DashboardItem(title: "Cook Dinner"),
                           DashboardItem(title: "Clean Room", isCompleted: true)])
    ]
}
