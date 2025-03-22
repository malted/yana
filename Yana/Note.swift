//
//  Note.swift
//  Yana
//
//  Created by Ben Dixon on 3/21/25.
//

import SwiftUI

class NoteData: ObservableObject, Identifiable {
    @Published var text: String
    @Published var timestamp: Date?

    init(text: String, timestamp: Date? = nil) {
        self.text = text
        self.timestamp = timestamp
    }
}

struct Note: View, Identifiable {
    let id = UUID()
    @ObservedObject var data: NoteData
    
    var body: some View {
        GridRow {
            TimeView(date: data.timestamp)
                .opacity(0.5)
                .transition(.opacity)
            Text(data.text)
//                .scaleEffect(data.timestamp != nil ? 0.5 : 1.0, anchor: .leading)
//                .fixedSize(horizontal: false, vertical: true)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .foregroundStyle(.primary)
//                .border(.red)
        }
//        .border(.red)
    }
}

#Preview {
    let formatter = ISO8601DateFormatter()
    let data = NoteData(text: "Testing! Hello world!", timestamp: formatter.date(from: "2025-03-21T12:00:00Z")!)
    Note(data: data)
}
