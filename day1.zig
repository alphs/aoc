const std = @import("std");
const expect = std.testing.expect;
const input = @embedFile("input.txt");


pub fn main() !void {
    const answer = try solution(input);
    std.debug.print("----------------\nsum:{}\n", .{answer});
}

fn solution(test_data: []const u8) !usize {

    var sum: usize = 0;

    var opt_first: ?u8 = null;
    var opt_second: ?u8 = null;

    var it = std.mem.tokenizeScalar(u8, test_data, '\n');
    for (test_data) |char| {
        if(char == '\n'){
            std.debug.print("\n---\nline:{s}\n", .{it.next().?});
        }
        switch (char) {
            '0'...'9' => {
                opt_first = opt_first orelse char;
                opt_second = char;
                std.debug.print("({any}|{any})", .{opt_first, opt_second});
            },
            '\n' => {
                const num: [2]u8 = .{opt_first.?, opt_second.?};
                const value = try std.fmt.parseInt(usize, &num, 10);
                sum += value; 
                std.debug.print("val:{} num:{any}\n", .{value, num});
                opt_first = null;
                opt_second = null;
            },
            else => {std.debug.print("'{}'", .{char});},
        }
    }
    return sum;
 }

test "first example" {
    const example = 
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
        \\
    ;
    
    const answer = try solution(example);
    try expect(answer == 142);
}

