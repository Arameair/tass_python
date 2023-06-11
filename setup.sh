#!/bin/bash

# setup.sh

# Check if Python is installed
if ! command -v python3 &> /dev/null
then
    echo "Python is not installed. Please install Python and try again."
    exit 1
fi

# Check if venv is installed
python3 -c "import venv" &> /dev/null
if [ $? -ne 0 ]; then
    echo "venv is not installed. Please install the venv module and try again."
    exit 1
fi

# Create a Python virtual environment
if [ ! -d "env" ]; then
    python3 -m venv env
fi

# Create setup.py if it doesn't exist
if [ ! -f "setup.py" ]; then
    cat > setup.py << EOF
import os
import shutil
import subprocess
import argparse

class SystemSetup:
    def __init__(self):
        if not os.path.exists('env'):
            subprocess.run(['python3', '-m', 'venv', 'env'])

    def run_in_venv(self, script, *args):
        subprocess.run(['env/bin/python3', script] + list(map(str, args)))

    def create_directory(self, directory):
        os.makedirs(directory, exist_ok=True)
        self.run_in_venv('system_log.py', 'Create directory', directory)

    def create_file(self, file):
        open(file, 'a').close()
        self.run_in_venv('system_log.py', 'Create file', file)

    def move_file(self, file, directory):
        shutil.move(file, directory)
        self.run_in_venv('system_log.py', 'Move file', f'{file} to {directory}')

if __name__ == "__main__":
    system_setup = SystemSetup()

    parser = argparse.ArgumentParser(description='System setup script.')
    subparsers = parser.add_subparsers(dest='command')

    parser_create_dir = subparsers.add_parser('create-dir', help='Create a new directory.')
    parser_create_dir.add_argument('directory', help='The name of the directory to create.')

    parser_create_file = subparsers.add_parser('create-file', help='Create a new file.')
    parser_create_file.add_argument('file', help='The name of the file to create.')

    parser_move_file = subparsers.add_parser('move-file', help='Move a file.')
    parser_move_file.add_argument('file', help='The name of the file to move.')
    parser_move_file.add_argument('directory', help='The name of the directory to move the file to.')

    args = parser.parse_args()

    if args.command == 'create-dir':
        system_setup.create_directory(args.directory)
    elif args.command == 'create-file':
        system_setup.create_file(args.file)
    elif args.command == 'move-file':
        system_setup.move_file(args.file, args.directory)
EOF
fi

# Run setup.py in the virtual environment
source env/bin/activate
python3 setup.py
deactivate
