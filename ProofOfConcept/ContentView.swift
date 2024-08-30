import SwiftUI
import WebKit

struct ContentView: View {
    @State private var webView: WKWebView = WKWebView() // Create the WKWebView instance
    @State private var userInput: String = "" // User input from TextField
    @State private var message: String = ""

    var body: some View {
        VStack {
            VStack {
           
                TextField("Enter text to inject", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button(action: {
                        injectJavaScriptValue()
                    }) {
                        Text("JS")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        injectVueValue()
                    }) {
                        Text("Vue")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                Text("\(message)")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            
            }.padding(15)
            WebView(webView: webView) // Custom WebView using UIViewRepresentable
                .padding()
                .border(Color.red, width: 2) // Add red border with 2 pt width around WebView
        }
        .padding(15)
        .border(Color.orange, width: 2)
        .padding(15)
        .onAppear {
            setupWebView()
            loadLocalHTML()
        }
       
    }
    
    private func loadLocalHTML() {
        print("Attempting to load local HTML...")
 
        // Attempt to retrieve the file path
        if let filePath = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "html/vue/test-app/dist") {
            print("Found file at path: \(filePath)")

            let fileURL = URL(fileURLWithPath: filePath)
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
        } else {
            print("Failed to find file path for 'index.html' in 'html/dist'.")
            debugPrint("Bundle main resource path: \(Bundle.main.resourcePath ?? "No resource path found")")
            
            // Additional debug information
            if let resourcePath = Bundle.main.resourcePath {
                let url = URL(fileURLWithPath: resourcePath).appendingPathComponent("html/dist/index.html")
                print("Constructed URL to check: \(url.path)")
                
                let fileExists = FileManager.default.fileExists(atPath: url.path)
                print("File exists at constructed path: \(fileExists)")
            }
        }
    }

    private func injectJavaScriptValue() {
        let script = "injectValue('\(userInput)');"
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("JavaScript evaluation error: \(error.localizedDescription)")
            } else {
                print("JavaScript function executed successfully.")
            }
        }
    }
    private func injectVueValue() {
        let script = "injectVueValue('\(userInput)');"
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("JavaScript evaluation error: \(error.localizedDescription)")
            } else {
                print("JavaScript function executed successfully.")
            }
        }
    }
    
    private func setupWebView() {
          let contentController = webView.configuration.userContentController
          contentController.add(MessageHandler(handler: handleMessage), name: "buttonClicked")
      }
    
    
    private func handleMessage(_ message: WKScriptMessage) {
         if let input = message.body as? String {
             self.message = input
         }
     }
    
    
}

class MessageHandler: NSObject, WKScriptMessageHandler {
    let handler: (WKScriptMessage) -> Void
    
    init(handler: @escaping (WKScriptMessage) -> Void) {
        self.handler = handler
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handler(message)
    }
}

struct WebView: UIViewRepresentable {
    var webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No additional code needed; the web view updates automatically
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
