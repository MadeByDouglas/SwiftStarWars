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
}

#if targetEnvironment(macCatalyst)

extension NSToolbarItem.Identifier {
    static let fontStyle: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "FontStyle")
}

class TextToolbarManager: NSObject, NSToolbarDelegate {
    static var shared = TextToolbarManager()
    
    
    lazy var toolbar: NSToolbar = {
        let toolbar = NSToolbar(identifier: "MyToolbar")
        toolbar.delegate = self
        return toolbar
    }()
    
    func setupTitleBar(_ windowScene: UIWindowScene) {
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = toolbar
        }
    }

    @objc func didTapBold(sender: UIBarButtonItem) {
        TextEditor
    }
    
    func hideToolbar() {
        
        for (i, _) in toolbar.items.enumerated() {
            toolbar.removeItem(at: i)
        }
        
    }
    
    func showToolbar() {
        guard toolbar.items.count == 0 else {return}
        toolbar.insertItem(withItemIdentifier: .fontStyle, at: 0)
    }
    
//    func customToolbarItem(
//        itemForItemIdentifier itemIdentifier: String,
//        label: String,
//        paletteLabel: String,
//        toolTip: String) -> NSToolbarItem? {
//
//        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: itemIdentifier))
//
//        toolbarItem.label = label
//        toolbarItem.paletteLabel = paletteLabel
//        toolbarItem.toolTip = toolTip
//        toolbarItem.target = self
//
//        return toolbarItem
//    }
    
    // MARK: Toolbar Delegate functions
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem = NSToolbarItem()

        if itemIdentifier == .fontStyle {
                        
            // 1) Font style toolbar item.
            
            let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapBold))
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButton)

            
        }
        return toolbarItem
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.fontStyle]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [ NSToolbarItem.Identifier.fontStyle,
        NSToolbarItem.Identifier.space,
        NSToolbarItem.Identifier.flexibleSpace,
        NSToolbarItem.Identifier.print ]
    }
}
#endif

//from ribbon library, just here as example of how to map our aztec format bar menu items to ns menu
//func setupToolbar() {
//    if let formatMenuItem = NSApp.mainMenu?.item(withTitle: "Format") {
//        formatBar.menuItems.forEach({ formatMenuItem.submenu?.addItem($0) })
//    }
//}


