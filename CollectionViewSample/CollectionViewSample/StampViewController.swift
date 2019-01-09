//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by Ryo Tsuruda on 1/28/15.
//  Copyright (c) 2015 UQ Times. All rights reserved.
//

import UIKit

class StampViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        // 適当な緑色のセル
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(140.0, 140.0)
    }
}
