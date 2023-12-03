const std = @import("std");
const expect = std.testing.expect;
const input = @embedFile("input.txt");

test "scratch" {
    const example = 
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
        \\
   ;
    try scratch(example);
}

fn scratch(data: []const u8) !void {

    const slice = data[data.len - 1];
    std.debug.print("\nt:{}\n", .{slice});
}

pub fn main() !void {
    const example = 
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
        \\
   ;
    std.debug.print("a:'{}'", .{example[example.len - 1]});
    //const answer = try solution_part1(input);
    const answer = try solution_part2(input);
    std.debug.print("----------------\nanswer:{}\n", .{answer});
}

fn solution_part1(test_data: []const u8) !usize {

    var sum: usize = 0;

    var opt_first: ?u8 = null;
    var opt_second: ?u8 = null;

    for (test_data) |char| {
        switch (char) {
            '0'...'9' => {
                opt_first = opt_first orelse char;
                opt_second = char;
            },
            '\n' => {
                const num: [2]u8 = .{opt_first.?, opt_second.?};
                const value = try std.fmt.parseInt(usize, &num, 10);
                sum += value; 
                opt_first = null;
                opt_second = null;
            },
            else => {},
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
    
    const answer = try solution_part1(example);
    try expect(answer == 142);
}

fn solution_part2(test_data: []const u8) !usize {
    // const nums_by_length = 
   //     .{"one", "two", "six",
   //       "four", "five", "nine",
   //       "three","seven", "eight"};

    const Window = ?struct {
        initial_size: u8,
        next_step: ?u8 = null,
    };

    var offset: usize = 0;
    var sum: usize = 0;

    var opt_first: ?u8 = null;
    var opt_second: ?u8 = null;

    var it = std.mem.tokenizeScalar(u8, test_data, '\n');
    for (test_data) |_| {
        const char: u8 = test_data[offset];

        if(char == '\n'){
            std.debug.print("\nline:{s} offset:{}\n---\n", .{it.next().?, offset});
        }
        const opt_window: Window = switch (char) {
            'o' => .{ .initial_size=3}, //"one".len
            't' => .{ .initial_size=3, .next_step=2}, // "two", "three" overlap
            's' => .{ .initial_size=3, .next_step=2}, // "six", "seven" overlap
            'f' => .{ .initial_size=4}, // "five|four".len
            'n' => .{ .initial_size=4}, // "nine".len
            'e' => .{.initial_size=5}, // "eight".len
            else => null,
        };

        switch (char) {
            '0'...'9' => {
                std.debug.print("|'0'-'9'|:{}", .{char});
                opt_first = opt_first orelse char;
                opt_second = char;

                const v_1: [1]u8 = .{opt_first.?};
                const v_2: [1]u8 = .{opt_second.?};
                const value_1 = try std.fmt.parseInt(usize, &v_1, 10);
                const value_2 = try std.fmt.parseInt(usize, &v_2, 10);
                std.debug.print("({}|{})", .{value_1, value_2});

                offset += 1;
            }, 
            'o','t', 's', 'f','n','e' => {
                std.debug.print("|sp|:{}", .{char});
                const start = offset;
                const end = start + opt_window.?.initial_size;
                std.debug.print("|s:{} e:{} of:{}|", .{start, end, offset});

                var found = false;
                const window_slice = test_data[start..end];
                std.debug.print("|win:{s}|", .{window_slice});

                switch (char) {
                    'o' => {
                        if (std.mem.eql(u8, window_slice, "one"))
                        {
                            opt_first = opt_first orelse '1';
                            opt_second = '1';
                            offset += 3;
                            found = true;
                        }
                    },
                    't' => {
                        if (std.mem.eql(u8, window_slice, "two"))
                        {
                            opt_first = opt_first orelse '2';
                            opt_second = '2';
                            offset += 3;
                            found = true;
                        } else {
                            // create new window with + step len
                            const advance = end + opt_window.?.next_step.?;
                                const win_next = test_data[start..advance];
                                if (std.mem.eql(u8, win_next, "three")){
                                    opt_first = opt_first orelse '3';
                                    opt_second = '3';
                                    offset += 5;
                                    found = true;
                                }
                        }
                    },
                    's' => {
                        if (std.mem.eql(u8, window_slice, "six")) {
                            opt_first = opt_first orelse '6';
                            opt_second = '6';
                            offset += 3;
                            found = true;
                        } else {
                            const advance = end + opt_window.?.next_step.?;
                                const win_next = test_data[start..advance];
                                if (std.mem.eql(u8, win_next, "seven")){
                                    opt_first = opt_first orelse '7';
                                    opt_second = '7';
                                    offset += 5;
                                    found = true;
                                }
                        }
                    },
                    'f' => {
                        if (std.mem.eql(u8, window_slice, "four")) {
                            opt_first = opt_first orelse '4';
                            opt_second = '4';
                            offset += 4;
                            found = true;
                        } else if (std.mem.eql(u8, window_slice, "five")) {
                            opt_first = opt_first orelse '5';
                            opt_second = '5';
                            offset += 4;
                            found = true;
                        }
                    },
                    'n' => {
                        if (std.mem.eql(u8, window_slice, "nine")) {
                            opt_first = opt_first orelse '9';
                            opt_second = '9';
                            offset += 4;
                            found = true;
                        }
                    },
                    'e' => {
                        if (std.mem.eql(u8, window_slice, "eight")) {
                            opt_first = opt_first orelse '8';
                            opt_second = '8';
                            offset += 5;
                            found = true;
                        }
                    },
                    else => unreachable,
                }
                const v_1: [1]u8 = .{opt_first.?};
                const v_2: [1]u8 = .{opt_second.?};
                const value_1 = try std.fmt.parseInt(usize, &v_1, 10);
                const value_2 = try std.fmt.parseInt(usize, &v_2, 10);
                std.debug.print("({}|{})", .{value_1, value_2});

                offset += if (found) 0 else 1;
            },
            '\n' => {
                const num: [2]u8 = .{opt_first.?, opt_second.?};
                const value = try std.fmt.parseInt(usize, &num, 10);
                sum += value;
                opt_first = null;
                opt_second = null;
                offset += 1;
                std.debug.print("\nval:{} num:{any} sum:{}\n", .{value, num, sum});
            },
            '?' => {
                std.debug.print("\n\n\n++++++++++++++++++++THIS IS IT:{}\n\n\n", .{sum});
                break;
            },
            else => {
                std.debug.print("'{}'", .{char});
                offset += 1;
            },
        }

        std.debug.print("\nend loop: offset:{}\n", .{offset});
    }

    return sum;
}


test "second example" {
    const example = 
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
        \\
   ;

    const answer = try solution_part2(example);
    std.debug.print("\nanswer:{}", .{answer});
    try expect(answer == 281);
}

