import SwiftUI

func ListApps() -> [NSRunningApplication]
{
    let workspace = NSWorkspace.shared
    let applications = workspace.runningApplications
    return applications.reversed()
}

class AppsContainer : ObservableObject{

    @Published var apps = ListApps()
    let center = NSWorkspace.shared.notificationCenter
    
    init ()
    {
        print("Init called")
        center.addObserver(forName: NSWorkspace.didLaunchApplicationNotification,
                            object: nil,
                             queue: OperationQueue.main)
        {
            (notification: Notification)
            in if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
                {
                    if let name = (app.bundleIdentifier)
                    {
                        print(name,"-------------------------------------------opened")
                    }
                }
            self.apps = ListApps()
        }
        
        center.addObserver(forName: NSWorkspace.didTerminateApplicationNotification,
                            object: nil,
                             queue: OperationQueue.main)
        {
            (notification: Notification)
            in if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
                {
                    if let name = (app.bundleIdentifier)
                    {
                        print(name,"-------------------------------------------closed")
                    }
                }
            self.apps = ListApps()
        }
    }
    
    func terminate(app:NSRunningApplication)
    {
        print(app.localizedName!)
        app.terminate()
    }
}



struct ContentView: View
{
    @ObservedObject var Container = AppsContainer()
    
    
    var body: some View {
        VStack{
            List{
                ForEach(Container.apps, id: \.self){app in
                            HStack{
                                if let name = (app.localizedName){
                                    Text(name);
                                }
                                Spacer()
                                Button(action: {
                                    app.terminate()
                                }){
                                    Text("Terminate")
                                }
                            }
                        }
            }
        }
    }
 
}



struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
