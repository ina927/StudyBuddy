//
//  CommonPageHeader.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct CommonPageHeader: View {
    let title: String
    var trailing: AnyView? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
            Spacer()
            trailing
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }
}
