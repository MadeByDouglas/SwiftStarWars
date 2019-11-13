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
    static let strikethrough = "strikethrough"
    static let alignLeft = "text.alignleft"
    static let alignCenter = "text.aligncenter"
    static let alignRight = "text.alignright"
    static let listBullet = "list.bullet"
    static let listNumber = "list.number"
    static let textSize = "textformat.size"
    static let textSub = "textformat.subscript"
    static let textSuper = "textformat.superscript"
}

fileprivate extension Selector {
    static let barButton = #selector(TextToolbarManager.didTapBarButton)
    static let groupButton = #selector(TextToolbarManager.didTapGroupButton)
    static let touchBarButton = #selector(TextToolbarManager.didTapTouchBarButton)

}

// MARK: Singleton Manager coordinates toolbar and touchbar

class TextToolbarManager: UIResponder, NSToolbarDelegate {
    static var shared = TextToolbarManager()
    
    let defaultItems: [NSToolbarItem.Identifier] = [.format, .align, .list]
    let defaultTouchbarItems: [NSTouchBarItem.Identifier] = [.format, .list]

    
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
        toolbar.isVisible = false
//        guard toolbar.items.count > 0 else {return}
//        guard let visItems = toolbar.visibleItems else {return}
//        for (i, item) in visItems.enumerated() {
//            toolbar.removeItem(at: i)
//            item.isEnabled = false
//        }
    }
    
    func showToolbar() {
        
        toolbar.isVisible = true
//        guard toolbar.items.count == 0 else {return}
//
//        toolbar.insertItem(withItemIdentifier: .format, at: 0)
//        toolbar.insertItem(withItemIdentifier: .align, at: 1)
//        toolbar.insertItem(withItemIdentifier: .list, at: 2)
    }
    
    // MARK: button action handlers

    @objc func didTapBarButton(sender: UIBarButtonItem) {
        
        sendTextFormatCommand(name: sender.accessibilityLabel!)
    }
    
    @objc func didTapGroupButton(sender: NSToolbarItemGroup) {
        let index = sender.selectedIndex
        sendTextFormatCommand(name: sender.subitems[index].accessibilityLabel!)
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
        return type.makeGroupButton()
        
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

enum TextFormat: Int {
    case bold
    case italic
    case underline
    case strikethrough
    
    var imageName: String {
        switch self {
        case .bold: return SymbolName.bold
        case .italic: return SymbolName.italic
        case .underline: return SymbolName.underline
        case .strikethrough: return SymbolName.strikethrough
        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
    
    var type: NSToolbarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .strikethrough: return .strikethrough

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
    
    // makes a button with UIbarButton which means it has no border
    func makeButton2() -> NSToolbarItem {
        
        let image = UIImage(systemName: imageName)
        let barItem = NSToolbarItem(itemIdentifier: type)
        barItem.image = image
        barItem.target = TextToolbarManager.shared
        barItem.action = .barButton
        barItem.tag = self.rawValue
        barItem.accessibilityLabel = self.imageName
        
        return barItem
    }
}

enum TextAlign {
    case left
    case center
    case right
    
    var imageName: String {
        switch self {
        case .left: return SymbolName.alignLeft
        case .center: return SymbolName.alignCenter
        case .right: return SymbolName.alignRight
        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

enum TextList {
    case bullet
    case number
    
    var imageName: String {
        switch self {
            
        case .bullet: return SymbolName.listBullet
        case .number: return SymbolName.listNumber

        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

enum TextSize {
    case fontSize
    case textSub
    case textSuper
    
    var imageName: String {
        switch self {
            
        case .fontSize: return SymbolName.textSize
        case .textSub: return SymbolName.textSub
        case .textSuper: return SymbolName.textSuper

        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

enum ToolBarItem: String {
    case format = "format"
    case align = "align"
    case list = "list"
    case size = "size"
    
    
    static let toolBarID = "primaryToolbar"
    
    var id: String {
        return self.rawValue
    }
    
    init(type: NSToolbarItem.Identifier) {
        switch type {
        case .format: self = .format
        case .align: self = .align
        case .list: self = .list
        case .size: self = .size
            
        default: print("You passed an unknown format value, defaulting to format"); self = .format
        }
    }
        
    var type: NSToolbarItem.Identifier {
        switch self {
        case .format: return .format
        case .align: return .align
        case .list: return .list
        case .size: return .size

        }
    }
    
    
    func makeGroupButton() -> NSToolbarItemGroup {
        switch self {
        case .format:
            let images = [TextFormat.bold.image, TextFormat.italic.image, TextFormat.underline.image]
            let names = [TextFormat.bold.imageName, TextFormat.italic.imageName, TextFormat.underline.imageName]
            return configGroupButton(images: images, labels: names, mode: .selectAny)
            
        case .align:
            let images = [TextAlign.left.image, TextAlign.center.image, TextAlign.right.image]
            let names = [TextAlign.left.imageName, TextAlign.center.imageName, TextAlign.right.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .selectOne)
            
        case .list:
            let images = [TextList.bullet.image, TextList.number.image]
            let names = [TextList.bullet.imageName, TextList.number.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .momentary)
            
        case .size:
            let images = [TextSize.fontSize.image]
            let names = [TextSize.fontSize.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .momentary)
        }
    }
    
    private func configGroupButton(images: [UIImage], labels: [String], mode: NSToolbarItemGroup.SelectionMode) -> NSToolbarItemGroup {
        

        let group = NSToolbarItemGroup(itemIdentifier: type, images: images, selectionMode: mode, labels: labels, target: TextToolbarManager.shared, action: .groupButton)
        
        group.accessibilityLabel = id
        for (index, item) in group.subitems.enumerated() {
            item.accessibilityLabel = labels[index]
        }
        
        return group
    }
}


extension NSToolbarItem.Identifier {
    
    static let format = NSToolbarItem.Identifier(rawValue: ToolBarItem.format.rawValue)
    static let align = NSToolbarItem.Identifier(rawValue: ToolBarItem.align.rawValue)
    static let list = NSToolbarItem.Identifier(rawValue: ToolBarItem.list.rawValue)
    static let size = NSToolbarItem.Identifier(rawValue: ToolBarItem.size.rawValue)

    //just in case we need these as single buttons
    static let bold = NSToolbarItem.Identifier(rawValue: SymbolName.bold)
    static let italic = NSToolbarItem.Identifier(rawValue: SymbolName.italic)
    static let underline = NSToolbarItem.Identifier(rawValue: SymbolName.underline)
    static let strikethrough = NSToolbarItem.Identifier(rawValue: SymbolName.strikethrough)
//
//    static let alignLeft = NSToolbarItem.Identifier(rawValue: SymbolName.alignLeft)
//    static let alignCenter = NSToolbarItem.Identifier(rawValue: SymbolName.alignCenter)
//    static let alignRight = NSToolbarItem.Identifier(rawValue: SymbolName.alignRight)
//
//    static let listBullet = NSToolbarItem.Identifier(rawValue: SymbolName.listBullet)
//    static let listNumber = NSToolbarItem.Identifier(rawValue: SymbolName.listNumber)
//
//    static let textSize = NSToolbarItem.Identifier(rawValue: SymbolName.textSize)
//    static let textSub = NSToolbarItem.Identifier(rawValue: SymbolName.textSub)
//    static let textSuper = NSToolbarItem.Identifier(rawValue: SymbolName.textSuper)
}

extension Notification.Name {
    static let bold = Notification.Name(SymbolName.bold)
    static let italic = Notification.Name(SymbolName.italic)
    static let underline = Notification.Name(SymbolName.underline)
    static let strikethrough = Notification.Name(SymbolName.strikethrough)
    
    static let alignLeft = Notification.Name(SymbolName.alignLeft)
    static let alignCenter = Notification.Name(SymbolName.alignCenter)
    static let alignRight = Notification.Name(SymbolName.alignRight)
    
    static let listBullet = Notification.Name(SymbolName.listBullet)
    static let listNumber = Notification.Name(SymbolName.listNumber)

    static let textSize = Notification.Name(SymbolName.textSize)
    static let textSub = Notification.Name(SymbolName.textSub)
    static let textSuper = Notification.Name(SymbolName.textSuper)
}

// MARK: Touchbar support

extension ToolBarItem {
    
    static let touchBarBase = "com.SwiftStarWars."
    static let touchBarID = "\(ToolBarItem.touchBarBase)touchBar"
    
    var idTouch: String {
        
        
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(rawValue)"
    }
    
    init(type: NSTouchBarItem.Identifier) {
        switch type {
        case .format: self = .format
        case .align: self = .align
        case .list: self = .list
        case .size: self = .size
            
        default: print("You passed an unknown format value, defaulting to format"); self = .format
        }
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .format: return .format
        case .align: return .align
        case .list: return .list
        case .size: return .size

        }
    }
    
    func makeGroupTouchbarButton() -> NSTouchBarItem {
        
        switch self {
        case .format:
            
            let buttons = [TextFormat.bold.makeTouchbarButton(), TextFormat.italic.makeTouchbarButton(), TextFormat.underline.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

        case .align:
            
            let buttons = [TextAlign.left.makeTouchbarButton(), TextAlign.center.makeTouchbarButton(), TextAlign.right.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)
            
        case .list:
            
            let buttons = [TextList.bullet.makeTouchbarButton(), TextList.number.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

            
        case .size:

            let buttons = [TextSize.fontSize.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

        }

    }
}

extension TextFormat {
    
    var idTouch: String {
        
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .strikethrough: return .strikethrough

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        
        
        
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
    
}

extension TextAlign {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .left: return .alignLeft
        case .center: return .alignCenter
        case .right: return .alignRight

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
    
}

extension TextList {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .bullet: return .alignLeft
        case .number: return .alignCenter

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
}

extension TextSize {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .fontSize: return .textSize
        case .textSub: return .textSub
        case .textSuper: return .textSuper

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }

}

extension NSTouchBarItem.Identifier {
    
    static let format = NSTouchBarItem.Identifier(ToolBarItem.format.idTouch)
    static let align = NSTouchBarItem.Identifier(ToolBarItem.align.idTouch)
    static let list = NSTouchBarItem.Identifier(ToolBarItem.list.idTouch)
    static let size = NSTouchBarItem.Identifier(ToolBarItem.size.idTouch)

    
    static let bold = NSTouchBarItem.Identifier(TextFormat.bold.idTouch)
    static let italic = NSTouchBarItem.Identifier(TextFormat.italic.idTouch)
    static let underline = NSTouchBarItem.Identifier(TextFormat.underline.idTouch)
    static let strikethrough = NSTouchBarItem.Identifier(TextFormat.strikethrough.idTouch)

    static let alignLeft = NSTouchBarItem.Identifier(TextAlign.left.idTouch)
    static let alignCenter = NSTouchBarItem.Identifier(TextAlign.center.idTouch)
    static let alignRight = NSTouchBarItem.Identifier(TextAlign.right.idTouch)

    static let listBullet = NSTouchBarItem.Identifier(TextList.bullet.idTouch)
    static let listNumber = NSTouchBarItem.Identifier(TextList.number.idTouch)

    static let textSize = NSTouchBarItem.Identifier(TextSize.fontSize.idTouch)
    static let textSub = NSTouchBarItem.Identifier(TextSize.textSub.idTouch)
    static let textSuper = NSTouchBarItem.Identifier(TextSize.textSuper.idTouch)
}

extension AppDelegate: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = ToolBarItem.touchBarID
        touchBar.defaultItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems + [NSTouchBarItem.Identifier.otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems
        
        return touchBar

    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let item = ToolBarItem(type: identifier)
        return item.makeGroupTouchbarButton()
        
    }

}

#endif
