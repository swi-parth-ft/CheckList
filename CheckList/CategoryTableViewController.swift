//
//  CategoryTableViewController.swift
//  CheckList
//
//  Created by Parth Antala on 2022-09-26.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var category = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destinationVC.selectedCategory = category[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        
      
        return cell
        
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
                var textField = UITextField()
                let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
                let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
        
                    let newCategory = Categories(context: self.context)
                    newCategory.name = textField.text!
                    self.category.append(newCategory)
                    self.saveCategory()
        
                }
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
    }
    

    
    func saveCategory(){
       
        do{
            try context.save()
        } catch {
           print("error saving data")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        //let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
        category = try context.fetch(request)
        } catch {
            print("error fetching data")
        }
        tableView.reloadData()
    }
    

}
