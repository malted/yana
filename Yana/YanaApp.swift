//
//  YanaApp.swift
//  Yana
//
//  Created by Ben Dixon on 3/21/25.
//

import SwiftUI

class NotesManager: ObservableObject {
    @Published var notes: [NoteData] = []

    init() {
        loadNotes()
    }

    func loadNotes() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("notes.txt")

            do {
                let dateFormatter = ISO8601DateFormatter()
                let result = try String(contentsOf: fileURL, encoding: .utf8)

                self.notes = result
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .components(separatedBy: "\n\n")
                    .map {
                        let split = $0.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                        return NoteData(text: split[1], timestamp: dateFormatter.date(from: split[0]))
                    }
            }
            catch {
                print("Error loading notes: \(error)")
            }
        }
    }
    
    func addNote(newNote: NoteData) {
        guard let timestamp = newNote.timestamp else { return }
        
        notes.append(newNote)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("notes.txt")

            do {
                // 1. Create file if needed
                if !FileManager.default.fileExists(atPath: fileURL.path) {
                    try "".write(to: fileURL, atomically: true, encoding: .utf8)
                }

                // 2. Open file handle for appending
                let handle = try FileHandle(forWritingTo: fileURL)
                defer { handle.closeFile() }
                handle.seekToEndOfFile()

                // 3. Format with proper separators
                let content = (handle.offsetInFile > 0 ? "\n\n" : "") +
                "\(timestamp.ISO8601Format())\n\(newNote.text)"

                // 4. Append data
                if let data = content.data(using: .utf8) {
                    handle.write(data)
                }
            } catch {
                print("Error writing file: \(error)")
            }
        }
    }
}

@main
struct YanaApp: App {
    @StateObject private var notesManager = NotesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesManager)
        }
        .windowStyle(.hiddenTitleBar)
    }
}

//@main
//struct YanaApp: App {
//    @StateObject var notesManager = NotesManager()
//    
//    init() {
//        self._notesManager = StateObject(wrappedValue: NotesManager())
//        
//        let filePath = UserDefaults.standard.string(forKey: "notepath") ?? {
//            let p = NSHomeDirectory() + "/Documents/notes.txt"
//            UserDefaults.standard.set(p, forKey: "notepath")
//            return p
//        }()
//        
//        print(filePath)
//        
//        do {
//            if !FileManager.default.fileExists(atPath: filePath) {
//                if (FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)) {
//                    print("File created successfully.")
//                } else {
//                    print("File not created.")
//                }
//                
//                let fileHandle = try FileHandle(forWritingTo: URL(string: filePath)!)
//                fileHandle.seekToEndOfFile()
//                fileHandle.write("cont".data(using: String.Encoding.utf8)!)
//                fileHandle.closeFile()
//            } else {
//                
//            }
//        } catch {
//            print(error)
//        }
//        
////
//        
//        do {
//            try "test!".write(to: URL(string: filePath)!, atomically: true, encoding: .utf8)
//            print("File written successfully")
//        } catch {
//            print("Error writing file: \(error)")
//        }
//        
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = dir.appendingPathComponent("notes.txt")
//            
//            do {
//                let dateFormatter = ISO8601DateFormatter()
//                let result = try String(contentsOf: fileURL, encoding: .utf8)
//                
//                self.notesManager.notes = result
//                    .components(separatedBy: "\n\n")
//                    .map {
//                        let split = $0.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
//                        return NoteData(text: split[1], timestamp: dateFormatter.date(from: split[0]))
//                    }
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(notesManager)
//        }
//        .windowStyle(.hiddenTitleBar)
//    }
//}
