import os

def is_numeric(name):
    try:
        float(name)
        return True
    except ValueError:
        return False

for item in os.listdir('.'):
    if os.path.isdir(item) and is_numeric(item):
        os.rmdir(item)
