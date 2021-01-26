extension Swift.Optional {
    func fold<T>(some: (Wrapped) -> T, none: () -> T) -> T {
        guard let unwrapped = self else {
            return none()
        }
        return some(unwrapped)
    }
}
