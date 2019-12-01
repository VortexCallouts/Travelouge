

import UIKit
import CoreData
import Foundation

class EntriesViewController: UIViewController {
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    
    var trip: Trip?
    var entries = [Entry]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = trip?.title ?? ""
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        updateEntriesArray()
        entriesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntry(at: indexPath)
        }
    }
    
    func deleteEntry(at indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
            try managedObjectContext.save()
            self.entries.remove(at: indexPath.row)
            entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("it didn't work")
                entriesTableView.reloadData()
            }
        }
    }
    
    func updateEntriesArray() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var fetchedEntries: [Entry] = []
        do {
            fetchedEntries = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch")
        }
        
        entries.removeAll()
        entries = fetchedEntries
    }
}

extension EntriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = entriesTableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        if let cell = cell as? EntriesTableViewCell {
            let entry = entries[indexPath.row]
            cell.nameLabel.text = entry.name
            
            if let date = entry.date {
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SingleEntriesViewController,
            let segueIdentifier = segue.identifier {
            destination.trip = trip
            if (segueIdentifier == "viewEntry") {
                if let row = entriesTableView.indexPathForSelectedRow?.row {
                    destination.entry = entries[row]
                }
            }
        }
    }
}

