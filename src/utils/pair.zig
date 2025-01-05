pub fn Pair(comptime T: type) type {
    return struct {
        first: T,
        second: T,
    };
}
