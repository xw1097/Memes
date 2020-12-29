//
//  DetailPageViewController.swift
//  Memes
//
//  Created by Xicheng Wang on 12/28/20.
//  Copyright © 2020 xichengw. All rights reserved.
//

import UIKit

class MemeDetailPageViewController: UIViewController {
    
    var image: UIImage? // hold image that segue passed in
    
    @IBOutlet weak var detailPageImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.detailPageImage.image = self.image;
    }
}
