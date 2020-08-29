//
//  CategoryTableViewController.swift
//  WordzApp
//
//  Created by Mac-HOME on 14.07.2020.
//  Copyright © 2020 Mac-HOME. All rights reserved.
//

import UIKit
import CoreData

private let cellIdentifier = "CategoryCellId"

class CategoryTableViewController: UITableViewController {
    
    var category: Category?
    
    public var sentences = [Sentence]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // registeration
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        fetchSentences()
        setupLayout()
        setupEmptyState()
        
    }
    
    func updateData() {
        fetchSentences()
        self.tableView.reloadData()
    }
    
    fileprivate func fetchSentences() {
        sentences = CoreDataManager.shared.fetchSentences(category: category)
        
        guard let title = category?.title else { return }
        if title == Storage.shared.favouritesTitle {
            sentences.reverse()
            return
        }
    }
    
    fileprivate func setupLayout() {
        tableView.backgroundColor = UIColor.appColor(.white_lightgray)
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.white_lightgray)
        tableView.tableFooterView = view
        tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentences.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        cell.textLabel?.textColor = UIColor.appColor(.text_black_white)
        cell.backgroundColor = UIColor.appColor(.white_lightgray)
        cell.sentence = sentences[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let title = category?.title, title == Storage.shared.favouritesTitle else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in
            
            let sentence = self.sentences[indexPath.row]
            
            // delete from tableview
            self.sentences.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete from CoreData
            CoreDataManager.shared.deleteFavoriteSentence(sentence: sentence)
            
            self.reloadEmptyState()
            complete(true)
        }
        deleteAction.backgroundColor = .lightRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
