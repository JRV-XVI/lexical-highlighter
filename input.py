# This is a single-line comment

import math
from random import randint 

dic = {

}

lol = [

]

# Keywords and identifiers

def function_name(param1, param2=123):
    my_variable = "hello"
    _privateVar = f"formatted {param1}"
    another_var = 4567
    complex_num = 5j
    flag = True
    nothing = None
    if my_variable and another_var > 10:
        result = param1 + param2
        print("Result:", result)
    elif param2 < 100:
        while param2 != 0:
            param2 -= 1
            continue
    else:
        pass

    try:
        raise ValueError("Just a test")
    except Exception as e:
        print(e)
    finally:
        return result


class ClassName:
    def __init__(self, value):
        self.value = value

    def compute(self):
        for i in range(5):
            self.value **= 2
            if self.value in [1, 4, 16]:
                break
            elif self.value not in (0, 2, 3):
                self.value //= 2

    def __str__(self):
        return f"Value is {self.value}"


def logic_operations(a, b):
    x = a and b or not a
    y = a == b
    z = a is b
    w = a is not b
    m = a & b
    n = a | b
    o = ~a
    p = a ^ b
    q = a << 2
    r = b >> 1
    s = 1 <= a <= 100
    t = a >= b
    return x, y, z, w, m, n, o, p, q, r, s, t


# Punctuation test
print("Done. See you soon:")
print()