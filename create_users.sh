#!/bin/bash

# Log file
LOG_FILE="/var/log/user_management.log"
# Password file
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure the secure directory exists
mkdir -p /var/secure
# Ensure the log file exists
touch "$LOG_FILE"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Function to generate a random password
generate_password() {
    openssl rand -base64 12
}

# Ensure the password file has the correct permissions
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: bash create_users.sh <input_file>"
    exit 1
fi

input_file="$1"

# Read the input file line by line
while IFS=';' read -r username groups; do
    # Remove leading and trailing whitespaces
    username="$(echo -e "${username}" | tr -d '[:space:]')"
    groups="$(echo -e "${groups}" | tr -d '[:space:]' | tr ',' ' ')"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        log_message "User '$username' already exists, skipping."
        continue
    fi

    # Create user with a home directory
    useradd -m -s /bin/bash "$username" &>> "$LOG_FILE"
    if [ $? -ne 0 ]; then
        log_message "Failed to create user '$username'."
        continue
    fi
    log_message "Created user '$username'."

    # Create a personal group for the user
    groupadd "$username" &>> "$LOG_FILE"
    log_message "Created group '$username' for user '$username'."

    # Add the user to their personal group
    usermod -aG "$username" "$username" &>> "$LOG_FILE"
    log_message "Added user '$username' to group '$username'."

    # Add the user to additional groups
    for group in $groups; do
        if ! getent group "$group" &>/dev/null; then
            groupadd "$group" &>> "$LOG_FILE"
            log_message "Created group '$group'."
        fi
        usermod -aG "$group" "$username" &>> "$LOG_FILE"
        log_message "Added user '$username' to group '$group'."
    done

    # Generate a random password
    password=$(generate_password)
    echo "$username,$password" >> "$PASSWORD_FILE"
    log_message "Generated password for user '$username' and saved to $PASSWORD_FILE."

    # Set the password for the user
    echo "$username:$password" | chpasswd &>> "$LOG_FILE"
    log_message "Set password for user '$username'."

    # Set permissions for the home directory
    chmod 700 "/home/$username"
    log_message "Set permissions for home directory of user '$username'."

    # SSH key management
   # ssh_dir="/home/$username/.ssh"
   # authorized_keys_file="$ssh_dir/authorized_keys"
  # # mkdir -p "$ssh_dir"
  #  touch "$authorized_keys_file"
   # chown -R "$username:$username" "$ssh_dir"
   # chmod 700 "$ssh_dir"
   # chmod 600 "$authorized_keys_file"
   # log_message "Set up SSH directory for user '$username' with permissions -rw-------, owned by $username."

done < "$input_file"

exit 0

