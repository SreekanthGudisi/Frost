//
//  AddNotesViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 06/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit
import CoreData
import Photos

class AddNotesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var tagsTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var attachedMediaLabel: UITextField!
    
    let imagePicker = UIImagePickerController()
    var selectedImageOrDocumentURLString = String()
    var selectedImageOrDocumentURLData = Data()
    var selectedImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        titleTextfield.delegate = self
        tagsTextfield.delegate = self
        descriptionTextView.delegate = self
        
        titleTextfield.text = ""
        descriptionTextView.text = ""
        tagsTextfield.text = ""
        attachedMediaLabel.text = ""
    }
    
    @IBAction func attachedButtonTapped(_ sender: Any) {
        
        accessDocsAndImages()
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
        saveResponseToCoreData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- SaveCoreData
extension AddNotesViewController {
    
    func saveResponseToCoreData() {
        
        guard (titleTextfield.text?.count != 0) else {
            showAlert(title: "OOPS", message: "Please enter title")
            return
        }
        
        guard (descriptionTextView.text?.count != 0) else {
            showAlert(title: "OOPS", message: "Please enter description")
            return
        }
        
        //save to core data
        let context = PersistenceSerivce.context
        let objects = NSEntityDescription.insertNewObject(forEntityName: "NotesData", into: context)
        do {
            let randomInt = randomNumberWith(digits:5)
            objects.setValue(randomInt, forKey: "noteID")
            objects.setValue(titleTextfield.text, forKey: "noteTitle")
            objects.setValue(descriptionTextView.text, forKey: "noteDescription")
            objects.setValue(tagsTextfield.text ?? "", forKey: "noteTag")
            objects.setValue(selectedImageOrDocumentURLData, forKey: "noteImage")
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.timeZone = TimeZone(abbreviation: "IST")
            let dateOnly = formatter.string(from: date)
            objects.setValue(dateOnly, forKey: "noteDate")
            PersistenceSerivce.saveContext()
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            //do nothing
        }
    }
    
    func randomNumberWith(digits:Int) -> Int {
        
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
    
    func showAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


//MARK:- ImagePicker
extension AddNotesViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func checkPermission() {

        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            //accessDocsAndImages()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ newStatus in
                print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        @unknown default:
            print("Defults")
        }
    }

    func accessDocsAndImages() {
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let openGalleryAction = UIAlertAction(title: "Open Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            print("Opened gallery")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //self.fileUploadImage.isHidden = false
        })
        optionMenu.addAction(openGalleryAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if info[UIImagePickerController.InfoKey.editedImage] != nil {
            selectedImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            if let img = selectedImage.image {
                let data = img.pngData() as NSData?
                selectedImageOrDocumentURLData = data! as Data
            }
        } else {
            selectedImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if let img = selectedImage.image {
                let data = img.pngData() as NSData?
                selectedImageOrDocumentURLData = data! as Data
            }
        }
        
        let attachedName = (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.lastPathComponent
        attachedMediaLabel.text = attachedName
        dismiss(animated: true, completion: nil)
    }

    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Documnets
extension AddNotesViewController: UIDocumentPickerDelegate {
    
    // MARK: - iCloud files
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        let urlWithoutFileExtension: URL =  urls[0].deletingPathExtension()
        let fileNameWithoutExtension: String = urlWithoutFileExtension.lastPathComponent
        print(fileNameWithoutExtension)
        let selectedGalleryNameString = urls[0].lastPathComponent
        attachedMediaLabel.text = selectedGalleryNameString
        dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print(" cancelled by user")
    }
}

//MARK:- UITextFieldDeleate
extension AddNotesViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        titleTextfield.resignFirstResponder()
        tagsTextfield.resignFirstResponder()
        return true
    }
}

//MARK:- UITextViewDeleate
extension AddNotesViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

