module app;

import include.vector3d;
import std.stdio;

void main() {
    vector3df test = vector3df(1, 1, 1);
    test.setLength(20);
    writeln(test);
}
