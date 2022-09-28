//
//  CategoryTableViewController.swift
//  CheckList
//
//  Created by Parth Antala on 2022-09-26.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController, UINavigationBarDelegate {

    let realm = try! Realm()
    
    var category: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    override func viewWillAppear(_ animated: Bool) {
        let color = UIColor(hexString: "1D9BF6")
       
        navigationController?.navigationBar.tintColor = ContrastColorOf(color!, returnFlat: true)
        let textAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(color!, returnFlat: true)]
       
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
       
        navBarAppearance.largeTitleTextAttributes = textAttributes
        navBarAppearance.backgroundColor = color
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "gotoItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destinationVC.selectedCategory = category?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = category?[indexPath.row].name ?? "no categories"
        cell.backgroundColor = UIColor(hexString: (category?[indexPath.row].color)!)
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (category?[indexPath.row].color)!)!, returnFlat: true)
      
        return cell
        
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
                var textField = UITextField()
                let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
                let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
        
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.color = UIColor.randomFlat().hexValue()
                    self.saveCategory(category: newCategory)
        
                }
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
    }
    

    
    func saveCategory(category: Category){
       
        do{
            try realm.write{
                realm.add(category)
            }
        } catch {
           print("error saving data")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(){
       
        category = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        do{
            try self.realm.write{
                self.realm.delete(self.category![indexPath.row])
            }
        } catch {
           print("error saving data")
        }

    }
    

}


