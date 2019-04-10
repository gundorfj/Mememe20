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
        return (UIApplication.shared.delegate as! AppDelegate).memesLib
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let meme = memes[indexPath.row]
        cell.memeLabel.text = meme.topText + meme.buttomText;
        cell.memeImage.image = meme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(memeView, animated: true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        let memeEditorVC = storyboard!.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditor
        memeEditorVC.memeSentFromDetail = self.meme
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }
}
