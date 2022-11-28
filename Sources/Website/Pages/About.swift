import Foundation
import TokamakStaticHTML

struct AboutPage: View {

    let homeURL = URL(string: "/")!

    var body: some View {
        ScrollView {
            HTMLTitle("About | Server Side Swift")
            VStack(alignment: .leading) {
                Text("About Us")
                    .font(.largeTitle)
                Text("This is everything you would want to know about us")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                Link("Home", destination: homeURL)
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .frame(idealWidth: 800, maxWidth: 800, alignment: .topLeading)
            .padding()
        }
    }
}
