//
//  TextEditorController.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

final class TextEditorController: UIViewController, UITextViewDelegate {
    

    var editView: TextEditor!
    var sourceView: TextEditor!
        
    var stack: UIStackView!
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        
        
        editView = TextEditor(frame: .zero)
        editView.translatesAutoresizingMaskIntoConstraints = false
                
        sourceView = TextEditor(frame: .zero)
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

    
    func textViewDidChange(_ textView: UITextView) {
        let html = editView.getHTML()
        sourceView.editorView.loadHTMLString(html, baseURL: nil)
    }
}
