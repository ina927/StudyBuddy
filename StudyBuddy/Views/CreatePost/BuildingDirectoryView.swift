//
//  BuildingDirectoryView.swift
//  StudyBuddy
//
//  Created by Ina Song on 4/5/2026.
//

import SwiftUI

struct BuildingDirectoryView: View {
    let onSelectFloor: (_ code: String, _ name: String, _ floor: String, _ asset: String) -> Void
    @State private var expanded: Set<String> = []

    var body: some View {
        List {
            ForEach(MetadataStore.buildings) { b in
                Section {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expanded.contains(b.id) },
                            set: { isOn in
                                if isOn { expanded.insert(b.id) } else { expanded.remove(b.id) }
                            }
                        )
                    ) {
                        ForEach(b.floors) { floor in
                            Button {
                                onSelectFloor(b.code, b.name, floor.name, floor.floorPlanAssetName)
                            } label: {
                                HStack {
                                    Image(systemName: "square.split.bottomrightquarter")
                                    Text(floor.name)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "building.2")
                            Text(b.label)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
