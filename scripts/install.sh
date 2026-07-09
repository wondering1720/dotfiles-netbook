#!/bin/bash

# --- Guardia de seguridad ---
if [ "$EUID" -eq 0 ]; then
    echo "========================================================"
    echo "ERROR: Por favor, NO ejecutes este script como root o con sudo directo."
    echo "Ejecútalo como tu usuario normal: ./scripts/install.sh"
    echo "========================================================"
    exit 1
fi

# --- Configuración de datos ---
PAQUETES=(
    "i3"
    "kitty"
    "neovim"
    "jackd2"
    "qjackctl"
    "guitarix"
    "pulseaudio-module-jack"
    "git"
    "network-manager"
    "firmware-iwlwifi"
    "xorg"
    "xserver-xorg-input-libinput"
    "mpv"
    "ffmpeg"
    "yt-dlp"
    "fzf"
    "pipx"
    "python3-pip"
    "build-essential"
    "unzip"
    "ripgrep"
)

CONFIGS=(
    ".config/i3/config .config/i3/config"
    ".config/nvim .config/nvim"
    ".config/kitty .config/kitty"
)

# --- Lógica de instalación ---

echo "--- Actualizando repositorios ---"
sudo apt update

echo "--- Instalando paquetes ---"
for paquete in "${PAQUETES[@]}"; do
    if ! dpkg -l | grep -q "^ii  $paquete "; then
        echo "Instalando $paquete..."
        sudo apt install -y "$paquete"
    else
        echo "$paquete ya está instalado."
    fi
done

# --- Instalación de Yewtube ---
echo "--- Instalando Yewtube para sugerencias de video ---"
if ! command -v yewtube &> /dev/null; then
    pipx install yewtube
    pipx ensurepath
fi

# --- Lógica de enlaces ---
echo "--- Creando enlaces simbólicos ---"
for entry in "${CONFIGS[@]}"; do
    set -- $entry
    ORIGEN=$1
    DESTINO=$2
    mkdir -p "$(dirname ~/$DESTINO)"
    ln -sf ~/dotfiles-netbook/$ORIGEN ~/$DESTINO
    echo "Enlazado: $ORIGEN -> $DESTINO"
done

# --- Ajustes finales ---
echo "--- Configurando permisos ---"
sudo usermod -a -G audio $(whoami)
chmod +x ~/dotfiles-netbook/scripts/*.sh

echo "--------------------------------------------------------"
echo "¡Instalación finalizada con éxito!"
echo "--------------------------------------------------------"