import sys

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
        fields_list.append(core_name + " string")

    return 'create table log(date_string string, ' + ', '.join(fields_list) + ');'

def get_core_name(line: str) -> str:
    return line.split(':')[0].strip().replace(" ", "_").replace("-", "_").lower()

if __name__ == "__main__":
    main()
