//
//  MemeCollectionViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 17/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

final class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var memeFlowLayout: UICollectionViewFlowLayout!

    private var memes: [Meme] { MemeStore.shared.memes }

    override func viewDidLoad() {
        super.viewDidLoad()
        let spacing: CGFloat = 3
        let dimension = (view.frame.size.width - 2 * spacing) / 3
        memeFlowLayout.minimumInteritemSpacing = spacing
        memeFlowLayout.minimumLineSpacing = spacing
        memeFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    // MARK: Actions

    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editor = storyboard.instantiateViewController(withIdentifier: "MemeScene") as! MemeEditorViewController
        present(editor, animated: true)
    }

    // MARK: Collection view

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memes.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeMeCollectionViewCell", for: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.memedImage?.image = meme.memeImage
        cell.memedImage?.contentMode = .scaleAspectFill
        cell.memedImage?.clipsToBounds = true
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "details") as! MemeDetailedController
        detail.meme = memes[indexPath.item]
        detail.removalIndex = indexPath.item
        navigationController?.pushViewController(detail, animated: true)
    }
}
