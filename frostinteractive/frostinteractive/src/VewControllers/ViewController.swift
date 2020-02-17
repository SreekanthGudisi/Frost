//
//  ViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 04/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    let transitionViewController = TransitionViewController()
    let allDataArray : NSMutableArray = []
    var allTableDataArray = [NotesData]()
    var filteredData = [NotesData]()
    var filteredDateSlectedData = [NotesData]()
    var isSeacrhActive = false
    var searchController : UISearchController!
    
    var selectedDateString = String()
    var checkDate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Transition Delegete
        navigationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchAllDataFromCoredata()
        tableview.separatorStyle = .none
        tableview.estimatedRowHeight = 300
        tableview.rowHeight = UITableView.automaticDimension
    }

    @IBAction func filtterButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
        vc?.filterDateDelegate = self
        vc?.viewController = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNotesViewController") as? AddNotesViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func questionMarkButtonTapped(_ sender: Any) {
        
    }
}

extension ViewController {
    
    // Fetch AllData From PersistenceSerivce
    func fetchAllDataFromCoredata() {
        
        let context = PersistenceSerivce.context
        let fetchRequest = NSFetchRequest<NotesData>(entityName: "NotesData")
        fetchRequest.returnsObjectsAsFaults = true
        allTableDataArray.removeAll()
        filteredDateSlectedData.removeAll()
        if checkDate == true {
            do {
                allTableDataArray = try context.fetch(fetchRequest)
                for filterDate in allTableDataArray {
                    if selectedDateString == filterDate.noteDate! {
                        self.filteredDateSlectedData.append(filterDate)
                    }
                }
            } catch {
                print("Unable to fetch from Coredata", error)
            }
        } else {
            do {
                allTableDataArray = try context.fetch(fetchRequest)
                for filterDate in allTableDataArray {
                    if selectedDateString == filterDate.noteDate! {
                        self.filteredDateSlectedData.append(filterDate)
                    }
                }
            } catch {
                print("Unable to fetch from Coredata", error)
            }
        }
        tableview.reloadData()
    }
}

//MARK:- UITableView
extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if checkDate == true {
            let numberOfRows = ((isSeacrhActive) ? filteredData.count : filteredDateSlectedData.count)
            return numberOfRows
        }else {
            let numberOfRows = ((isSeacrhActive) ? filteredData.count : allTableDataArray.count)
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell
        if checkDate == true {
            let data = (self.isSeacrhActive) ? self.filteredData[indexPath.row] : self.filteredDateSlectedData[indexPath.row]
            cell?.titleLabel.text = data.noteTitle
            cell?.descriptionLabel.text = data.noteDescription
            cell?.dateLabel.text = data.noteDate?.description
            cell?.tagsLabel.text = data.noteTag
            if data.noteTag == "" {
                cell?.tagsImage.isHidden = true
            }
            cell?.urlToImage?.clipsToBounds = true
            cell?.urlToImage?.layer.cornerRadius = 10
            if data.noteImage == nil {
                cell?.imageHeightConstant.constant = 0
                cell?.imageWidthConstant.constant = 0
            } else{
                cell?.imageHeightConstant.constant = 91
                cell?.imageWidthConstant.constant = 91
                cell?.urlToImage?.image = UIImage(data: data.noteImage!)
            }
            return cell!
        } else{
            let data = (self.isSeacrhActive) ? self.filteredData[indexPath.row] : self.allTableDataArray[indexPath.row]
            cell?.titleLabel.text = data.noteTitle
            cell?.descriptionLabel.text = data.noteDescription
            cell?.dateLabel.text = data.noteDate?.description
            cell?.tagsLabel.text = data.noteTag
            if data.noteTag == "" {
                cell?.tagsImage.isHidden = true
            }
            cell?.urlToImage?.clipsToBounds = true
            cell?.urlToImage?.layer.cornerRadius = 10
            if data.noteImage == nil {
                cell?.imageHeightConstant.constant = 0
                cell?.imageWidthConstant.constant = 0
            } else{
                cell?.imageHeightConstant.constant = 91
                cell?.imageWidthConstant.constant = 91
                cell?.urlToImage?.image = UIImage(data: data.noteImage!)
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkDate == true {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            vc!.notesData = self.isSeacrhActive ? self.filteredData[indexPath.row] : self.filteredDateSlectedData[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        } else {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
            vc!.notesData = self.isSeacrhActive ? self.filteredData[indexPath.row] : self.allTableDataArray[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

//MARK:- SearchBar
extension ViewController : UISearchBarDelegate, UISearchResultsUpdating {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSeacrhActive = false
        guard searchText.lengthOfBytes(using: String.Encoding.utf8) == 0 else {
            
            filteredData.removeAll()
            if selectedDateString != "" {
                filteredData = filteredDateSlectedData.filter({ (user) -> Bool in
                    return (user.noteTitle!.lowercased().contains(searchText.lowercased())) || (user.noteDescription!.lowercased().contains(searchText.lowercased()))
                })
            } else {
                filteredData = allTableDataArray.filter({ (user) -> Bool in
                    return (user.noteTitle!.lowercased().contains(searchText.lowercased())) || (user.noteDescription!.lowercased().contains(searchText.lowercased()))
                })
            }
            isSeacrhActive = true
            tableview!.reloadData()
            return
        }
        //search text is empty, so reload with original orgs
        filteredData.removeAll()
        tableview!.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //do something
        if searchBar.text?.count == 0 {
            searchBar.resignFirstResponder() //hide keyboard
        }else {
            searchBar.resignFirstResponder()
            searchBar.text = ""
            isSeacrhActive = false
            filteredData.removeAll()
            tableview!.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isSeacrhActive = false
        filteredData.removeAll()
        tableview!.reloadData()
    }
}

//MARK:- Animations
extension ViewController {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transitionViewController.popStyle = (operation == .pop)
        return transitionViewController
    }
}

//MARK:- FilterDateDelegate
extension ViewController : FilterDateDelegate {
    
    func calculatedValue(value: String) {
        
        if value != "" {
            checkDate = true
            self.selectedDateString = value
        } else {
            checkDate = false
            self.selectedDateString = value
        }
    }
}

