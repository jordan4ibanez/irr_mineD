module app;

import include.dimension_2d;
import include.vector2d;
import include.vector3d;
import std.stdio;

void main() {
    vector2df a;
    dimension2df b;
    a.X = 5;
    b.Width = 10;

    a = b;
    a += b;
    a = a * b;
    writeln(a == b);

    b = a;
    b += a;
    b = b - a;
    writeln(b == a);
    b += [1, 2];
    writeln(b[0] + 1);

    writeln(a);

}
