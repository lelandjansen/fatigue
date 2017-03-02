import Foundation

protocol Question {
    var question: String { get }
    var details: String { get }
    var options: [String] { get }
    var selection: String { get set }
}
