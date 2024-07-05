# User Creation Bash Script

## Introduction

This repository contains a bash script `create_users.sh` designed to automate the process of creating users and groups on a Linux system. This script reads a text file containing usernames and group names, creates the users and their respective groups, sets up home directories, generates random passwords, and logs all actions.

## Requirements

- Script File: `create_users.sh`
- Log File: `/var/log/user_management.log`
- Password File: `/var/secure/user_passwords.txt`

## Features

- Reads a text file with usernames and groups.
- Creates users and groups as specified.
- Sets up home directories with appropriate permissions.
- Generates random passwords for users.
- Logs all actions to `/var/log/user_management.log`.
- Stores generated passwords securely in `/var/secure/user_passwords.txt`.
- Handles errors for scenarios like existing users.

## Usage

1. Prepare the Input File: Create a text file named `user_list.txt`

2. Run the Script: Execute the script by providing the name of the text file as an argument.
    sh
    sudo bash create_users.sh user_list.txt
    

## Script Explanation

The script performs the following steps:
- Reads the input file line by line.
- For each line, it extracts the username and groups.
- Creates the user and their personal group.
- Adds the user to the specified groups.
- Sets up the user's home directory.
- Generates a random password and saves it securely.
- Logs all actions and errors.

## Log Files

- User Management Log: `/var/log/user_management.log` - Contains a log of all actions performed by the script.
- User Passwords File: `/var/secure/user_passwords.txt` - Contains a list of all users and their passwords, with read permissions restricted to the file owner.

## Security Measures

- Passwords are stored securely with restricted access.
- Proper permissions are set for user directories and log files.

## Links

- https://medium.com/@abiodunr081/automating-user-and-group-creation-on-linux-with-bash-script-647b4a2a655f

- [HNG Premium](https://hng.tech/premium)
