import UIKit

class HomePageController: UIViewController, HomePageControllerDelegate {
    
    lazy var landingPage: UIView = {
        let view = HomePage(frame: self.view.frame)
        view.backgroundColor = .light
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(landingPage)
        
        landingPage.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
    func presentQuestionnaire() {
        let questionnaireController = QuestionnaireController()
        present(questionnaireController, animated: true, completion: nil)
    }
    
    func presentSettings() {
        let settingsController = SettingsController.init(style: .grouped)
        let navigationController = UINavigationController(rootViewController: settingsController)
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func dismissSettings() {
        dismiss(animated: true, completion: nil)
    }

}
