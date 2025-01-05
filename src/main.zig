const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(750, 750, "Zife");
    defer rl.closeWindow();

    rl.setTargetFPS(12);
    rl.setExitKey(rl.KeyboardKey.null);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.grey);
    }
}
