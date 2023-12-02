const std = @import("std");
const expect = std.testing.expect;
const input = @embedFile("input.txt");


pub fn main() !void {
    const answer = try solution(input);
    std.debug.print("sum:{}\n", .{answer});
}

fn solution(test_data: []const u8) !usize {

    var iter = std.mem.tokenizeSequence(u8, test_data, "\n");

    var sum: usize = 0;
    while(iter.next()) |line| {

        var first: u8 = undefined;
        for (line) |char| {
            switch (char) {
                '0'...'9' => {
                    first = char;
                    break;
                },
                else => {},
            }
        }

        var second: u8 = undefined;
        var i: usize = line.len;
        while (i > 0) {
            i -= 1;
            switch (line[i]) {
                '0'...'9' => {
                    second = line[i];
                    break;
                },
                else => {},
            }
        }

        const final: [2]u8 = .{first, second};
        const partial = try std.fmt.parseInt(usize, &final, 10);
        sum += partial;

        // std.debug.print("---\nline:{s}\n", .{line});
        // std.debug.print("final:{}, sum:{}\n", .{partial, sum});
    }
    std.debug.print("sum:{}\n", .{sum});
    return sum;
}

test "first example" {
    const example = 
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    
    const answer = try solution(example);
    try expect(answer == 142);
}
