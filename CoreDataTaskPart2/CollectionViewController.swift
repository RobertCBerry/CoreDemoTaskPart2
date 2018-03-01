//
//  CollectionViewController.swift
//  CoreDataTaskPart2
//
//  Created by Robert Berry on 2/27/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit
import CoreData

private let cellIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var fetchedResultsController: NSFetchedResultsController<Students>?
    
    let favoritesEntity = "Students"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    } 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(fetchedResultsController?.sections?.count as Any)
        return (fetchedResultsController?.sections?.count)! 
    }
 
    // Retrieve the relevant section from the fectched results controller and return its numberOfObjects property.

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        guard let sectionInfo = fetchedResultsController?.sections?[section] else {
           
            fatalError("Failed to load fetched results controller")
        
        }
        
        print(sectionInfo.numberOfObjects)
        return sectionInfo.numberOfObjects
    
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Retrieve student object from fetchedResultsController by calling its object(at:) method and passing the current index path.
        
        guard let fetchedResultsController = fetchedResultsController else {
            
            fatalError("Failed to load fetched results controller.")
        }
        
        let student = fetchedResultsController.object(at: indexPath)
        
        // Configure the cell
        
        // Retrieve reference to the cell.
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.nameLabel.text = ("Name: \(String(describing: student.name!))")
        cell.subjectLabel.text = ("Subject: \(String(describing: student.subject!))")
        cell.hobbyLabel.text = ("Hobby: \(String(describing: student.hobby!))")
        cell.foodLabel.text = ("Food: \(String(describing: student.food!))")
        
        cell.backgroundColor = UIColor.yellow 
        
        return cell
    }
    
    // Sets size of collection view cell to cover entire width and half of the height of the screen. 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
    }

    // Call viewWillAppear() before adding the view controller's view to a view hierarchy. This command will fetch data from the persistent store and to populate the students array.
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // The NSFetchRequest fetches all the Students objects and sorts them in ascending order according to their name.
        
        let fetchRequest = NSFetchRequest<Students>(entityName: "Students")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Creates NSFetchedResultsController object and passes the NSFetchRequest to it.
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        
        do {
            
            try fetchedResultsController?.performFetch()
            
            
        } catch {
            
            fatalError("Unable to fetch: \(error)")
        }
    }
}

extension CollectionViewController: NSFetchedResultsControllerDelegate {
    
    // controllerWillChangeContent notifies us that changes are about to start happening. tableView.beginUpdates() is called to prepare the table view to receive updates.
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    // Method receives notifications about updates that happen to the data.
    
    func controller(_ control: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            
            guard let newIndexPath = newIndexPath else {
                
                fatalError("New index path is nil.")
            }
            
            collectionView?.insertItems(at: [newIndexPath])
            
        case .delete:
            
            guard let indexPath = indexPath else {
                
                fatalError("Index path is nil.")
            }
            
            collectionView?.deleteItems(at: [indexPath])
            
            
        case .move:
            
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else {
                
                fatalError("Index path or new index path is nil?")
            }
            
            collectionView?.deleteItems(at: [indexPath])
            
            collectionView?.insertItems(at: [newIndexPath])
            
        case .update:
            
            guard let indexPath = indexPath else {
                
                fatalError("Index path is nil.")
            }
            
            collectionView?.reloadItems(at: [indexPath])
            
        }
    }
    
    // Method notifies us that changes have finished. collectionView?.endEditing() is called to instruct the collection view to update its UI.
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView?.endEditing(true)
    }
}
