//
//  DevelopersListView.swift
//  SeminarConsumer
//
//  Created by Hyojeong on 10/10/24.
//

import SwiftUI

struct DevelopersListView: View {
    @State private var isConsumerAppExpanded = true
    @State private var isManagerAppExpanded = true
    
    let consumerAppDevelopers = [
        "권희철", "김원호", "심현정", "이다영", "김효정", "최승호", "이소영", "이주노"
    ]
    
    let managerAppDevelopers = [
        "권희철", "김동경", "박범규", "강희창", "황인영"
    ]
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $isConsumerAppExpanded) {
                ForEach(consumerAppDevelopers, id: \.self) { developer in
                    DeveloperRow(developer: developer, leader: "김원호", crownHolder: "권희철")
                }
            } label: {
                Text("Consumer App")
                    .font(.title3)
                    .bold()
            }
            
            DisclosureGroup(isExpanded: $isManagerAppExpanded) {
                ForEach(managerAppDevelopers, id: \.self) { developer in
                    DeveloperRow(developer: developer, leader: "김동경", crownHolder: "권희철")
                }
            } label: {
                Text("Manager App")
                    .font(.title3)
                    .bold()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Developers")
    }
}

struct DeveloperRow: View {
    let developer: String
    let leader: String
    let crownHolder: String
    
    @Environment(\.colorScheme) var colorScheme // 다크모드/라이트모드 감지
    
    var body: some View {
        HStack {
            Text(developer)
            
            if developer == crownHolder {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
            } else if developer == leader {
                Text("팀장")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                    .foregroundStyle(colorScheme == .dark ? Color(UIColor.lightGray) : Color(UIColor.darkGray))
                    .cornerRadius(15)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DevelopersListView()
    }
}
