# Download AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install unzip if needed
sudo apt update
sudo apt install -y unzip

# Extract
unzip awscliv2.zip

# Install AWS CLI
sudo ./aws/install

# Verify installation
