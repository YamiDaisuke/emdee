import Foundation

public protocol FileWatcher: AnyObject {
    var onFileChanged: ((URL) -> Void)? { get set }
    var onFileAdded: ((URL) -> Void)? { get set }
    var onFileRemoved: ((URL) -> Void)? { get set }

    init(path: URL)
    func start()
    func stop()
}
