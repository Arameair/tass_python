#!/bin/bash

# system_setup.sh

# Check if system_log.py exists
if [ ! -f "system_log.py" ]; then
    # Create system_log.py
    cat > system_log.py << EOF
import os
import sys
import uuid
from datetime import datetime

def log_action(intent, action):
    # Generate a unique ID for this action
    action_id = uuid.uuid4()

    # Get the current date and time
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Create the log entry
    log_entry = f"{timestamp} | {action_id} | {intent} | {action}\n"

    # Write the log entry to the log file
    with open('system.log', 'a') as log_file:
        log_file.write(log_entry)

if __name__ == "__main__":
    # Get the intent and action from the command line arguments
    intent = sys.argv[1]
    action = sys.argv[2]

    # Log the action
    log_action(intent, action)
EOF
fi

# Check if setup.sh exists and is executable
if [ -f "setup.sh" ]; then
    chmod +x setup.sh
else
    echo "setup.sh does not exist. Please create it and try again."
    exit 1
fi

# Run setup.sh
./setup.sh
