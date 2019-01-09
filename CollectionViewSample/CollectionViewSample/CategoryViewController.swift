//
//  CategoryViewController.swift
//  CollectionViewSample
//
//  Created by Ryo Tsuruda on 1/29/15.
//  Copyright (c) 2015 UQ Times. All rights reserved.
//

import UIKit

class CategoryViewController: UICollectionViewController {
    
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
        
        // 適当な赤色のセル
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(44.0, 44.0)
    }
}
