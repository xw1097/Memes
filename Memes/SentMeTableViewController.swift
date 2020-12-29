//
//  SentMeTableViewController.swift
//  Memes
//
//  Created by Xicheng Wang on 12/27/20.
//  Copyright © 2020 xichengw. All rights reserved.
//

import UIKit

class SentMeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView.rowHeight = 140;
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        self.tableView.reloadData();
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let meme = (self.memes!)[indexPath.row];
        
        (cell as! SentMeTableViewCell).cellImage.image = meme.memedImage;
        (cell as! SentMeTableViewCell).cellLabel.text = meme.topText + "..." + meme.bottomText;
        
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MemeDetailPageSegue") {
            let detailPageVC = segue.destination as! MemeDetailPageViewController;
            let memedImage = (sender as! SentMeTableViewCell).cellImage.image as UIImage?;
            detailPageVC.image = memedImage;
        }
    }

}
