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
    writeln(a > b);
    writeln(a > a);

    b = a;
    b += a;
    b = b - a;
    writeln(b == a);
    b += [1, 2];
    writeln(b[0] + 10000);
    writeln(b > a);
    writeln(b > b);

    writeln(b);
    writeln(a);

}
