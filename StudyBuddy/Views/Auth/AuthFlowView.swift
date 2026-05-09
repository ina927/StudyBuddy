//
//  AuthFlowView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

//Logo
struct StudyBuddyLogo: View {
    var size: CGFloat = 80

    private let pinkColor   = Color(red: 0.933, green: 0.369, blue: 0.408)
    private let greenColor  = Color(red: 0.243, green: 0.651, blue: 0.502)
    private let purpleColor = Color(red: 0.427, green: 0.337, blue: 0.910)

    private let pinkPos   = CGPoint(x: 0.32, y: 0.18)
    private let greenPos  = CGPoint(x: 0.82, y: 0.43)
    private let purplePos = CGPoint(x: 0.40, y: 0.72)

    var body: some View {
        Canvas { ctx, sz in
            func pt(_ frac: CGPoint) -> CGPoint {
                CGPoint(x: frac.x * sz.width, y: frac.y * sz.height)
            }
            let pPt = pt(pinkPos)
            let gPt = pt(greenPos)
            let vPt = pt(purplePos)

            var lines = Path()
            lines.move(to: pPt); lines.addLine(to: gPt)
            lines.move(to: pPt); lines.addLine(to: vPt)
            ctx.stroke(lines, with: .color(.white), lineWidth: size * 0.025)

            let r = size * 0.12
            func node(at c: CGPoint, color: Color) {
                let rect = CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)
                ctx.fill(Path(ellipseIn: rect), with: .color(color))
            }
            node(at: pPt, color: pinkColor)
            node(at: gPt, color: greenColor)
            node(at: vPt, color: purpleColor)
        }
        .frame(width: size, height: size)
    }
}

//Landing
struct AuthFlowView: View {
    private let authBg = Color(red: 0.882, green: 0.867, blue: 0.961)

    var body: some View {
        NavigationStack {
            ZStack {
                authBg.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    StudyBuddyLogo(size: 90)
                        .padding(.bottom, 20)

                    Text("StudyBuddy")
                        .font(.system(size: 34, weight: .bold))

                    Text("Find your study buddy!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 6)

                    Spacer()

                    VStack(spacing: 14) {
                        NavigationLink(destination: LoginDetailView()) {
                            Text("Login")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(AppTheme.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: SignUpView()) {
                            Text("Create account")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(AppTheme.accentPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AuthInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    var keyboardType: UIKeyboardType = .default

    @FocusState private var focused: Bool
    @State private var showText = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.accentPurple.opacity(0.55))
                .frame(width: 20)

            Group {
                if isSecure && !showText {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .focused($focused)

            if isSecure {
                Button { showText.toggle() } label: {
                    Image(systemName: showText ? "eye.slash" : "eye")
                        .foregroundStyle(AppTheme.accentPurple.opacity(0.55))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(AppTheme.softPurple)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(focused ? AppTheme.accentPurple : Color.clear, lineWidth: 1.5)
        )
    }
}
