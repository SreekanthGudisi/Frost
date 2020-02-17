//
//  FilterViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 10/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit

@objc protocol FilterDateDelegate : NSObjectProtocol {
    
    func calculatedValue(value: String)
}

class FilterViewController: UIViewController {

    @IBOutlet var clealAllButton: UIButton!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var imageChange: UIImageView!
    @IBOutlet var hideUIView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var isClealAllSelected = false
    weak var filterDateDelegate: FilterDateDelegate?
    let dateFormatter = DateFormatter()
    var viewController : ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideUIView.isHidden = true
    }
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {

        if imageChange.image == UIImage(named: "Check-mark.png") {
            
            isClealAllSelected = !isClealAllSelected
            if !isClealAllSelected  {
                dateTextField.text = "Select Date"
                clealAllButton.setTitleColor(.darkGray, for: .normal)
                imageChange.image = nil
            } else {
                clealAllButton.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
    
    @IBAction func selectedDateDoneButton(_ sender: Any) {
        
        getSelectedDate()
        hideUIView.isHidden = true
        imageChange.image = UIImage(named: "Check-mark.png")
        isClealAllSelected = !isClealAllSelected
        if !isClealAllSelected  {
            
            clealAllButton.setTitleColor(.darkGray, for: .normal)
        } else {
            clealAllButton.setTitleColor(.systemBlue, for: .normal)
        }
    }
        
    @IBAction func selectedDateCancelButton(_ sender: Any) {
        
        self.filterDateDelegate?.calculatedValue(value: "")
        hideUIView.isHidden = true
    }
    
    @IBAction func dateButtonTapped(_ sender: Any) {
        
        self.filterDateDelegate?.calculatedValue(value: "")
        hideUIView.isHidden = false
    }
    
    @IBAction func tapGestureTapped(_ sender: Any) {
        
        self.filterDateDelegate?.calculatedValue(value: "")
        hideUIView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        if dateTextField.text == "Select Date" {
            self.filterDateDelegate?.calculatedValue(value: "")
            navigationController?.popViewController(animated: true)
        } else {

            DispatchQueue.main.async {
                 
                let alert = UIAlertController(title: "Are you sure!", message: "You Want to add this filter \(self.dateTextField.text?.description ?? "") date?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
   //     viewController?.fetchAllDataFromCoredata()
    }
}

extension FilterViewController {
    
    func getSelectedDate() {
        
        self.datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.filterDateDelegate?.calculatedValue(value: dateFormatter.string(from: datePicker.date))
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
}


