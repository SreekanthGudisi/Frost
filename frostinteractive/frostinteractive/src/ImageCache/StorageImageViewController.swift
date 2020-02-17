//
//  StorageImageViewController.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 04/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import UIKit

class StorageImageViewController {

    // Class StroreImages
    static func storeImage(urlstring: String, img: UIImage) {
        
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        let data = img.jpegData(compressionQuality: 0.7)
        try? data?.write(to: url)
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String : String]
        if dict == nil {
            dict = [ String: String]()
        }
        dict![urlstring] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }
}
