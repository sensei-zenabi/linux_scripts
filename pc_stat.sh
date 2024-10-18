#!/bin/bash

# Check if 'sensors' is installed
if ! command -v sensors &> /dev/null
then
    echo "'sensors' is not installed. Please install 'lm-sensors' first."
    exit 1
fi

# Define the interval between checks (in seconds)
INTERVAL=2
MAX_TEMP=100  # Define the critical temperature threshold in °C
BAR_WIDTH=50  # Fixed bar width in characters

# Clear the screen initially
clear

# Function to print a fixed-width horizontal temperature bar
print_temp_bar() {
    local temperature=$(printf "%.0f" "$1")  # Convert temperature to an integer
    local bar_fill_length=$((temperature * BAR_WIDTH / MAX_TEMP))  # Bar fill length based on temperature
    local bar_empty_length=$((BAR_WIDTH - bar_fill_length))  # Empty portion of the bar

    # Determine the color based on temperature ranges
    if [ "$temperature" -ge 100 ]; then
        color="31"  # Red color for critical temperatures (> 100°C)
    elif [ "$temperature" -ge 80 ]; then
        color="33"  # Yellow color for high temperatures (80°C - 100°C)
    else
        color="32"  # Green for normal temperatures (< 80°C)
    fi
    
    # Print the temperature bar with the value inside
    printf "\e[1;${color}m%-3s°C \e[0m[" "$temperature"
    
    for ((i=0; i<bar_fill_length; i++)); do
        printf "="
    done
    
    for ((i=0; i<bar_empty_length; i++)); do
        printf " "
    done
    
    printf "] (Max: 100°C)\n"
}

# Start monitoring the temperature
while true; do
    # Clear the screen for each new read
    clear

    echo "---- Server Temperature Monitoring ----"
    echo "Press Ctrl+C to exit."
    
    # Get temperature data from sensors
    sensors_output=$(sensors)

    # Parse the temperature readings (adjust parsing based on your sensors output)
    # Example: for CPU temperatures with 'Core' name
    core_temps=$(echo "$sensors_output" | grep 'Core' | awk '{print $3}' | sed 's/+//g;s/°C//g')

    # Loop through core temperatures and print a bar for each
    echo "CPU Core Temperatures:"
    echo "-----------------------"
    
    for temp in $core_temps; do
        print_temp_bar "$temp"
    done
    
    # Wait for the defined interval before refreshing
    sleep $INTERVAL
done
