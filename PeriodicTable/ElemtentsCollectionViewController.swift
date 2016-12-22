//
//  ElemtentsCollectionViewController.swift
//  PeriodicTable
//
//  Created by Karen Fuentes on 12/21/16.
//  Copyright © 2016 Karen Fuentes. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ElemtentsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
     var fetchedResultsController: NSFetchedResultsController<Element>!
     let groupOffsets = [0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 0]
    
//        let data = [("H", 1), ("He", 2), ("Li", 3)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UINib(nibName:"ElementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
       // self.getData()
        self.initializeFetchedResultController()

    }

    
    func getData() {
        let elementEndpoint =  "https://api.fieldbook.com/v1/5859ad86d53164030048bae2/elements"
        APIRequestManager.manager.getData(endPoint: elementEndpoint) { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with:validData, options: []) {
                    if let arrayOfElements = jsonData as? [[String:Any]] {
                        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.privateContext
                        moc.performAndWait {
                            for elementObj in arrayOfElements {
                                let element = NSEntityDescription.insertNewObject(forEntityName:"Element", into: moc) as! Element
                                element.populate(from: elementObj)
                            }
                            do {
                                try moc.save()
                                moc.parent?.performAndWait {
                                    do {
                                        try moc.parent?.save()
                                    }
                                    catch {
                                        fatalError("Failure to save context: \(error)")
                                    }
                                }
                            }
                            catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    func initializeFetchedResultController() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataController.managedObjectContext
        let request = NSFetchRequest<Element>(entityName: "Element")
        let predicate = NSPredicate(format: "group <=%d", 18)
        request.predicate = predicate
        let numberSort = NSSortDescriptor(key: "number", ascending: true)
        let groupSort = NSSortDescriptor(key: "group", ascending: true)
        request.sortDescriptors = [groupSort, numberSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "group", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            }
        catch {
            fatalError("FAILED TO INITIALIZE FETCHEDRESULTSCONTROLLER \(error)")
        }
    }
    
    func randomColorGenerator() -> UIColor {
        let r = CGFloat(arc4random_uniform(254))
        let g = CGFloat(arc4random_uniform(254))
        let b = CGFloat(arc4random_uniform(254))
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        return sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
//        guard let sections = fetchedResultsController.sections else {
//            fatalError("NO SECTIONS IN FETCHEDRESULTSCONTROLLER")
//        }
//        let sectionInfo = sections[section]
//        
//        return sectionInfo.numberOfObjects
    }
    
    
    
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElementCollectionViewCell
        
        cell.elementView.elementNumbLabel.text = ""
        cell.elementView.elementSymbLabel.text = ""
        cell.elementView.backgroundColor = .white
    
        if indexPath.item >= groupOffsets[indexPath.section] {
            var modifiedIP = indexPath
            modifiedIP.item = indexPath.item - groupOffsets[indexPath.section]
            
            let element = fetchedResultsController.object(at: modifiedIP)
            cell.elementView.elementNumbLabel.text = String(element.number)
            cell.elementView.elementSymbLabel.text = element.symbol
           
            switch element.number {
            case 1,6...8,15,16,34:
                cell.elementView.backgroundColor = UIColor(red: 0/255, green: 163/255, blue: 239/255, alpha: 1.0)
            case 3,11,19,37,55,87:
                cell.elementView.backgroundColor = UIColor(red: 0, green: 0.2196, blue: 0.8784, alpha: 1.0)
            case 4,12,20,38,56,88:
                cell.elementView.backgroundColor = UIColor(red: 0.7137, green: 0.1098, blue: 0.8078, alpha: 1.0)
            case 21...30,39...48,57,72...80, 89,104...112:
                cell.elementView.backgroundColor = UIColor(red: 0.9686, green: 0.1333, blue: 0.8431, alpha: 1.0)
            case 5,14,32,33,51,52,84:
                cell.elementView.backgroundColor = UIColor(red: 0.9882, green: 0.902, blue: 0.1373, alpha: 1.0)
            case 113...118:
                cell.elementView.backgroundColor = UIColor(red: 0.2196, green: 0.4353, blue: 0.4863, alpha: 1.0)
            case 9,17,35,53,85:
                cell.elementView.backgroundColor = UIColor(red: 0.102, green: 0.8275, blue: 0.0902, alpha: 1.0)
            case 13,31,49,50,81...83:
                cell.elementView.backgroundColor = UIColor(red: 0.8667, green: 0.3922, blue: 0.0941, alpha: 1.0)
            case 2,10,18,36,54,86:
                cell.elementView.backgroundColor = UIColor(red: 0.0627, green: 0.3137, blue: 0.4471, alpha: 1.0)
            default :
                cell.elementView.backgroundColor = .gray
            }
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
