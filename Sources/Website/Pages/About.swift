import ComputeUI

struct AboutPage: View {

    @Environment(\.request) var req

    var body: some View {
        ScrollView {
            HTMLTitle("About | Server Side Swift")
            VStack(alignment: .leading) {
                Text("About Us")
                    .font(.largeTitle)
                Text("This is everything you would want to know about us")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                Link("Home", destination: .path("/"))
                    .font(.body)
                    .foregroundColor(.blue)
                Spacer().frame(height: 20)
                Text("Your IP address is \(req.clientIpAddress().stringValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(idealWidth: 800, maxWidth: 800, alignment: .topLeading)
            .padding()
        }
    }
}
