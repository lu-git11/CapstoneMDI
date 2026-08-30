
import Foundation
import SwiftData


@Model
final class ExerciseLog {
    var id: UUID
    var exerciseName: String
    var completedSets: Int
    var currentReps: Int
    var date: Date
    var user: User?
    var userID: UUID
    var exercise: Exercise?
    var exerciseID: UUID
    
    init(exercise: Exercise, user: User?) {
        self.id = UUID()
        self.exerciseName = exercise.name
        self.completedSets = 0
        self.currentReps = 0
        self.date = Date()
        self.user = user
        self.userID = user?.id ?? UUID()
        self.exercise = exercise
        self.exerciseID = exercise.id
    }
}
