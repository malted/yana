//
//  ContentView.swift
//  Yana
//
//  Created by Ben Dixon on 3/21/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesManager: NotesManager
    
    @State private var newNoteText = ""
    @State private var isAnimating = false
    @State private var showNewNoteField = true
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    Spacer(minLength: 64)
                    
                    Grid(alignment: .topLeading, verticalSpacing: 8) {
                        if showNewNoteField {
                            GridRow {
                                TimeView(date: nil)
                                    .opacity(0.5)
                                TextEditor(text: $newNoteText)
                                    .focusable(true)
                                    .focusEffectDisabled()
                                    .font(.system(size: 13))
                                    .scrollContentBackground(.hidden)
                                    .background(.clear)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.leading, -5)
                                    .onKeyPress(.return) {
                                        if !newNoteText.isEmpty {
                                            submitNewNote()
                                        }
                                        return .handled
                                    }
//                                    .border(.red)
                            }
                            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                        }
                        
                        ForEach(Array(notesManager.notes.reversed().enumerated()), id: \.element.id) { index, note in
                            Note(data: note)
                                .transition(.offset(x: 0, y: -24))
                                .id(note.id)
                                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                .animation(.spring(duration: 0.2, bounce: 0.5).delay(Double(index) * 0.025), value: notesManager.notes.count)
                        }
                    }
                }
                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }
        }
        .frame(maxWidth: 600)
        .animation(.spring(duration: 0.2, bounce: 0.45), value: notesManager.notes.count)
        .padding()
    }
    
    private func submitNewNote() {
        // Create new note
        let newNote = NoteData(text: newNoteText, timestamp: Date())
        let tempText = newNoteText
        newNoteText = ""

//        withAnimation {
        notesManager.addNote(newNote: newNote)
//         }
    }
}

#Preview {
    @Previewable @StateObject var notesManager = NotesManager()

    ContentView()
        .environmentObject(notesManager)
}
