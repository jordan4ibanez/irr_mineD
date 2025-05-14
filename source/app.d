module app;

import include.vector3d;
import std.stdio;

void main() {
    vector3d!float test;
    test += vector3d!float(1, 2, 3);
    test *= [1, 2, 3];
    test += 5;
    writeln(test);
}
