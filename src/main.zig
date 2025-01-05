const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const colors = constants.colors;
const grid_params = constants.grid_params;

pub fn main() !void {
    rl.initWindow(grid_params.window_width, grid_params.window_height, "Zife");
    defer rl.closeWindow();

    rl.setTargetFPS(12);
    rl.setExitKey(rl.KeyboardKey.null);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    var grid = try entities.grid.Grid.init(
        allocator,
        grid_params.window_width,
        grid_params.window_height,
        grid_params.cell_size,
    );
    defer grid.deinit();

    grid.setValue(0, 0, 1);
    grid.setValue(2, 1, 1);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.grey);
        grid.draw();
    }
}
