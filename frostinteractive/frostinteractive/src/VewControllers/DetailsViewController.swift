//
//  DetailsViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 08/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var urlToImage: UIImageView!
    @IBOutlet weak var tagsImage: UIImageView!

    @IBOutlet weak var tableview: UITableView!
    
    var notesData : NotesData? = nil
    var detailsTableDataArray = [NotesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsTableDataArray.append(notesData!)
        dateLabel.text = notesData?.noteDate ?? "Nil"
        tagsLabel.text = notesData?.noteTag ?? "Nil"
        
        urlToImage?.clipsToBounds = true
        urlToImage?.layer.cornerRadius = 10
        if notesData!.noteImage != nil {
            urlToImage?.image = UIImage(data: notesData!.noteImage!)
        } else {
            print("Empty Image")
            urlToImage?.image = UIImage(named: "Empty-Image.png")
        }
        
        if notesData!.noteTag == "" {
            tagsImage.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableview.separatorStyle = .none
        tableview.estimatedRowHeight = 300
        tableview.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableView
extension DetailsViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detailsTableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell") as? DetailsTableViewCell
        let data = detailsTableDataArray[indexPath.row]
        cell?.titleLabel.text = data.noteTitle  ?? "Nil"
        cell?.descriptionLabel.text = data.noteDescription  ?? "Nil"
        return cell!
    }
}
