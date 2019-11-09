//
//  TestTextController.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/5/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit
import SwiftUI
import RichEditorView

final class TestTextController: UIViewController {

    var editView: RichEditorView!
    var sourceView: UITextView!
    
    var stack: UIStackView!


    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        editView.delegate = self
        editView.inputAccessoryView = toolbar
        editView.placeholder = "Edit here"

        toolbar.delegate = self
        toolbar.editor = editView
//        editView.html = "<b>Jesus is God.</b> He saves by grace through faith alone. Soli Deo gloria! <a href='https://perfectGod.com'>perfectGod.com</a>"

        // This will create a custom action that clears all the input text when it is pressed
//        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
//            toolbar?.editor?.html = ""
//        }
//
//        var options = toolbar.options
//        options.append(item)
//        toolbar.options = options
    }
    
    func setup() {
        
        #if targetEnvironment(macCatalyst)

        TextToolbarManager.shared.showToolbar()
        
        NotificationCenter.default.addObserver(forName: .bold, object: nil, queue: nil) { (notify) in
            self.editView.bold()
        }
        
        NotificationCenter.default.addObserver(forName: .italic, object: nil, queue: nil) { (notify) in
            self.editView.italic()
        }
        
        NotificationCenter.default.addObserver(forName: .underline, object: nil, queue: nil) { (notify) in
            self.editView.underline()
        }
        
        NotificationCenter.default.addObserver(forName: .strikethrough, object: nil, queue: nil) { (notify) in
            self.editView.strikethrough()
        }
        
        NotificationCenter.default.addObserver(forName: .alignLeft, object: nil, queue: nil) { (notify) in
            self.editView.alignLeft()
        }
        
        NotificationCenter.default.addObserver(forName: .alignCenter, object: nil, queue: nil) { (notify) in
            self.editView.alignCenter()
        }
        
        NotificationCenter.default.addObserver(forName: .alignRight, object: nil, queue: nil) { (notify) in
            self.editView.alignRight()
        }
        
        NotificationCenter.default.addObserver(forName: .listBullet, object: nil, queue: nil) { (notify) in
            self.editView.unorderedList()
        }
        
        NotificationCenter.default.addObserver(forName: .listNumber, object: nil, queue: nil) { (notify) in
            self.editView.orderedList()
        }
        
        NotificationCenter.default.addObserver(forName: .textSize, object: nil, queue: nil) { (notify) in
            self.editView.setFontSize(18) //TODO: make this more dynamic text sizing
        }
        
        NotificationCenter.default.addObserver(forName: .textSub, object: nil, queue: nil) { (notify) in
            self.editView.subscriptText() //TODO: this doesnt work as expected, no way to undo it
        }
        
        NotificationCenter.default.addObserver(forName: .textSuper, object: nil, queue: nil) { (notify) in
            self.editView.superscript() //TODO: this doesnt work as expected, no way to undo it
        }
        
        #endif
        
        editView = RichEditorView(frame: .zero)
        editView.translatesAutoresizingMaskIntoConstraints = false
                
        sourceView = UITextView(frame: .zero)
        sourceView.translatesAutoresizingMaskIntoConstraints = false

        stack = UIStackView(arrangedSubviews: [editView, sourceView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

}

extension TestTextController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) { }

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            sourceView.text = "HTML Preview"
        } else {
            sourceView.text = content
        }
    }

    func richEditorTookFocus(_ editor: RichEditorView) { }
    
    func richEditorLostFocus(_ editor: RichEditorView) { }
    
    func richEditorDidLoad(_ editor: RichEditorView) { }
    
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool { return true }

    func richEditor(_ editor: RichEditorView, handleCustomAction content: String) { }
    
}

extension TestTextController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors = [
            UIColor.red,
            UIColor.orange,
            UIColor.yellow,
            UIColor.green,
            UIColor.blue,
            UIColor.purple
        ]

        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
//        if let hasSelection = toolbar.editor?.rangeSelectionExists(), hasSelection {
//            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
//        }
    }
}

extension TestTextController: UIViewControllerRepresentable {
    typealias UIViewControllerType = TestTextController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TestTextController>) -> TestTextController {
        let vc = TestTextController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: TestTextController, context: UIViewControllerRepresentableContext<TestTextController>) {
        //do nothing for now
    }
}
