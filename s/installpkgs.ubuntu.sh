sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y

for pkg in "${PK[@]}";do sudo apt install -y "$pkg";done

sudo apt --purge autoremove -y
sudo apt update
sudo apt upgrade -y