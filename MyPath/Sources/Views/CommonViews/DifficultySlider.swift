//
//  slider.swift
//  MyPath
//
//  Created by Saqib Younis on 15/12/2024.
//

import SwiftUI
import SwiftUI

struct DifficultySlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double> = 1...10
    
    // For displaying value with one decimal place
    private var displayValue: String {
        String(format: "%.1f", value)
    }
    
    // Geometry reader will give us the actual width
    var body: some View {
        VStack(spacing: 20) {
            Text("Difficulty Level: \(displayValue)")
                .font(.headline)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    // Filled portion
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: calculateFillWidth(totalWidth: geometry.size.width), height: 8)
                        .cornerRadius(4)
                    
                    // Draggable handle
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 2)
                        .frame(width: 24, height: 24)
                        .offset(x: calculateHandleOffset(totalWidth: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    updateValue(for: gesture, totalWidth: geometry.size.width)
                                }
                        )
                }
                .frame(height: 24) // Match circle height
            }
            .frame(height: 24) // Set fixed height for GeometryReader
            .padding(.horizontal, 12)
            
            // Value markers
            HStack {
                ForEach(1...10, id: \.self) { number in
                    Text("\(number)")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
    }
    
    private func calculateFillWidth(totalWidth: CGFloat) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (totalWidth - 24) * CGFloat(percentage)
    }
    
    private func calculateHandleOffset(totalWidth: CGFloat) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (totalWidth - 24) * CGFloat(percentage)
    }
    
    private func updateValue(for gesture: DragGesture.Value, totalWidth: CGFloat) {
        let percentage = max(0, min(1, gesture.location.x / (totalWidth - 24)))
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
        value = round(newValue * 10) / 10
        value = max(range.lowerBound, min(range.upperBound, value))
    }
}
