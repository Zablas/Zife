const std = @import("std");
const grid = @import("grid.zig");
const utils = @import("utils");

pub const Simulation = struct {
    sim_grid: grid.Grid,
    temp_grid: grid.Grid,
    allocator: std.mem.Allocator,
    width: i32,
    height: i32,
    cell_size: i32,

    pub fn init(allocator: std.mem.Allocator, width: i32, height: i32, cell_size: i32) !Simulation {
        return Simulation{
            .sim_grid = try grid.Grid.init(allocator, width, height, cell_size),
            .temp_grid = try grid.Grid.init(allocator, width, height, cell_size),
            .allocator = allocator,
            .width = width,
            .height = height,
            .cell_size = cell_size,
        };
    }

    pub fn draw(self: Simulation) void {
        self.sim_grid.draw();
    }

    pub fn update(self: *Simulation) !void {
        for (self.sim_grid.cells.items, 0..) |row, i| {
            for (row.items, 0..) |cell, j| {
                const aliveNeighbours = self.countAliveNeighbours(@intCast(i), @intCast(j));

                if (cell == 1) {
                    if (aliveNeighbours > 3 or aliveNeighbours < 2) {
                        try self.temp_grid.setValue(@intCast(i), @intCast(j), 0);
                    } else {
                        try self.temp_grid.setValue(@intCast(i), @intCast(j), 1);
                    }
                } else {
                    if (aliveNeighbours == 3) {
                        try self.temp_grid.setValue(@intCast(i), @intCast(j), 1);
                    } else {
                        try self.temp_grid.setValue(@intCast(i), @intCast(j), 0);
                    }
                }
            }
        }

        self.sim_grid.deinit();
        self.sim_grid = self.temp_grid;
        self.temp_grid = try grid.Grid.init(self.allocator, self.width, self.height, self.cell_size);
    }

    pub fn setCellValue(self: *Simulation, row: i32, column: i32, value: i32) !void {
        try self.sim_grid.setValue(row, column, value);
    }

    pub fn deinit(self: *Simulation) void {
        self.sim_grid.deinit();
        self.temp_grid.deinit();
    }

    pub fn countAliveNeighbours(self: *Simulation, row: i32, column: i32) i32 {
        var aliveNeighbours: i32 = 0;

        const offsets = [8]utils.Pair(i32){
            .{ .first = -1, .second = 0 },
            .{ .first = 1, .second = 0 },
            .{ .first = 0, .second = -1 },
            .{ .first = 0, .second = 1 },
            .{ .first = -1, .second = -1 },
            .{ .first = -1, .second = 1 },
            .{ .first = 1, .second = -1 },
            .{ .first = 1, .second = 1 },
        };

        for (offsets) |offset| {
            const neighborRow = @mod(row + offset.first + self.sim_grid.rows, self.sim_grid.rows);
            const neighborColumn = @mod(column + offset.second + self.sim_grid.columns, self.sim_grid.columns);

            aliveNeighbours += self.sim_grid.getValue(neighborRow, neighborColumn) catch 0;
        }

        return aliveNeighbours;
    }
};
