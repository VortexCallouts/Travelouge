

import Foundation
import CoreData


extension Entry {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    
    @NSManaged public var desc: String?
    @NSManaged public var rawImage: NSData?
    @NSManaged public var name: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var trip: Trip?
    
}
