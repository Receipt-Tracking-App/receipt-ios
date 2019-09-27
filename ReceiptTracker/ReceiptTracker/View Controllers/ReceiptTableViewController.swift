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
    
    let receiptController = ReceiptController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.rowHeight = 78;
        tableView.reloadData()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Receipt> = {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryId", ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "categoryId", cacheName: nil)
        
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    func setUI() {
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        
        view.backgroundColor = .background
        tableView.backgroundColor = .background
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        let label = UILabel(frame: CGRect(x: 18, y: 3.5, width: returnedView.frame.width, height: returnedView.frame.height))
        
        returnedView.backgroundColor = .sectionHeader
        
        if let section = Int(fetchedResultsController.sections?[section].name ?? "0") {
            label.text = sections[section]
        } else {
            label.text = ""
        }
        
        label.textColor = .text
        
        returnedView.addSubview(label)
        return returnedView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as? ReceiptTableViewCell else
            { return UITableViewCell() }

        let receipt = fetchedResultsController.object(at: indexPath)
        cell.receipt = receipt

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let receipt = fetchedResultsController.object(at: indexPath)
            receiptController.delete(receipt: receipt)
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
            guard let destinationVC = segue.destination as? AddViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            destinationVC.receiptController = receiptController
            destinationVC.receipt = fetchedResultsController.object(at: indexPath)
        default:
            return
        }
    }
}
      
