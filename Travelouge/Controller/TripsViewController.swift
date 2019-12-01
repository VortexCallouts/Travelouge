

import UIKit
import CoreData

class TripsViewController: UIViewController {

    @IBOutlet weak var tripsTableView: UITableView!
    
    var trips: [Trip] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = "Trips"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntriesViewController, let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row else {
            return
        }
        
        destination.trip = trips[selectedRow]
    }
    
    func deleteTrip(at indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        guard let managedContext = trip.managedObjectContext else {
            return
        }
        
        managedContext.delete(trip)
        
        do {
            try managedContext.save()
            
            trips.remove(at: indexPath.row)
            tripsTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Could not delete this trip from Core Data.")
            
            tripsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try managedContext.fetch(fetchRequest)
            tripsTableView.reloadData()
        } catch {
            print("Could not fetch")
        }
        
        trips.removeAll()
        trips = fetchedTrips
        tripsTableView.reloadData()
    }
    
}

extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips[indexPath.row]
        
        cell.textLabel?.text = trip.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTrip(at: indexPath)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
