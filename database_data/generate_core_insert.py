import sys
from table_data import get_table_name

def main():
    for line in sys.stdin:
        string_to_return = "INSERT INTO buffer () VALUES ();"
        print(line.strip() + " " + string_to_return)

def get_core_name(line: str) -> str:
    return line.split(':')[0].strip().replace(" ", "_").replace("-", "_").lower()

if __name__ == "__main__":
    main()
