//
//  ContentView.swift
//  TODOLIST
//
//  Created by Nicholas M Hieb on 7/27/24.
//

import SwiftUI

struct ListItem: Identifiable, Equatable, Hashable {
  var id = UUID()
  var name: String
  var isCompleted: Bool = false
  var dueDate: Date
  var note: String
  var priorityLevel: String
}

struct ContentView: View {
  @State private var taskCreate: String = ""
  @State private var listItems: [ListItem] = []
  @State var searchText: String = ""
  
  func filteredItems() -> [ListItem] {
    if searchText.isEmpty {
      return listItems
    } else {
      return listItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
  }
  
  func toggleCompletion(for item: ListItem) {
    if let index = listItems.firstIndex(of: item) {
      listItems[index].isCompleted.toggle()
    }
  }
  
  private func binding(for item: ListItem) -> Binding<ListItem> {
    guard let index = listItems.firstIndex(of: item) else {
      fatalError("Error for Data")
    }
    return $listItems[index]
  }
  
  var body: some View {
    VStack {
      HStack {
        TextField(
          "New Task Name",
          text: $taskCreate
        )
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button(action: {
          let newItem = ListItem(name: taskCreate, dueDate: Date(), note: "", priorityLevel: "none")
          listItems.append(newItem)
          taskCreate = ""
        }, label: {
          Image(systemName: "plus.app")
            .imageScale(.large)
            .foregroundStyle(.tint)
        })
      }.padding()
      
      NavigationView {
        List {
          ForEach(filteredItems()) { item in
            HStack {
              VStack (alignment: .leading) {
                Button(action: {
                  toggleCompletion(for: item)
                }, label: {
                  Text("Done:")
                  Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .primary)
                })
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                  .background(.black)
                
                Button(role: .destructive, action: {
                  let index = listItems.firstIndex(of: item)
                  listItems.remove(at: index ?? 0)
                }, label: {
                  Text("Remove:")
                  Image(systemName: "trash")
                    .foregroundStyle(.red)
                })
                .buttonStyle(PlainButtonStyle())
              }
              
              Divider()
                .background(.black)
              
              NavigationLink(destination: ListDetailsPage(item: binding(for: item))) {
                Text(item.name)
              }
              .buttonStyle(PlainButtonStyle())
              
              
            }.padding(.trailing, 12)
          }
        }.searchable(text: $searchText)
          .navigationTitle("Tasks")
      }
    }.background()
  }
}

#Preview {
  ContentView()
}
