import SwiftUI

struct ContentView: View {
    @State private var showPrivyViewController = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")

            Button(action: { showPrivyViewController = true }) {
                Text("Open Privy Page")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showPrivyViewController) {
                // Present the UIKit view controller using the SwiftUI representable
                PrivyViewControllerRepresentable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
