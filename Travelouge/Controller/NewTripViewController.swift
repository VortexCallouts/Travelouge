
import UIKit

class NewTripViewController: UIViewController {
    
    var newTrip: Trip?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveTrip(_ sender: Any) {
        guard let title = titleTextField?.text else {
            return
        }
        
        var trip: Trip?
        
        if let existingTrip = newTrip {
            trip = existingTrip
            trip?.title = title
        } else {
            trip = Trip(title: title)
            
        }
        if let trip = trip {
            do {
                let managedObjectContext = trip.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                print("Was not able to save trip")
                return
            }
        }
         _ = navigationController?.popViewController(animated: true)
    }
}

extension NewTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
