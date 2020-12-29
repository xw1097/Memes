//
//  MemeCollectionViewController.swift
//  Memes
//
//  Created by Xicheng Wang on 12/27/20.
//  Copyright © 2020 xichengw. All rights reserved.
//

import UIKit

class SentMeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.collectionView.reloadData();
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let space: CGFloat = 3.0;
        let dimension = (view.frame.size.width - (2 * space)) / 3.0;
        flowLayout.minimumLineSpacing = space;
        flowLayout.minimumInteritemSpacing = space;
        flowLayout.itemSize = CGSize(width: dimension, height: dimension);
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "CollectionViewCell";
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let meme = (self.memes!)[indexPath.row];
        
        (cell as! SentMeCollectionViewCell).cellImage.image = meme.memedImage;
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MemeDetailPageSegue") {
            let detailPageVC = segue.destination as! MemeDetailPageViewController;
            let memedImage = (sender as! SentMeCollectionViewCell).cellImage.image as UIImage?;
            detailPageVC.image = memedImage;
        }
    }
}
