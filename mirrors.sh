#!/bin/bash

set -e  # توقف در صورت وقوع خطا

UBUNTU_CODENAME="noble"

MIRRORS=(
    "https://mirrors.pardisco.co/ubuntu/"
    "http://mirror.aminidc.com/ubuntu/"
    "http://mirror.faraso.org/ubuntu/"
    "https://ir.ubuntu.sindad.cloud/ubuntu/"
    "https://ubuntu-mirror.kimiahost.com/"
    "https://archive.ubuntu.petiak.ir/ubuntu/"
    "https://ubuntu.hostiran.ir/ubuntuarchive/"
    "https://ubuntu.bardia.tech/"
    "https://mirror.iranserver.com/ubuntu/"
    "https://ir.archive.ubuntu.com/ubuntu/"
    "https://mirror.0-1.cloud/ubuntu/"
    "http://linuxmirrors.ir/pub/ubuntu/"
    "http://repo.iut.ac.ir/repo/Ubuntu/"
    "https://ubuntu.shatel.ir/ubuntu/"
    "http://ubuntu.byteiran.com/ubuntu/"
    "https://mirror.rasanegar.com/ubuntu/"
    "http://mirrors.sharif.ir/ubuntu/"
    "http://mirror.ut.ac.ir/ubuntu/"
    "http://mirror.asiatech.ir/ubuntu/"
    "http://archive.ubuntu.com/ubuntu/"
)

echo "🔍 در حال بررسی آینه‌های داخلی و جهانی برای Ubuntu 24.04 ($UBUNTU_CODENAME)..."

WORKING_MIRROR=""

for MIRROR in "${MIRRORS[@]}"; do
    echo -n "⏳ تست $MIRROR ... "
    if curl -s --head --max-time 5 "$MIRROR" | grep -q "200 OK"; then
        echo "✅ در دسترس"
        WORKING_MIRROR=$MIRROR
        break
    else
        echo "❌ در دسترس نیست"
    fi
done

if [ -z "$WORKING_MIRROR" ]; then
    echo "🚫 هیچ مخزنی در دسترس نیست. بررسی اتصال اینترنت یا فایروال لازم است."
    exit 1
fi

echo "🛠 تنظیم فایل /etc/apt/sources.list با آینه:"
echo "    $WORKING_MIRROR"

sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb ${WORKING_MIRROR} ${UBUNTU_CODENAME} main restricted universe multiverse
deb ${WORKING_MIRROR} ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb ${WORKING_MIRROR} ${UBUNTU_CODENAME}-backports main restricted universe multiverse
deb ${WORKING_MIRROR} ${UBUNTU_CODENAME}-security main restricted universe multiverse
EOF

echo ""
echo "✅ فایل sources.list با موفقیت تنظیم شد."
echo "📦 حالا می‌تونی دستور زیر رو اجرا کنی:"
echo ""
echo "    sudo apt update"
echo ""
