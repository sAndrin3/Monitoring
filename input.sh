#!/bin/bash

# Function to log information to output.log
log_info() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> output.log
}

# Function to monitor memory usage
monitor_memory() {
    mem_info=$(free -m)
    log_info "Memory Usage: $mem_info"
}

# Function to monitor scheduled tasks
monitor_tasks() {
    tasks=$(sudo crontab -l 2>/dev/null)
    if [ -z "$tasks" ]; then
        tasks="No cron jobs found"
    fi
    log_info "Scheduled Tasks: $tasks"
}

# Function to monitor system hardware
monitor_hardware() {
    hardware_info=$(sudo lshw 2>/dev/null)
    log_info "System Hardware: $hardware_info"
}

# Function to monitor system logs
monitor_logs() {
    logs=$(sudo dmesg 2>/dev/null)
    log_info "System Logs: $logs"
}

# Function to monitor system load
monitor_load() {
    load_info=$(uptime)
    log_info "System Load: $load_info"
}

# Main function to execute monitoring functions
main() {
    while true; do
        monitor_memory
        monitor_tasks
        monitor_hardware
        monitor_logs
        monitor_load
        sleep 300 # Sleep for 5 minutes (adjust as needed)
    done
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Call the main function
main
