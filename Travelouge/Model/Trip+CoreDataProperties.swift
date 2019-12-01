

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var title: String?
    @NSManaged public var rawEntries: NSOrderedSet?

}

// MARK: Generated accessors for rawEntries
extension Trip {

    @objc(addRawEntriesObject:)
    @NSManaged public func addToRawEntries(_ value: Entry)

    @objc(removeRawEntriesObject:)
    @NSManaged public func removeFromRawEntries(_ value: Entry)

    @objc(addRawEntries:)
    @NSManaged public func addToRawEntries(_ values: NSSet)

    @objc(removeRawEntries:)
    @NSManaged public func removeFromRawEntries(_ values: NSSet)

}
