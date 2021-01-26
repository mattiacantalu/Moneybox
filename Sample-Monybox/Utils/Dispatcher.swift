import Foundation

protocol Dispatcher {
    func dispatch(deadline: DispatchTime,
                  callback: @escaping () -> Void)
    func dispatch(callback: @escaping () -> Void)
}

struct DefaultDispatcher: Dispatcher {
    init() {}

    func dispatch(deadline: DispatchTime = DispatchTime.now(),
                         callback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            callback()
        }
    }

    func dispatch(callback: @escaping () -> Void) {
        DispatchQueue.main.async {
            callback()
        }
    }
}

struct SyncDispatcher: Dispatcher {
    init() {}

    func dispatch(deadline: DispatchTime = DispatchTime.now(),
                         callback: @escaping () -> Void) {
        callback()
    }

    func dispatch(callback: @escaping () -> Void) {
        callback()
    }
}
