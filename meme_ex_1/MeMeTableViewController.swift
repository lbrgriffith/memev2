//
//  MeMeTableViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

final class MeMeTableViewController: UITableViewController {

    private var memes: [Meme] { MemeStore.shared.memes }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: Actions

    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editor = storyboard.instantiateViewController(withIdentifier: "MemeScene") as! MemeEditorViewController
        present(editor, animated: true)
    }

    // MARK: Table view

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        let meme = memes[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = "\(meme.topString)…\(meme.bottomString)"
        content.image = meme.memeImage
        content.imageProperties.maximumSize = CGSize(width: 53, height: 53)
        content.imageProperties.cornerRadius = 6
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        MemeStore.shared.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "details") as! MemeDetailedController
        detail.meme = memes[indexPath.row]
        detail.removalIndex = indexPath.row
        navigationController?.pushViewController(detail, animated: true)
    }
}
