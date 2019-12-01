

import UIKit
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    var date: Date? {
        get {
            return rawDate as Date?
        } set {
            rawDate = newValue as NSDate?
        }
    }
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                rawImage = convertImageToNSData(image: image)
            }
        }
    }
    
    convenience init?(name: String?, desc: String?, rawDate: Date?, image: UIImage?, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext, let name = name, name != "" else {
            return nil
        }
        
        self.init(entity: Entry.entity(), insertInto: managedContext)
        self.name = name
        self.desc = desc
        self.date = Date(timeIntervalSinceNow: 0)
        if let image = image {
            self.rawImage = convertImageToNSData(image: image)
        } else {
            self.rawImage = nil
        }
        self.trip = trip
    }
    
    func update(name: String, desc: String?, rawDate: Date, image: UIImage?, trip: Trip) {
        self.name = name
        self.desc = desc
        self.date = rawDate as Date
        if let image = image {
            self.rawImage = convertImageToNSData(image: image)
        } else {
            self.rawImage = nil
        }
        self.trip = trip 
    }
    
    func convertImageToNSData(image: UIImage) -> NSData? {
        // The image data can be represented as PNG or JPEG data formats.
        // Both ways to format the image data are listed below and the JPEG version is the one being used.
        
        //return image.jpegData(compressionQuality: 1.0) as NSData?
        return processImage(image: image).pngData() as NSData?
    }
    
    func processImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image
        }
        
        return unwrappedCopy
    }
}
