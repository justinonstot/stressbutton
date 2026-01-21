import SwiftUI
import SwiftData

@main
struct SerenityApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AnxietyRecord.self)
    }
}
