const std = @import("std");
const expect = std.testing.expect;
const input = @embedFile("input.txt");

pub fn main() !void {
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

const FileError = error {
    Eof,
};

fn getSafeSlice(data: []const u8, start:usize, end:usize) ![]const u8 {
    return if (end < data.len) data[start..end] 
        else FileError.Eof;
}

const Window = ?struct {
    initial_size: u8,
    next_step: ?u8 = null,
};

const look_up = std.ComptimeStringMap(u8, .{
    .{'1', "one"},
    .{'2', "two"},
    .{'3', "three"},
    .{'4', "four"},
    .{'5', "five"},
    .{'6', "six"},
    .{'7', "seven"},
    .{'8', "eight"},
    .{'9', "nine"},
});

fn checkWindow(window: Window, slice: []const u8, char: u8) ?u8 {

    const opt_found_char = if (std.mem.eql(u8, slice, look_up.get(char))) char
        else null;

    if (opt_found_char) |found_ch| {

        offset += window.initial_size - 1; // -1 to detect overlapping "number words"
    }

    return opt_found_char 
}

fn solution_part2(test_data: []const u8) !usize {

    var offset: usize = 0;
    var sum: usize = 0;

    var opt_first: ?u8 = null;
    var opt_second: ?u8 = null;
    for (test_data) |_| {
        const char: u8 = if(offset < test_data.len) // check for eof
            test_data[offset] else '\n';

        const opt_window: Window = switch (char) {
            'o' => .{ .initial_size=3}, //"one".len
            't' => .{ .initial_size=3, .next_step=2}, // "two", "three" overlap
            's' => .{ .initial_size=3, .next_step=2}, // "six", "seven" overlap
            'f' => .{ .initial_size=4}, // "five|four".len
            'n' => .{ .initial_size=4}, // "nine".len
            'e' => .{ .initial_size=5}, // "eight".len
            else => null,
        };

        switch (char) {
            '0'...'9' => {
                opt_first = opt_first orelse char;
                opt_second = char;

                offset += 1;
            }, 
            'o','t', 's', 'f','n','e' => {
                const start = offset;
                const end = start + opt_window.?.initial_size;

                var found = false;
                const window_slice = getSafeSlice(test_data, start, end) catch {
                    offset += 1;
                    continue;
                };

                switch (char) {
                    'o' => {
                        if (std.mem.eql(u8, window_slice, "one"))
                        {
                            opt_first = opt_first orelse '1';
                            opt_second = '1';
                            offset += 3 - 1;
                            found = true;
                        }
                    },
                    't' => {
                        if (std.mem.eql(u8, window_slice, "two"))
                        {
                            opt_first = opt_first orelse '2';
                            opt_second = '2';
                            offset += 3 - 1;
                            found = true;
                        } else {
                            // create new window with + step len
                            const advance = end + opt_window.?.next_step.?;
                            const win_next = getSafeSlice(test_data, start, advance) catch {
                                offset += 1;
                                continue;
                            };
                                if (std.mem.eql(u8, win_next, "three")){
                                    opt_first = opt_first orelse '3';
                                    opt_second = '3';
                                    offset += 5 - 1;
                                    found = true;
                                }
                        }
                    },
                    's' => {
                        if (std.mem.eql(u8, window_slice, "six")) {
                            opt_first = opt_first orelse '6';
                            opt_second = '6';
                            offset += 3 - 1;
                            found = true;
                        } else {
                            const advance = end + opt_window.?.next_step.?;
                            const win_next = getSafeSlice(test_data, start, advance) catch {
                                offset += 1;
                                continue;
                            };
                                if (std.mem.eql(u8, win_next, "seven")){
                                    opt_first = opt_first orelse '7';
                                    opt_second = '7';
                                    offset += 5 - 1;
                                    found = true;
                                }
                        }
                    },
                    'f' => {
                        if (std.mem.eql(u8, window_slice, "four")) {
                            opt_first = opt_first orelse '4';
                            opt_second = '4';
                            offset += 4 - 1;
                            found = true;
                        } else if (std.mem.eql(u8, window_slice, "five")) {
                            opt_first = opt_first orelse '5';
                            opt_second = '5';
                            offset += 4 - 1;
                            found = true;
                        }
                    },
                    'n' => {
                        if (std.mem.eql(u8, window_slice, "nine")) {
                            opt_first = opt_first orelse '9';
                            opt_second = '9';
                            offset += 4 - 1;
                            found = true;
                        }
                    },
                    'e' => {
                        if (std.mem.eql(u8, window_slice, "eight")) {
                            opt_first = opt_first orelse '8';
                            opt_second = '8';
                            offset += 5 - 1;
                            found = true;
                        }
                    },
                    else => unreachable,
                }

                offset += if (found) 0 else 1;
            },
            '\n' => {
                if (offset >= test_data.len){
                    break;
                }
                const num: [2]u8 = .{opt_first.?, opt_second.?};
                const value = try std.fmt.parseInt(usize, &num, 10);
                sum += value;
                opt_first = null;
                opt_second = null;
                offset += 1;
            },
            else => {
                offset += 1;
            },
        }
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

