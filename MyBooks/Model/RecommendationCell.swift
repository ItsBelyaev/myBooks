//
//  RecommendationCell.swift
//  MyBooks
//
//  Created by Daniil Belyaev on 06.07.2021.
//

import UIKit

class RecommendationCell: UITableViewCell {

    @IBOutlet weak var labelLabel: UILabel!
    
    var desc: String?
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descButton: UIButton!
    
    @IBAction func descriptionButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Description", message: desc ?? "No description", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
}
