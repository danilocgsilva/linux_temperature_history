import sys
from database_data.table_data import get_table_name

def main():
    input_data = []
    for line in sys.stdin:
        striped_line = line.strip()
        input_data.append(
            generate_insert(striped_line)
        )

    result = "\n".join(input_data)

    print(result)

def generate_insert(line: str):
    insert_script = "INSERT INTO " + get_table_name() + " ("  ") "
    return line + " with esteroids 2"

def get_core(line: str):
    return line.split(':')[0].strip().replace(" ", "_").replace("-", "_").lower()

if __name__ == "__main__":
    main()
