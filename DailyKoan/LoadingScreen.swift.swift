import SwiftUI

struct LoadingScreen: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Image(systemName: "hourglass")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(), value: isAnimating)

                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
