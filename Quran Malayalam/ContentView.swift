//
//  ContentView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 11/02/22.
//

import SwiftUI

struct Message: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

struct MessageRow: View {
    var message: Message

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message.title)
                .font(.headline)
                .bold()

            Text(message.content)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
}

struct ContentView: View {
    var messages = [Message(title: "Hello", content: "Hello my friend, how have you been? I've been wondering if you'd like to meet up sometime."), Message(title: "50% off sales", content: "Last chance to get a hold of last season's collection, now with an additional 50% off."), Message(title: "Required documents", content: "Hi, please find attached the required documents."), Message(title: "You have 8 new followers", content: "Congrats! Since yesterday, 8 new people followed you! Log into the app to see who they are.")]
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Inbox")
                .font(.title).bold()
                .padding(.horizontal)

            List(messages) { message in
                MessageRow(message: message)
                    .swipeActions {
                        Button {
                                        print("Message deleted")
                                } label: {
                                        Label("Delete", systemImage: "trash")
                                }
                        }
            }
        }
    }
}

//struct MessageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRow(message: Message(title: "Hello", content: "Hello my friend, how have you been? I've been wondering if you'd like to meet up sometime."))
//    }
//}
//struct ContentView: View {
//    let colors:[String] = ["White","Green","Blue","Red","Black"]
//    var body: some View {
//        VStack{
//            ForEach(colors, id: \.self) {color in
//                HStack {
//                    Text(color).frame(width: .infinity,
//                                      height: 55,
//                                      alignment: .leading)
//                    Spacer()
//                }
//
//            }.swipeActions {
//                Button {
//
//                } label: {
//                    Image(systemName: "person.3")
//                }
//                .tint(.indigo)
//            }
//        }
//    }
//}
//
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
