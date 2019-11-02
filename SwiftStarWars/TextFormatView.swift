//
//  AccessoryView.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit


class TextFormatView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .lightGray
        self.alpha = 0.6
        
        boldButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(boldButton)
        NSLayoutConstraint.activate([
        boldButton.trailingAnchor.constraint(equalTo:
        trailingAnchor, constant: -20),
        boldButton.centerYAnchor.constraint(equalTo:
        centerYAnchor)
        ])

    }
    
    let boldButton: UIButton! = {
        let sendButton = UIButton(type: .custom)
        sendButton.setTitleColor(.darkText, for: .normal)
        sendButton.setTitle("Bold", for: .normal)
        sendButton.setTitleColor(.white, for: .disabled)
        sendButton.addTarget(self, action: #selector(didTapBold), for: .touchUpInside)
        sendButton.showsTouchWhenHighlighted = true
        sendButton.isEnabled = true
        return sendButton
    }()
    
    @objc func didTapBold() {
        print("bold")
    }
    
    
    
    
    // MARK: Mac Catalyst Support
    
    #if targetEnvironment(macCatalyst)

    let OurButtonToolbarIdentifier = NSToolbarItem.Identifier(rawValue: "OurButton")
    
    func setupTitleBar(_ windowScene: UIWindowScene) {
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = makeMyFancyToolbar()
        }
    }
    
    private func makeMyFancyToolbar() -> NSToolbar {
        let toolbar = NSToolbar(identifier: "MyToolbar")
        toolbar.delegate = self
        return toolbar
    }

    @objc func myFancyAction(sender: UIBarButtonItem) {
        print("Button Pressed")
    }
    #endif

}

#if targetEnvironment(macCatalyst)

extension TextFormatView: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if (itemIdentifier == OurButtonToolbarIdentifier) {
            let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(myFancyAction(sender:)))
            let button = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButton)
            return button
        }
        return nil
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier.flexibleSpace, OurButtonToolbarIdentifier]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }
}
#endif

//from ribbon library, just here as example of how to map our aztec format bar menu items to ns menu
//func setupToolbar() {
//    if let formatMenuItem = NSApp.mainMenu?.item(withTitle: "Format") {
//        formatBar.menuItems.forEach({ formatMenuItem.submenu?.addItem($0) })
//    }
//}


