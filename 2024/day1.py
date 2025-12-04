#!/usr/bin/env python3


def solution_1():
    arr = None
    with open("./input.txt") as f:
        arr = f.readlines()
    assert arr is not None

    col_1 = []
    col_2 = []

    for line in arr:
        tup = line.split("   ")
        assert 2 == len(tup)
        first, second = tup
        col_1.append(first.strip())
        col_2.append(second.strip())

    sorted_1 = sorted(col_1)
    sorted_2 = sorted(col_2)

    sum = 0
    for a, b in zip(sorted_1, sorted_2):
        sum += abs(int(a) - int(b))

    print(sum)


def solution_2():
    arr = None
    with open("./input.txt") as f:
        arr = f.readlines()
    assert arr is not None

    col_1 = []
    col_2 = []

    for line in arr:
        tup = line.split("   ")
        assert 2 == len(tup)
        first, second = tup
        col_1.append(int(first.strip()))
        col_2.append(int(second.strip()))

    sorted_1 = sorted(col_1)
    sorted_2 = sorted(col_2)

    sum = 0
    for a, _ in zip(sorted_1, sorted_2):
        c = sorted_2.count(a)
        num = int(a) * c
        sum += num
        print(f"{sum} += {a} * {c}")

    print(sum)


def main():
    input_test = """3   4
4   3
2   5
1   3
3   9
3   3"""

    arr = input_test.splitlines()

    col_1 = []
    col_2 = []

    for line in arr:
        tup = line.split("   ")
        assert 2 == len(tup)
        first, second = tup
        col_1.append(first)
        col_2.append(second)

    sorted_1 = sorted(col_1)
    sorted_2 = sorted(col_2)

    sum = 0
    for a, b in zip(sorted_1, sorted_2):
        sum += abs(int(a) - int(b))

    print(sum)


if __name__ == "__main__":
    print(f"main:")
    main()
    print(f"solution 1:")
    solution_1()

    print(f"solution 2:")
    solution_2()
