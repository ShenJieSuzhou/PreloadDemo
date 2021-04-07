
import UIKit

class ModeratorsSearchViewController: UIViewController {
  private enum SegueIdentifiers {
    static let list = "ListViewController"
  }
  
  @IBOutlet var siteTextField: UITextField!
  @IBOutlet var searchButton: UIButton!
  
  private var behavior: ButtonEnablingBehavior!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = NSLocalizedString("Search", comment: "")
    
    behavior = ButtonEnablingBehavior(textFields: [siteTextField]) { [unowned self] enable in
      if enable {
        self.searchButton.isEnabled = true
        self.searchButton.alpha = 1
      } else {
        self.searchButton.isEnabled = false
        self.searchButton.alpha = 0.7
      }
    }
    
    siteTextField.setBottomBorder()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIdentifiers.list {
      if let listViewController = segue.destination as? ModeratorsListViewController {
        listViewController.site = siteTextField.text!
      }
    }
  }
}
