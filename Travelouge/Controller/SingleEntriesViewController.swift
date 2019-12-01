

import UIKit
import CoreData

class SingleEntriesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    var trip: Trip?
    var entry: Entry?
    var image: UIImage?
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        if let entry = entry {
            let name = entry.name
            titleText.text = name
            descriptionText.text = entry.desc
            title = name
            imageView.image = entry.image
            datePicker.date = entry.rawDate! as Date
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.resignFirstResponder()
        descriptionText.resignFirstResponder()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let name = titleText.text else {
            alertNotifyUser(message: "Document not saved. The name was not given")
            return
        }
        
        let desc = descriptionText.text
        
        if entry == nil {
            if let trip = trip {
                entry = Entry(name: name, desc: desc, rawDate: datePicker.date, image: image, trip: trip)
            }
        } else {
            if let trip = trip {
                entry?.update(name: name, desc: desc, rawDate: datePicker.date, image: image, trip: trip)
            }
        }

        if let entry = entry {
            do {
                let managedObjectContext = entry.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                alertNotifyUser(message: "This entry could not be saved")
            }
        } else {
            alertNotifyUser(message: "The entry could not be saved")
        }
        
       navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        selectImageSource()
    }
    
    
    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "This device has no camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        imageView.image = image
        if let entry = entry {
            entry.image = selectedImage
        }
    }
}

extension SingleEntriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
