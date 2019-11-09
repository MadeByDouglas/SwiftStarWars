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

struct SymbolName {
    static let bold = "bold"
    static let italic = "italic"
    static let underline = "underline"
    static let alignLeft = "text.alignleft"
    static let alignCenter = "text.aligncenter"
    static let alignRight = "text.alignright"
}

fileprivate extension Selector {
    static let barButton = #selector(TextToolbarManager.didTapBarButton)
    static let touchBarButton = #selector(TextToolbarManager.didTapTouchBarButton)

}

// MARK: Singleton Manager coordinates toolbar and touchbar

class TextToolbarManager: UIResponder, NSToolbarDelegate {
    static var shared = TextToolbarManager()
    
    let defaultItems: [NSToolbarItem.Identifier] = [.bold, .italic, .underline, .alignLeft, .alignCenter, .alignRight]
    let defaultTouchbarItems: [NSTouchBarItem.Identifier] = [.bold, .italic, .underline, .alignLeft, .alignCenter, .alignRight]

    
    lazy var toolbar: NSToolbar = {
        let toolbar = NSToolbar(identifier: ToolBarItem.toolBarID)
        toolbar.delegate = self
        
        return toolbar
    }()
    
    func setupTitleBar(_ windowScene: UIWindowScene) {
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = toolbar
        }
    }
    
    func hideToolbar() {
        guard toolbar.items.count > 0 else {return}
        for (i, _) in toolbar.items.enumerated() {
            toolbar.removeItem(at: i)
        }
    }
    
    func showToolbar() {
        guard toolbar.items.count == 0 else {return}
        toolbar.insertItem(withItemIdentifier: .bold, at: 0)
    }
    
    // MARK: button action handlers

    @objc func didTapBarButton(sender: UIBarButtonItem) {
        
        sendTextFormatCommand(name: sender.accessibilityLabel!)
    }
    
    @objc func didTapTouchBarButton(sender: NSButtonTouchBarItem) {
        
        sendTextFormatCommand(name: sender.customizationLabel)
    }
    
    func sendTextFormatCommand(name: String) {
    
        let notify = Notification(name: Notification.Name(rawValue: name))
        NotificationCenter.default.post(notify)
    }
    
    // MARK: Toolbar Delegate functions
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        let type = ToolBarItem(type: itemIdentifier)
        return type.makeButton()
        
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return defaultItems
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        let allowedItems: [NSToolbarItem.Identifier] = defaultItems + [.space, .flexibleSpace, .print]
        return allowedItems
    }
}

// MARK: toolbar object

enum ToolBarItem: Int {
    case bold
    case italic
    case underline
    case alignLeft
    case alignCenter
    case alignRight
    
    
    static let toolBarID = "primaryToolbar"

    
    init(type: NSToolbarItem.Identifier) {
        switch type {
        case .bold: self = .bold
        case .italic: self = .italic
        case .underline: self = .underline
        case .alignLeft: self = .alignLeft
        case .alignCenter: self = .alignCenter
        case .alignRight: self = .alignRight
        default: print("You passed an unknown format value, defaulting to bold"); self = .bold
        }
    }
        
    var type: NSToolbarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .alignLeft: return .alignLeft
        case .alignCenter: return .alignCenter
        case .alignRight: return .alignRight
        }
    }
    
    var imageName: String {
        switch self {
        case .bold: return SymbolName.bold
        case .italic: return SymbolName.italic
        case .underline: return SymbolName.underline
        case .alignLeft: return SymbolName.alignLeft
        case .alignCenter: return SymbolName.alignCenter
        case .alignRight: return SymbolName.alignRight
        }
    }
    
    func makeButton() -> NSToolbarItem {
        
        let image = UIImage(systemName: imageName)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: TextToolbarManager.shared, action: .barButton)
        let barItem = NSToolbarItem(itemIdentifier: type, barButtonItem: barButton)
        barItem.tag = self.rawValue
        barItem.accessibilityLabel = self.imageName
        
        return barItem
    }
}


extension NSToolbarItem.Identifier {
    static let bold = NSToolbarItem.Identifier(rawValue: SymbolName.bold)
    static let italic = NSToolbarItem.Identifier(rawValue: SymbolName.italic)
    static let underline = NSToolbarItem.Identifier(rawValue: SymbolName.underline)

    static let alignLeft = NSToolbarItem.Identifier(rawValue: SymbolName.alignLeft)
    static let alignCenter = NSToolbarItem.Identifier(rawValue: SymbolName.alignCenter)
    static let alignRight = NSToolbarItem.Identifier(rawValue: SymbolName.alignRight)
}

extension Notification.Name {
    static let bold = Notification.Name(SymbolName.bold)
    static let italic = Notification.Name(SymbolName.italic)
    static let underline = Notification.Name(SymbolName.underline)
    
    static let alignLeft = Notification.Name(SymbolName.alignLeft)
    static let alignCenter = Notification.Name(SymbolName.alignCenter)
    static let alignRight = Notification.Name(SymbolName.alignRight)
}

// MARK: Touchbar support

enum TouchToolBarItem: Int {
    case bold
    case italic
    case underline
    case alignLeft
    case alignCenter
    case alignRight
    
    private static let touchBarBase = "com.SwiftStarWars."
    static let touchBarID = "\(TouchToolBarItem.touchBarBase)touchBar"
    
    
    init(type: NSTouchBarItem.Identifier) {
        switch type {
        case .bold: self = .bold
        case .italic: self = .italic
        case .underline: self = .underline
        case .alignLeft: self = .alignLeft
        case .alignCenter: self = .alignCenter
        case .alignRight: self = .alignRight
        default: print("You passed an unknown format value, defaulting to bold"); self = .bold
        }
    }
    
    var type: NSTouchBarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .alignLeft: return .alignLeft
        case .alignCenter: return .alignCenter
        case .alignRight: return .alignRight
        }
    }
    
    var id: String {
        return "\(TouchToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var imageName: String {
        switch self {
        case .bold: return SymbolName.bold
        case .italic: return SymbolName.italic
        case .underline: return SymbolName.underline
        case .alignLeft: return SymbolName.alignLeft
        case .alignCenter: return SymbolName.alignCenter
        case .alignRight: return SymbolName.alignRight
        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        
        let image = UIImage(systemName: imageName)!
        let touchBarItem = NSButtonTouchBarItem(identifier: type, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName

        return touchBarItem
    }
}

extension NSTouchBarItem.Identifier {
    static let bold = NSTouchBarItem.Identifier(TouchToolBarItem.bold.id)
    static let italic = NSTouchBarItem.Identifier(TouchToolBarItem.italic.id)
    static let underline = NSTouchBarItem.Identifier(TouchToolBarItem.underline.id)
    
    static let alignLeft = NSTouchBarItem.Identifier(TouchToolBarItem.alignLeft.id)
    static let alignCenter = NSTouchBarItem.Identifier(TouchToolBarItem.alignCenter.id)
    static let alignRight = NSTouchBarItem.Identifier(TouchToolBarItem.alignRight.id)

}

extension AppDelegate: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = TouchToolBarItem.touchBarID
        touchBar.defaultItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems + [NSTouchBarItem.Identifier.otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems
        
        return touchBar

    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let item = TouchToolBarItem(type: identifier)
        return item.makeTouchbarButton()
        
    }

}

#endif
