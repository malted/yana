//
//  TimeView.swift
//  Yana
//
//  Created by Ben Dixon on 3/21/25.
//

import SwiftUI
import Foundation

enum TimeViewStyle {
    case label
    case full
}

struct TimeView: View {
    @State private var currentDate: Date
    private var staticDate: Bool
    private var style: TimeViewStyle
    private var dateFormatter: DateFormatter
    
    init(date: Date? = nil, style: TimeViewStyle = .full) {
        self.staticDate = date != nil
        self.currentDate = date ?? Date()
        
        self.style = style
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = style == .full ? .medium : .none
        self.dateFormatter.timeStyle = .medium
    }
    
    var dateValue: String {
        let raw = dateFormatter.string(from: currentDate)
        switch self.style {
            case .full: return raw
            case .label: return raw.components(separatedBy: " ").first ?? raw
        }
    }
    
    var body: some View {
        if self.staticDate {
            Text(dateValue)
                .font(.caption)
        } else {
            Text(dateValue)
                .font(.caption)
                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                    self.currentDate = Date()
                }
        }
    }
}

#Preview {
    TimeView(style: .label)
        .padding(32)
}
