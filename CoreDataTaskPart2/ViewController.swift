//
//  ViewController.swift
//  CoreDataTaskPart2
//
//  Created by Robert Berry on 2/27/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: Properties
    
    // Entity
    
    let studentsEntity = "Students"
    
    // Text Views
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var subjectTextView: UITextView!
    @IBOutlet weak var hobbyTextView: UITextView!
    @IBOutlet weak var foodTextView: UITextView!
    
    var students = [Students]()
    
    @IBAction func saveButtonWasTapped(_ sender: UIBarButtonItem) {
        
        // Create a reference to the AppDelegate.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Retrieve the NSManagedObjectContext from the AppDelegate.
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Retrieve reference to the Favorites managed object.
        
        let entity = NSEntityDescription.entity(forEntityName: studentsEntity, in: context)
        
        let student = Students(entity: entity!, insertInto: context)
        
        // Set values for food, movie, and book attributes.
        
        student.name = nameTextView.text
        student.subject = subjectTextView.text
        student.hobby = hobbyTextView.text
        student.food = foodTextView.text
        
        // Commit the changes to favorite and save to disk by calling saveContext() on the app delegate.
        
        appDelegate.saveContext()
        
        // Insert the managed object into the favorites array.
        
        students.append(student)
        
        print(students)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call viewWillAppear() before adding the view controller's view to a view hierarchy. This command will fetch data from the persistent store and to populate the students array. 
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // A reference to the managedObjectContext.
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Defines the search criteria that will be used to retrieve data from a persistent store.
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: studentsEntity)
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            students = results as! [Students]
            
        } catch let error as NSError {
            
            print("Fetching Error: \(error.userInfo)")
        }
    } 
}

