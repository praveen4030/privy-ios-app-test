import SwiftUI
import UIKit

struct PrivyViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PrivyViewController {
        return PrivyViewController()
    }
    
    func updateUIViewController(_ uiViewController: PrivyViewController, context: Context) {
        // Implement interaction updates if needed
    }
}
