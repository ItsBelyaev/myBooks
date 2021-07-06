//
//  BooksTableViewController.swift
//  MyBooks
//
//  Created by Daniil Belyaev on 05.07.2021.
//
import Firebase
import UIKit


protocol CellProtocol {
    func didTapCell(description: String)
}

class BooksTableViewController: UITableViewController {

    var uuidFinal: String?
    let db = Firestore.firestore()
    
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBooks()
        books = []

        tableView.reloadData()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New book", message: "", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Label"
        }
        alert.addTextField { tf in
            tf.placeholder = "Author"
        }
        alert.addTextField { tf in
            tf.placeholder = "Description"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { action in
            
            guard let email = Auth.auth().currentUser?.email else {return}
            let uuid = UUID().uuidString
            print(uuid)
            self.db.collection("books").document(uuid).setData([
                "label": alert.textFields![0].text ?? "No label",
                "author": alert.textFields![1].text ?? "No author",
                "description": alert.textFields![2].text ?? "No description",
                "sender": email,
                "uuid": "\(uuid)"
            ])
            self.uuidFinal = uuid
            
            
            self.tableView.reloadData()
            print(self.books)
        
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loadBooks( ) {
        db.collection("books").addSnapshotListener { querySnapshot, error in
            self.books = []

            if let e = error {
                print("error")
            } else {
                if let snapshowDocuments = querySnapshot?.documents {
                    for doc in snapshowDocuments {
                        let data = doc.data()
                        if Auth.auth().currentUser?.email == data["sender"] as! String {
                            self.books.append(Book(label: data["label"] as! String, author: data["author"] as! String, description: data["description"] as! String, uuid: data["uuid"] as! String))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()

                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func recommendationButtonPressed(_ sender: UIBarButtonItem) {
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        
        
        if books.count != 0 {
            var book = books[indexPath.row]
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
                self.db.collection("books").document(book.uuid).delete()
                self.tableView.reloadData()
            }
            let recommendationAction = UIContextualAction(style: .normal, title: "Recommend") { _, _, _ in
                let alert = UIAlertController(title: "Warn", message: "If you want everyone to see your description, press 'Description'. If you do not want everyone to see your description, press 'No description'", preferredStyle: .alert)
                let descAction = UIAlertAction(title: "Description", style: .cancel) { act in
                    guard let email = Auth.auth().currentUser?.email else {return}
                    
                    self.db.collection("recommendedBooks").document(book.uuid).setData([
                        "label": book.label,
                        "author": book.author,
                        "description": book.description,
                        "sender": email,
                        "uuid": "\(book.uuid)"
                    ])
                    self.db.collection("books").document(book.uuid).delete()
                    self.tableView.reloadData()
                }
                let noDescAction = UIAlertAction(title: "No description", style: .destructive) { action in
                    book.description = "User decided not to share his description. Google it."
                    guard let email = Auth.auth().currentUser?.email else {return}
                    
                    self.db.collection("recommendedBooks").document(book.uuid).setData([
                        "label": book.label,
                        "author": book.author,
                        "description": book.description,
                        "sender": email,
                        "uuid": "\(book.uuid)"
                    ])
                    self.db.collection("books").document(book.uuid).delete()
                    self.tableView.reloadData()
                }
                alert.addAction(descAction)
                alert.addAction(noDescAction)
                self.present(alert, animated: true, completion: nil)
                
                

                
            }
            
            
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, recommendationAction])
                   configuration.performsFirstActionWithFullSwipe = true
                   return configuration
        } else {
            return UISwipeActionsConfiguration()
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookCell

        cell.selectionStyle = .none
        
        let book = books[indexPath.row]
        
        cell.desc = book.description        
        cell.labelLabel.text = book.label
        cell.authorLabel.text = book.author
        
        return cell
    }

    

}

//TODO: добавить функцию удаления, мб сделать фотки (также возможно через гугл), еще кнопку лог аута, ну и может быть список рекомендованных книжек от пользователей)
