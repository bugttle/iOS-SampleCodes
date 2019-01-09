//
//  ChatViewController.swift
//  CollectionViewSample
//
//  Created by Ryo Tsuruda on 1/29/15.
//  Copyright (c) 2015 UQ Times. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = NSString(format: "%d - %d", indexPath.section, indexPath.row)
        return cell
    }
}
