#!/bin/bash

# Function to print messages
print_message() {
    echo "------------------------------------"
    echo "$1"
    echo "------------------------------------"
}

# Update package list
print_message "Updating package list"
sudo apt-get update

# Install Python3 and pip
print_message "Installing Python3 and pip"
sudo apt-get install -y python3 python3-pip

# Install virtualenv
print_message "Installing virtualenv"
pip3 install virtualenv

# Create a virtual environment for the backend
print_message "Creating virtual environment for backend"
cd backend
virtualenv venv
source venv/bin/activate

# Install Python dependencies for the backend
print_message "Installing Python dependencies for the backend"
pip install -r requirements.txt
deactivate
cd ..

# Install Node.js and npm
print_message "Installing Node.js and npm"
sudo apt-get install -y nodejs npm

# Install frontend dependencies
print_message "Installing frontend dependencies"
cd frontend
npm install
cd ..

# Install Truffle and Conflux Truffle globally
print_message "Installing Truffle and Conflux Truffle globally"
npm install -g truffle @truffle/conflux

# Initialize Truffle project and install dependencies
print_message "Setting up Truffle project"
cd contracts
npm install
cd ..

# Install Python dependencies for the mining script
print_message "Installing Python dependencies for the mining script"
cd mining
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
cd ..

# Print completion message
print_message "Setup complete! All dependencies are installed."
