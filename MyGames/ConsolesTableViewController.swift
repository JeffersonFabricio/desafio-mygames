//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Aluno on 8/24/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadConsoles()
    }
    
    func loadConsoles() {
        ConsolesManager.shared.loadConsoles(with: context)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ConsolesManager.shared.consoles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let console = ConsolesManager.shared.consoles[indexPath.row]
        
        cell.textLabel?.text = console.name
        if let image = console.cover as? UIImage {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "noCover")
        }
        
        return cell
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let console = ConsolesManager.shared.consoles[indexPath.row]
        showAlert(with: console)
        
        // deselecionar atual cell
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addConsole(_ sender: Any) {
        showAlert(with: nil)
    }
    
    
    func showAlert(with console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
       
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Nome da plataforma"
           
            if let name = console?.name {
                textField.text = name
            }
        })
       
        alert.addAction(UIAlertAction(title: title, style: .default, handler: {(action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print(error.localizedDescription)
            }
        }))
       
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
       
        present(alert, animated: true, completion: nil)
    }
    
}
