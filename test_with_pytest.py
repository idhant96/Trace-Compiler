import os
from lexical import tokenrules
from execute import main

def test_always_passes():
    res = main()
    print(res)
    assert res == [0]
