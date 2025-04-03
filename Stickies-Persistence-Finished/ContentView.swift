//
//  ContentView.swift
//  Stickies-Persistence-Finished
//
//  Created by Justin Wong on 4/3/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var stickies: [Stickie]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(stickies) { stickie in
                    StickieView(stickie: stickie)
                        .zIndex(stickie.zIndex)
                }
            }
            .toolbar {
                addStickieToolbarButton
            }
        }
    }
    
    private var addStickieToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                withAnimation {
                    let newStickie = Stickie(zIndex: Double(stickies.count))
                    modelContext.insert(newStickie)
                    try? modelContext.save()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.gray)
                    .font(.system(size: 30))
            }
        }
    }
}


// MARK: - StickieView

struct StickieView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var text = ""
    @State private var position: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var isHolding = false
    
    var stickie: Stickie
    
    init(stickie: Stickie) {
        self.stickie = stickie
        
        _text = State(initialValue: stickie.text)
        _position = State(initialValue: stickie.getPositionCGSize())
    }
    
    var body: some View {
        mainView
            .shadow(color: .gray.opacity(0.5), radius: 10)
            .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        position.width += value.translation.width
                        position.height += value.translation.height
                        dragOffset = .zero
                        
                        stickie.positionWidth = position.width
                        stickie.positionHeight = position.height
                        try? modelContext.save()
                    }
            )
    }
    
    private var mainView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.yellow)
                .frame(width: 150, height: 150)
                .scaleEffect(isHolding ? 1.2 : 1)
                .overlay(
                    VStack {
                        TextField("Type Here", text: $text)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 30, leading: 10, bottom: 10, trailing: 10))
                )
                .onLongPressGesture {} onPressingChanged: { isPressing in
                    withAnimation(.spring) {
                        isHolding = isPressing
                    }
                    
                    if isPressing {
                        stickie.zIndex = Date.timeIntervalSinceReferenceDate
                    }
                }
        
            headerView
        }
        .onChange(of: text) { oldValue, newValue in
            stickie.text = newValue
            try? modelContext.save()
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                deleteButton
                Spacer()
            }
            .padding(7)
            Spacer()
        }
        .frame(width: 150, height: 150)
    }
    
    private var deleteButton: some View {
        Button(action: {
            withAnimation {
                modelContext.delete(stickie)
                try? modelContext.save()
            }
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.regularMaterial)
        }
        .opacity(isHolding ? 0 : 1)
        .disabled(isHolding)
    }
}

#Preview {
    ContentView()
}

