module app;

import include.vector3d;
import std.stdio;

void main() {
    vector3d!float test;
    test.invert();
    test += vector3d!float(1, 2, 3) + [1, 2, 3] + 5;
    test *= [1, 2, 3];
    test = test + 1;
    test = test + [1, 1, 1];
    writeln(test);
}
