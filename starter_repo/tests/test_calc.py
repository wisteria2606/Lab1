from app.calc import add


def test_add_basic():
    assert add(2, 2) == 4


def test_add_zero():
    assert add(-1, 1) == 0

