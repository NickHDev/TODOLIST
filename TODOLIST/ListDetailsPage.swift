//
//  ListDetailsPage.swift
//  TODOLIST
//
//  Created by Nicholas M Hieb on 7/27/24.
//

import SwiftUI

struct ListDetailsPage: View {
  @Binding var item: ListItem
  @State var showCalendar = false
  
  enum Priority: String, CaseIterable{
    case high,medium,low,none
    
    var displayName: String {
      switch self {
      case .high: return "High"
      case .medium: return "Medium"
      case .low: return "Low"
      case .none: return "None"
      }
    }
  }
  
  
  var body: some View {
    
    ZStack {
      VStack(alignment: .leading) {
        Text("")
          .navigationTitle(item.name)
        
        Divider()
          .background(.black)
          .padding(5)
        
        TextField("Enter Note", text: $item.note)
          .textFieldStyle(.roundedBorder)
          .padding(5)
        
        Divider()
          .background(.black)
          .padding(5)
        
        HStack {
          Text("Priority:")
          Menu(item.priorityLevel) {
            ForEach(Priority.allCases, id: \.self) { priority in
              Button(priority.displayName) {
                item.priorityLevel = priority.displayName
              }
            }
          }.buttonStyle(.bordered)
        }
        
        //Spacer()
        HStack {
          Text("Due Date: ")
          Button("Date", systemImage: "calendar") {
            showCalendar.toggle()
          }.popover(isPresented: $showCalendar, content: {
            DatePicker("",selection: $item.dueDate, displayedComponents: [.date, .hourAndMinute])
              .datePickerStyle(.graphical)
          })
        }
        Text("\(item.dueDate.formatted())")
        Spacer()
      }.padding(12)
    }
    
    
  }
}

//#Preview {
//ListDetailsPage(item: ListItem(name: "", dueDate: Date()), note: Binding<String>, //priorityLevel: Binding<String>)
//}


