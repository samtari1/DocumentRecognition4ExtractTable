//
//  DocumentView.swift
//  DocumentRecognition2ExtractKeyInformation
//
//  Created by Quanpeng Yang on 3/17/26.
//

import SwiftUI
import Vision
import DataDetection

struct DocumentView: View {
    @State private var textFound: String = "Recognizing..."
    
    var body: some View {
        VStack {
            ScrollView {
                Text(textFound)
                    .padding()
                    .font(.system(.body, design: .monospaced)) // Makes data easier to read
            }
            Spacer()
        }
        .task {
            // 1. Pull the "invoice" from your Asset Catalog
            guard let uiImage = UIImage(named: "word_raw_table"),
                  let cgImage = uiImage.cgImage else {
                textFound = "Invoice image not found in Assets."
                return
            }
            
            do {
                let request = RecognizeDocumentsRequest()
                
                // 2. Perform the request on the CGImage
                let result = try await request.perform(on: cgImage)
                
                var tableContent = ""
                
                if let document = result.first?.document {
                    // 3. Look for the first table found in the document
                    if let table = document.tables.first {
                        // Use enumerated() to get the index (i) and the row data
                        for (i, row) in table.rows.enumerated() {
                            var rowItems: [String] = []
                            
                            for cell in row {
                                let cellText = cell.content.text.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !cellText.isEmpty {
                                    rowItems.append(cellText)
                                }
                            }
                            
                            if !rowItems.isEmpty {
                                // Join cells with a pipe for a "table" feel
                                tableContent += rowItems.joined(separator: " | ") + "\n"
                                
                                // Check if this was the header row (index 0)
                                if i == 0 {
                                    tableContent += "---------------------------\n"
                                }
                            }
                        }
                    }
                    
                    // 6. Update the UI
                    textFound = tableContent.isEmpty ? "No table detected." : tableContent
                    
                }
            } catch {
                textFound = "Error: \(error.localizedDescription)"
                print("Table Extraction Error: \(error)")
            }
        }
    }
}
