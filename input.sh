#!/bin/bash

HTML_FILE="output.html"
LOG_FILE="output.log"
LOG_LEVEL="standard"

# Function to log information to both output.html and output.log
log_info() {
    local message="$1"
    local log_time=$(date +"%Y-%m-%d %H:%M:%S")
    if [[ "$LOG_LEVEL" == "verbose" || "$LOG_LEVEL" == "standard" ]]; then
        echo "<p><strong>$log_time</strong>: $message</p>" >> "$HTML_FILE"
    elif [[ "$LOG_LEVEL" == "debug" ]]; then
        echo "<p style='color: gray'><strong>$log_time</strong>: $message</p>" >> "$HTML_FILE"
    fi
    echo "$log_time - $message" >> "$LOG_FILE"
}

# Function to monitor memory usage
monitor_memory() {
    local mem_info=$(free -m)
    log_info "Memory Usage: $mem_info"
}

# Function to monitor scheduled tasks
monitor_tasks() {
    local tasks=$(sudo crontab -l 2>/dev/null)
    if [ -z "$tasks" ]; then
        tasks="No cron jobs found"
    fi
    log_info "Scheduled Tasks: $tasks"
}

# Function to monitor system hardware
monitor_hardware() {
    local hardware_info=$(sudo lshw 2>/dev/null)
    log_info "System Hardware: $hardware_info"
}

# Function to monitor system logs
monitor_logs() {
    local logs=$(sudo dmesg 2>/dev/null)
    log_info "System Logs: $logs"
}

# Function to monitor system load
monitor_load() {
    local load_info=$(uptime)
    log_info "System Load: $load_info"
}

# Function to monitor file system changes
monitor_file_changes() {
    local monitored_dir="/var/log/"
    log_info "Monitoring file changes in $monitored_dir"
    inotifywait -m -r -e modify,create,delete "$monitored_dir" |
    while read path action file; do
        log_info "File $file in $path $action"
    done
}

# Function to list installed packages
list_installed_packages() {
    local installed_packages=$(dpkg -l)
    log_info "Installed Packages: $installed_packages"
}

# Main function to execute monitoring functions
main() {
    while true; do
        monitor_memory
        monitor_tasks
        monitor_hardware
        monitor_logs
        monitor_load
        monitor_file_changes
        list_installed_packages
        sleep 300 # Sleep for 5 minutes (adjust as needed)
    done
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Initialize both HTML and log files
echo "" > "$HTML_FILE"
echo "" > "$LOG_FILE"

# Call the main function
main
