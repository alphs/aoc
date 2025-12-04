const std = @import("std");
const expect = std.testing.expect;
const input = @embedFile("input.txt");

const List = std.ArrayList;


pub fn main() !void {

    const answer = try solution_2(input);
    std.debug.print("answer:{}\n", .{answer});
    //try expect(answer == 13);
}

fn solution_2(data: []const u8) !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var list = std.ArrayList(usize).init(allocator); 
    defer list.deinit();

    const Card = struct{
        card_number: u32,
        winning_numbers: u32,
    };
    var cards = std.ArrayList(Card).init(allocator); 
    defer cards.deinit();

    var it = std.mem.tokenizeAny(u8, data, ":|\n");
    while (it.next()) |card_slice| {
        var winning_numbers = std.mem.tokenizeScalar(u8, it.next().?, ' ');
        var scratch_numbers = std.mem.tokenizeScalar(u8, it.next().?, ' ');

        defer list.clearRetainingCapacity();

        while (winning_numbers.next()) |num_char| {
            const num = try std.fmt.parseInt(u32, num_char, 10);
            try list.append(num);
        }

        var correct_numbers: u32 = 0;
        while (scratch_numbers.next()) |scratch_char| {

            const scratch = try std.fmt.parseInt(u32, scratch_char, 10);
            var found: bool = false;
            for (list.items) |win_num| {
                if (scratch == win_num) {
                    found = true;
                    break;
                }
            }
            correct_numbers += if (found) 1 else 0;
        }

        const card_end_char = card_slice[card_slice.len-1];
        const card_number = card_end_char - '0';
        const card: Card = .{
            .card_number = card_number,
            .winning_numbers = correct_numbers};

        try cards.append(card);
        std.debug.print("card:[n:{}, wn:{}]\n", .{card_number, correct_numbers});
        std.debug.print("---\n", .{});
    }

    var agg = List(u32).init(allocator);
    defer agg.deinit();
    for (cards.items) |c| {
        try agg.append(1);
        if (c.winning_numbers == 0) {
            std.debug.print("empty: card {}\n", .{c.card_number});
        }
    }
    std.debug.print("agg:{any}", .{agg});

    for (cards.items) |card| {
        const card_number = card.card_number;
        const won_cards = card.winning_numbers;
        std.debug.print("\na({}:{})\n", .{card_number, won_cards});

        if (won_cards <= 0) {
            continue;
        }

        const a = card_number + 1;
        const b = card_number + won_cards;
        const prev = agg.items[card_number];
        for (a..b+1) |i| {
            const curr = agg.items[i];
            agg.items[i] += 1 * prev;
            std.debug.print("|i:{},agg:{},curr:{},prev:{}\n", 
                .{i, agg.items[i], curr, prev});
        }
        std.debug.print("---\n", .{});
    }

    var total: u32 = 0; 
    for (agg.items) |a| {
        total += a;
    }
    //for (cards.items) |card| {
    //    if (card.winning_numbers > 0) {
    //        total += 1;
    //    }
    //}
    return total;
}

test "part 2" {
    const example = 
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        \\
        ;

    const answer = try solution_2(example);
    try expect(answer == 30);
}

test "part 1" {
    const example = 
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        \\
        ;

    const answer = try solution_1(example);
    try expect(answer == 13);

}
fn solution_1(data: []const u8) !usize {

    //var scoreboard = AutoMap([]const u8, Scores).init(testing_allocator);
    //defer scoreboard.deinit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var list = std.ArrayList(usize).init(allocator); 
    defer list.deinit();

    var sum: u32 = 0;
    var it = std.mem.tokenizeAny(u8, data, ":|\n");
    while (it.next()) |line| {

        defer list.clearRetainingCapacity();

        //_ = line; // skip "Card x", don't care for now
        std.debug.print("line:{s}\n", .{line});
                

        var winning_numbers = std.mem.tokenizeScalar(u8, it.next().?, ' ');

        var correct_numbers: u32 = 0;

        std.debug.print("n:", .{});
        while (winning_numbers.next()) |num_char| {
            const num = try std.fmt.parseInt(u32, num_char, 10);
            std.debug.print("{},", .{num});
            try list.append(num);
        }
        std.debug.print("\n", .{});

        var scratch_numbers = std.mem.tokenizeScalar(u8, it.next().?, ' ');
        while (scratch_numbers.next()) |scratch_char| {

            const scratch = try std.fmt.parseInt(u32, scratch_char, 10);

            var found: bool = false;
            for (list.items) |win_num| {
                if (scratch == win_num) {
                    found = true;
                    break;
                }
            }
            std.debug.print("(s:{} f:{})", .{scratch, found});

            correct_numbers += if (found) 1 else 0;
        }
        std.debug.print("\n", .{});
        // 1, 2, 4 .. n
        // 2^(x-1)
        // 1 << x-1
        //var line_score: u32 = 1;
        //for (0..line_score-1) |_| {
            //result *= 2;
        //}

        if (correct_numbers != 0) {
            const val = try std.math.powi(u32, 2, correct_numbers-1);
            sum += val;
            std.debug.print("val:{}\n", .{val});
        }
        else {
            std.debug.print("+++ was empty", .{});
        }
        std.debug.print("\n---", .{});
    }

    return sum;
}

