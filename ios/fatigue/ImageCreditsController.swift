import UIKit
import SafariServices

class ImageCreditsController: UIViewController, ImageCreditsDelegate {
    lazy var imageCreditsView: UIView = {
        let view = ImageCreditsView(frame: self.view.frame)
        view.backgroundColor = .light
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Acknowledgements"
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(imageCreditsView)
        imageCreditsView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
    func openUrl(_ url: URL) {
        present(SFSafariViewController(url: url), animated: true)
    }
}
