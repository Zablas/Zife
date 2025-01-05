const std = @import("std");
const grid = @import("grid.zig");
const utils = @import("utils");

pub const Simulation = struct {
    sim_grid: grid.Grid,

    pub fn init(allocator: std.mem.Allocator, width: i32, height: i32, cell_size: i32) !Simulation {
        return Simulation{
            .sim_grid = try grid.Grid.init(allocator, width, height, cell_size),
        };
    }

    pub fn draw(self: Simulation) void {
        self.sim_grid.draw();
    }

    pub fn setCellValue(self: *Simulation, row: i32, column: i32, value: i32) !void {
        try self.sim_grid.setValue(row, column, value);
    }

    pub fn deinit(self: *Simulation) void {
        self.sim_grid.deinit();
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
