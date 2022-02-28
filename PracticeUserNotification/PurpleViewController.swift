import UIKit

class PurpleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? YellowViewController else { return }
        
        guard let sender = sender as? (String, String) else { return }
        
        nextVC.setupData(title: sender.0, body: sender.1)
    }
}
