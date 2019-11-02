//
//  ContentView.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 10/11/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

let manager = DataManager.shared


struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   
     
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Master"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { manager.savePeopleFromServer(viewContext: self.viewContext) }
                        }
                    ) { 
                        Image(systemName: "square.and.arrow.down.on.square")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoreDataPerson.name, ascending: true)],
        animation: .default)
    var events: FetchedResults<CoreDataPerson>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(events, id: \.self) { event in
                NavigationLink(
                    destination: DetailView(event: event)
                ) {
                    Text("\(event.name!)")
                }
            }.onDelete { indices in
                self.events.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var event: CoreDataPerson

    var body: some View {
        VStack {
            
            NavigationLink(
                destination: TextView()
            ) {
                Image(systemName: "square.and.pencil")
            }
            
            Text("\(event.name!)")
                .navigationBarTitle(Text("Detail"))

        }
    }
}

struct TextView: View {
    var body: some View {
        TextEditorController()
    }
}

extension TextEditorController: UIViewControllerRepresentable {
    typealias UIViewControllerType = TextEditorController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TextEditorController>) -> TextEditorController {
        let vc = TextEditorController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: TextEditorController, context: UIViewControllerRepresentableContext<TextEditorController>) {
        //do nothing for now
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
