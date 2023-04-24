//
//  ContentView.swift
//  swiftui-redux-demo
//
//  Created by KARLOS AGUIRRE on 4/23/23.
//

import SwiftUI

struct AppState {
    var names:[String] = ["Redux demo", "Aprende SwiftUI"]
}

enum AppAction {
    case loadNames
}

func appReducer(action: AppAction, state: inout AppState) {
    switch action {
        case .loadNames:
        state.names.append(contentsOf: ["Aprende Swift", "Aprende Xcode"])
    }
}

class AppStore: ObservableObject {
    @Published private(set) var appState: AppState
    private let reducer: (AppAction, inout AppState) -> Void
    
    init(appState: AppState, reducer: @escaping (AppAction, inout AppState) -> Void) {
        self.appState = appState
        self.reducer = reducer
    }
    
    func reduce(action: AppAction) {
        reducer(action, &appState)
    }
}

struct ContentView: View {
    
    @StateObject var store: AppStore = AppStore(appState: AppState(), reducer: appReducer)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.appState.names, id: \.self) { name in
                    Text(name)
                }
            }
            .toolbar(content: {
                Button("tap me") {
                    store.reduce(action: .loadNames)
                }
            })
            .navigationTitle("Names")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
