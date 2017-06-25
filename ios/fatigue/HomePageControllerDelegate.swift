import Foundation

protocol HomePageControllerDelegate: class {
    func presentQuestionnaire()
    func presentSettings()
    func moveToHomePage()
    func moveToHistoryPage()
}
