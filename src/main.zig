const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const colors = constants.colors;
const grid_params = constants.grid_params;

pub fn main() !void {
    rl.initWindow(grid_params.window_width, grid_params.window_height, "Zife: stopped...");
    defer rl.closeWindow();

    var fps: i32 = 12;

    rl.setTargetFPS(fps);
    rl.setExitKey(rl.KeyboardKey.null);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    var simulation = try entities.Simulation.init(
        allocator,
        grid_params.window_width,
        grid_params.window_height,
        grid_params.cell_size,
    );
    defer simulation.deinit();

    while (!rl.windowShouldClose()) {
        handleUserInput(&simulation, &fps);

        try simulation.update();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.grey);
        simulation.draw();
    }
}

fn handleUserInput(simulation: *entities.Simulation, fps: *i32) void {
    if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
        simulation.is_running = true;
        rl.setWindowTitle("Zife: running...");
    } else if (rl.isKeyPressed(rl.KeyboardKey.space)) {
        simulation.is_running = false;
        rl.setWindowTitle("Zife: stopped...");
    } else if (rl.isKeyPressed(rl.KeyboardKey.f)) {
        fps.* += 2;
        rl.setTargetFPS(fps.*);
    } else if (rl.isKeyPressed(rl.KeyboardKey.s) and fps.* > 5) {
        fps.* -= 2;
        rl.setTargetFPS(fps.*);
    }
}
