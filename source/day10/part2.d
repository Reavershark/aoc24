module day10.part2;

import std.algorithm : map, sum;
import std.conv : to;
import std.range : enumerate;
import std.stdio : stdin, writeln;
import std.uni : isNumber;

void solve()
{
    struct Vec2
    {
        long x, y;

        typeof(this) opBinary(string op)(const typeof(this) rhs) const
        {
            return typeof(this)(
                mixin("x" ~ op ~ "rhs.x"),
                mixin("y" ~ op ~ "rhs.y"),
            );
        }

        typeof(this) opOpAssign(string op)(const typeof(this) rhs)
        {
            x = mixin("x" ~ op ~ "rhs.x");
            y = mixin("y" ~ op ~ "rhs.y");
            return this;
        }
    }

    enum Vec2[4] directions = [
        Vec2(1, 0),
        Vec2(0, 1),
        Vec2(-1, 0),
        Vec2(0, -1),
    ];

    bool[Vec2][10] map;
    foreach (y, char[] line; stdin.byLine.enumerate)
        foreach (x, dchar c; line)
            if (c.isNumber)
                map[[c].to!long][Vec2(x, y)] = true;

    long[Vec2] currLayer, nextLayer;
    for (size_t level = 9; level > 0; level--)
    {
        if (level == 9)
            foreach (Vec2 pos; map[level].byKey)
                currLayer[pos] = 1;
        foreach (Vec2 pos, long score; currLayer)
            foreach (Vec2 dir; directions)
            {
                Vec2 adjacent = pos + dir;
                size_t nextLevel = level - 1;
                if (adjacent in map[nextLevel])
                    nextLayer[adjacent] += score;
            }
        currLayer = nextLayer;
        nextLayer = null;
    }

    currLayer
        .byValue
        .sum
        .writeln;
}