//
//  MemeTableViewcontroller.swift
//  Mememe20
//
//  Created by Jan Gundorf on 24/03/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewcontroller: UITableViewController {
    
    var memes: [MemeStruct] {
        return MemeManager.shared.loadMemeLib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // only one section
        return 1
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    // Set the edit action - here Delete - for the table item
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, IndexPath) in
            // Remove item directly from the memelib array
            MemeManager.shared.deleteFromMemeLib(place:indexPath.row)

            // And remembe to delete the row from the table view
            tableView.deleteRows(at: [IndexPath as IndexPath], with: .fade)
        })
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // return number of memes
        return memes.count
    }
    
    // Implementation of CellForRowAt....
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let meme = memes[indexPath.row]
        cell.memeLabel.text = meme.topText + " ... " + meme.buttomText;
        cell.memeImage.image = meme.memedImage
        return cell
    }
    
    // If item is selected, push MemeDetailViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeView, animated: true)
    }
}
