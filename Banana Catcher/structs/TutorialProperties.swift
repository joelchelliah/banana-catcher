struct TutorialStages {
    static let movement: Int = 1
    static let banana: Int = 2
    static let coconut: Int = 3
    
    static func lastStage(stage: Int) -> Bool {
        return stage == coconut
    }
}
