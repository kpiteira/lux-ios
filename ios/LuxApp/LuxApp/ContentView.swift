import SwiftUI

struct ContentView: View {
    @State private var isRecording = false
    @State private var statusText = "Tap to speak"

    var body: some View {
        VStack(spacing: 40) {
            Text("Lux")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Spacer()

            Text(statusText)
                .font(.body)
                .foregroundStyle(.secondary)

            // Tap-to-talk mic button (placeholder — not wired up yet)
            Button {
                isRecording.toggle()
                statusText = isRecording ? "Listening..." : "Tap to speak"
            } label: {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.accentColor)
                        .frame(width: 80, height: 80)

                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
