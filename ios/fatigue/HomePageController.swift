import UIKit

class HomePageController: UIViewController, HomePageControllerDelegate {
    
    lazy var landingPage: UIView = {
        let view = HomePage()
        view.backgroundColor = UIColor(colorLiteralRed: 142/255, green: 141/255, blue: 142/255, alpha: 1)
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
}
