//
//  MemeDetailViewController.swift
//  Mememe20
//
//  Created by Jan Gundorf on 30/03/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: MemeStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = meme.memedImage
    }
    
    @IBAction func editAction(_ sender: Any) {
        let memeEditorVC = storyboard!.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditor
        memeEditorVC.memeSentFromDetail = self.meme
        self.navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
}
