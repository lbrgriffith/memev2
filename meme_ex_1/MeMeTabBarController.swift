//
//  MeMeTabBarController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/03/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit

final class MeMeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // iOS 26: let the tab bar minimise on scroll for the new Liquid Glass treatment.
        if #available(iOS 26.0, *) {
            tabBarMinimizeBehavior = .onScrollDown
        }

        // The storyboard's tab items have empty titles and reference image assets that
        // were never added to the catalog. Configure them with SF Symbols instead so the
        // tabs are actually visible on iOS 26's translucent tab bar.
        let configuration: [(String, String, String)] = [
            ("List", "list.bullet.rectangle", "list.bullet.rectangle.fill"),
            ("Grid", "square.grid.2x2", "square.grid.2x2.fill")
        ]

        guard let items = tabBar.items else { return }
        for (item, config) in zip(items, configuration) {
            item.title = config.0
            item.image = UIImage(systemName: config.1)
            item.selectedImage = UIImage(systemName: config.2)
        }
    }
}
