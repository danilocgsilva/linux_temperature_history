import sys
from table_data import get_table_name

def main():
    input_data = []
    for line in sys.stdin:
        input_data.append(line.strip())

    result = generate_script(input_data)

    print(result)

def generate_script(lines: list):
    fields_list = []
    for line in lines:
        core_name = get_core_name(line)
        fields_list.append(core_name + " STRING")

    return 'create table ' + get_table_name() + '(id INTEGER PRIMARY KEY, date_string STRING, ' + ', '.join(fields_list) + ');'

def get_core_name(line: str) -> str:
    return line.split(':')[0].strip().replace(" ", "_").replace("-", "_").lower()

if __name__ == "__main__":
    main()
