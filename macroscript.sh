#!/bin/bash
# Este script instala y configura bspwm y sus dependencias en Ubuntu

# Actualiza los paquetes y descarga los necesarios
echo "Actualizando paquetes e instalando dependencias..."
sudo apt update
sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev bspwm meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev rofi feh slim libpam0g-dev libxrandr-dev libfreetype6-dev libimlib2-dev libxft-dev cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev alacritty libuv1 libuv1-dev zsh

# Crea el directorio temporal para clonar los repositorios si no existe
TEMP_DIR=~/temp
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# Clona los repositorios de bspwm y sxhkd
echo "Clonando repositorios de bspwm y sxhkd..."
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git

# Compila e instala bspwm
echo "Instalando bspwm..."
cd bspwm
make
sudo make install
# Compila e instala sxhkd
echo "Instalando sxhkd..."
cd ../sxhkd
make
sudo make install


echo "copiando los archivos de configuracion de bspwm y sxhkd"
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
cp ~/macroscript/bspwmrc ~/.config/bspwm
cp ~/macroscript/sxhkdrc ~/.config/sxhkd
chmod +x ~/.config/bspwm/bspwmrc

echo "instalando polybar"
cd $TEMP_DIR
#git clone https://github.com/VaughnValle/blue-sky.git
git clone --recursive https://github.com/polybar/polybar
cd polybar/
mkdir build
cd build/
cmake ..
make -j$(nproc)
sudo make install

echo "configurando polybar"
#cp -r ~/temp/blue-sky/polybar ~/.config
cp -r ~/macroscript/polybar2/* ~/.config/polybar
sudo cp ~/.config/polybar/fonts/* /usr/share/fonts/truetype
sudo cp ~/macroscript/hacknerd/* /usr/local/share/fonts/
sudo fc-cache -v

echo "instalando picom"
cd $TEMP_DIR
git clone https://github.com/ibhagwan/picom.git
cd picom/
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

echo "configurando picom"
cp -r ~/macroscript/picom ~/.config/

echo "copiando el tema de rofi"
cp -r ~/macroscript/rofi ~/.config/

echo "configurando fondo de pantalla"
cp -r ~/macroscript/Images ~/.

echo "instalando zsh"
cp -R ~/macroscript/zsh/.* ~/.



echo "luego haz 'rofi-theme-selector' y 'p10k configure'"
