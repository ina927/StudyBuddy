//
//  StudyBuddyLogo.swift
//  StudyBuddy
//
//  Created by Zizhu on 9/5/2026.
//
import SwiftUI

struct StudyBuddyLogo: View {
    var size: CGFloat = 80
    var isMonochrome: Bool = false

    private var s: CGFloat { size / 80 }

    private var pink:   Color { isMonochrome ? .white : Color(red: 0.94, green: 0.42, blue: 0.49) }
    private var green:  Color { isMonochrome ? .white : Color(red: 0.25, green: 0.82, blue: 0.67) }
    private var purple: Color { isMonochrome ? .white : Color(red: 0.52, green: 0.44, blue: 0.82) }

    // Node positions (in 80×70 space)
    private var pinkPos:   CGPoint { CGPoint(x: 30 * s, y: 10 * s) }
    private var greenPos:  CGPoint { CGPoint(x: 60 * s, y: 30 * s) }
    private var purplePos: CGPoint { CGPoint(x: 24 * s, y: 58 * s) }

    var body: some View {
        ZStack {
            // Lines behind circles
            Path { path in
                path.move(to: pinkPos)
                path.addLine(to: greenPos)
                path.move(to: pinkPos)
                path.addLine(to: purplePos)
            }
            .stroke(Color.white, lineWidth: 4 * s)

            // Purple node (bottom)
            Circle()
                .fill(purple)
                .frame(width: 24 * s, height: 24 * s)
                .position(purplePos)

            // Green node (right)
            Circle()
                .fill(green)
                .frame(width: 20 * s, height: 20 * s)
                .position(greenPos)

            // Pink node (top)
            Circle()
                .fill(pink)
                .frame(width: 22 * s, height: 22 * s)
                .position(pinkPos)
        }
        .frame(width: 80 * s, height: 70 * s)
    }
}
