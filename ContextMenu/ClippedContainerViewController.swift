//
//  ClippedContainerViewController.swift
//  ThingsUI
//
//  Created by Ryan Nystrom on 3/10/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

internal class ClippedContainerViewController: UIViewController {

    private let options: ContextMenu.Options
    private let containedViewController: UINavigationController

    init(options: ContextMenu.Options, viewController: UIViewController) {
        self.options = options
        self.containedViewController = UINavigationController(rootViewController: viewController)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = options.containerStyle.cornerRadius
        view.layer.shadowRadius = options.containerStyle.shadowRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2

        containedViewController.view.layer.cornerRadius = view.layer.cornerRadius
        containedViewController.view.clipsToBounds = true
        containedViewController.setNavigationBarHidden(options.menuStyle == .minimal, animated: false)

        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }

        options.containerStyle.backgroundColor.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        let navigationBar = containedViewController.navigationBar
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        navigationBar.shadowImage = image

        addChildViewController(containedViewController)
        view.addSubview(containedViewController.view)
        containedViewController.didMove(toParentViewController: self)

        preferredContentSize = containedViewController.preferredContentSize
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containedViewController.view.frame = view.bounds
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        preferredContentSize = container.preferredContentSize
    }

}