//
//  TableViewCell.swift
//  MyBooks
//
//  Created by Daniil Belyaev on 05.07.2021.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var labelLabel: UILabel!
   
    var desc: String?
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionButtonPressed: UIButton!
    
    @IBAction func descButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Description", message: desc ?? "No description", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)    }
    
    
}
