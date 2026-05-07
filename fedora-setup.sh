# !/bin/bash

# --- Variables --- 
GRUB_PARAMS="iommu=pt amdgpu.gttsize=126976 ttm.pages_limit=32505856"
GRUB_FILE="/etc/default/grub"

# --- Asserts --- 
if [ "$EUID" -ne 0 ]; then 
  echo "This script requires root."
  exit 1
fi

# --- Grub ---
echo "Backing up $GRUB_FILE..."
cp $GRUB_FILE "${GRUB_FILE}.bak"

echo "Updating $GRUB_FILE..."
if grep -q "iommu=pt" "$GRUB_FILE"; then
    echo "Parameters already seem to exist in $GRUB_FILE. Skipping edit."
else
    sed -i "/^GRUB_CMDLINE_LINUX=/ s/\"$/ $GRUB_PARAMS\"/" $GRUB_FILE
    echo "Parameters added successfully."
fi

echo "Regenerating GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# --- Tuned --- 
echo "Installing tuned..."
dnf install -y tuned

echo "Enabling and starting tuned..."
systemctl enable --now tuned

echo "Disabling tuned-ppd..."
systemctl disable --now tuned-ppd
systemctl mask tuned-ppd

echo "Disabling tuned-ppd..."
systemctl disable --now upower
systemctl mask upower 

if tuned-adm list | grep -q "accelerator-performance"; then
    echo "Applying 'accelerator-performance' profile..."
    tuned-adm profile accelerator-performance
else
    echo "Warning: 'accelerator-performance' profile not found."
fi

echo -n "Active Tuned Profile: "
tuned-adm active

echo "------------------------------------------------------"
echo "Reboot to update GRUB."
echo "------------------------------------------------------"
