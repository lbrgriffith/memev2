//
//  MemeDetailedController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

final class MemeDetailedController: UIViewController {

    var meme: Meme?
    var removalIndex = 0

    @IBOutlet weak var memedPhoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        memedPhoto.image = meme?.memeImage
        memedPhoto.contentMode = .scaleAspectFit

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit", style: .plain, target: self, action: #selector(edit)
        )
    }

    @objc private func edit() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editor = storyboard.instantiateViewController(withIdentifier: "MemeScene") as! MemeEditorViewController
        editor.isEdit = true
        editor.memeToEdit = meme
        editor.removalIndex = removalIndex
        present(editor, animated: true)
    }
}
