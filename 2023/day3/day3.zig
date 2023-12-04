const std = @import("std");
const input = @embedFile("input.txt");
const ArrayList = std.ArrayList;

fn main() !void{
    const example = 
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
        \\
    ;

    const answer = try solution_1(example);
    std.debug.print("answer:{}", .{answer});
}

const PotenialPart = struct{
    start: usize,
    end: usize,
    number: usize,
};
fn solution_1(test_data: []const u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    var list = ArrayList(PotenialPart).init(allocator);
    defer list.deinit();

    var sum: usize = 0;


    var it = std.mem.tokenizeScalar(test_data, '\n');
    for (it.next()) |line| {
        var num = ArrayList(u8).init(allocator);
        defer num.deinit();

        var parse_num_it = std.mem.tokenizeAny(line, "0123456789");
        for (parse_num_it.next()) |char| {
            num.append(char);
        }

        


        _ = sum;


    }

    return 0;
}
