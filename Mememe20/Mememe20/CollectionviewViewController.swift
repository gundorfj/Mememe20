//
//  CollectionviewViewController.swift
//  Mememe20
//
//  Created by Jan Gundorf on 24/03/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import Foundation
import UIKit

class CollectionviewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    var memes: [MemeStruct]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = MemeManager.shared.loadMemeLib()

        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set space to 3.0
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        memes = MemeManager.shared.loadMemeLib()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of Memes items
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.item]
        cell.image.image = meme.memedImage
        
        return cell
    }
    
    // If item is selected, push MemeDetailViewController
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
}

