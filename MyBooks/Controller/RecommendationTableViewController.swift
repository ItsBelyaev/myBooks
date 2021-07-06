//
//  RecommendationTableViewController.swift
//  MyBooks
//
//  Created by Daniil Belyaev on 06.07.2021.
//

import UIKit
import Firebase

class RecommendationTableViewController: UITableViewController {
    
    
    let db = Firestore.firestore()
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("recommendedBooks").addSnapshotListener { querySnapshot, error in
            self.books = []
            
            if let e = error {
                print("error")
            } else {
                if let snapshowDocuments = querySnapshot?.documents {
                    for doc in snapshowDocuments {
                        let data = doc.data()
                        self.books.append(Book(label: data["label"] as! String, author: data["author"] as! String, description: data["description"] as! String, uuid: data["uuid"] as! String))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                        }
                    }
                }
                print("Here it is2: \(self.books)")
                
            }
        }
        print("Here it is: \(books)")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as! BookCell
        
        let book = books[indexPath.row]
        
        cell.authorLabel.text = book.author
        cell.labelLabel.text = book.label
        cell.desc = book.description
        
        
        return cell
    }
    
    
}
