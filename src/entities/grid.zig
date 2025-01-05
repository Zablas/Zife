const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");

const colors = constants.colors;
const grid_params = constants.grid_params;

pub const Grid = struct {
    rows: i32,
    columns: i32,
    cell_size: i32,
    cells: std.ArrayList(std.ArrayList(i32)),

    pub fn init(allocator: std.mem.Allocator, width: i32, height: i32, cell_size: i32) !Grid {
        const rows = @divFloor(height, cell_size);
        const columns = @divFloor(width, cell_size);
        var cells = std.ArrayList(std.ArrayList(i32)).init(allocator);

        var i: usize = 0;
        while (i < rows) {
            var row = std.ArrayList(i32).init(allocator);
            try row.appendNTimes(0, @intCast(columns));
            try cells.append(row);
            i += 1;
        }

        return Grid{
            .rows = rows,
            .columns = columns,
            .cell_size = cell_size,
            .cells = cells,
        };
    }

    pub fn deinit(self: *Grid) void {
        var i: usize = 0;
        while (i < self.cells.items.len) {
            self.cells.items[i].deinit();
            i += 1;
        }
        self.cells.deinit();
    }

    pub fn draw(self: Grid) void {
        for (self.cells.items, 0..) |row, i| {
            for (row.items, 0..) |cell, j| {
                const color = if (cell > 0) colors.green else colors.light_grey;
                rl.drawRectangle(
                    @intCast(j * grid_params.cell_size),
                    @intCast(i * grid_params.cell_size),
                    grid_params.cell_size - 1,
                    grid_params.cell_size - 1,
                    color,
                );
            }
        }
    }

    pub fn setValue(self: *Grid, row: usize, column: usize, value: i32) void {
        if (row >= 0 and row < self.rows and column >= 0 and column < self.columns) {
            self.cells.items[row].items[column] = value;
        }
    }
};
