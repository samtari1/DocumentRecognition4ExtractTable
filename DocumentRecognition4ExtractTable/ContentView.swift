//
//  ContentView.swift
//  DocumentRecognition
//
//  Created by Quanpeng Yang on 3/17/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            // Using the native SwiftUI Image initializer is safer
            NavigationLink(destination: DocumentView()) {
                VStack {
                    Image("word_raw_table")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 900) // Optional: give it a defined size
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Documents") // Good practice for NavigationStack
        }
    }
}
