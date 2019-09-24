//
//  ReceiptTableViewController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit
import CoreData

class ReceiptTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as? ReceiptTableViewCell else
            { return UITableViewCell() }

        let receipt = fetchedResultsController.object(at: indexPath)
        cell.entry = entry
        // Configure the cell...

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let entry = fetchedResultsController.object(at: indexPath)
            entryController.delete(entry: entry)
        }    
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
      
      func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          tableView.beginUpdates()
      }
      
      func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
          tableView.endUpdates()
      }
      
      func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                      didChange sectionInfo: NSFetchedResultsSectionInfo,
                      atSectionIndex sectionIndex: Int,
                      for type: NSFetchedResultsChangeType) {
          switch type {
          case .insert:
              tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
          case .delete:
              tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
          default:
              break
          }
      }
      
      func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                      didChange anObject: Any,
                      at indexPath: IndexPath?,
                      for type: NSFetchedResultsChangeType,
                      newIndexPath: IndexPath?) {
          switch type {
          case .insert:
              guard let newIndexPath = newIndexPath else { return }
              tableView.insertRows(at: [newIndexPath], with: .automatic)
          case .update:
              guard let indexPath = indexPath else { return }
              tableView.reloadRows(at: [indexPath], with: .automatic)
          case .move:
              guard let oldIndexPath = indexPath,
                  let newIndexPath = newIndexPath else { return }
              tableView.deleteRows(at: [oldIndexPath], with: .automatic)
              tableView.insertRows(at: [newIndexPath], with: .automatic)
          case .delete:
              guard let indexPath = indexPath else { return }
              tableView.deleteRows(at: [indexPath], with: .automatic)
          @unknown default:
              return
          }
      }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "CreateReceipt":
            guard let destinationVC = segue.destination as? AddViewController else { return }
            
            destinationVC.receiptController = receiptController
            
        case "ViewReceipt":
            guard let destinationVC = segue.destination as?
        default:
            <#code#>
        }
}
      
