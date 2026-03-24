#!/bin/bash
# ============================================
# 🔥 DOTFILES INSTALLER - q4qd_
# ============================================
# Instalación automática de dotfiles y optimizaciones
# Compatible con Debian/Ubuntu/Parrot OS
# ============================================
set -e
# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
# Funciones de utilidad
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error()   { echo -e "${RED}❌ $1${NC}"; }
print_info()    { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
# Banner
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════╗
║   🔥 DOTFILES INSTALLER - q4qd_          ║
║   Instalación automática de BSPWM Setup  ║
╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}"
# Verificar que se ejecuta como usuario normal (no root)
if [ "$EUID" -eq 0 ]; then
    print_error "NO ejecutes este script como root. Usa tu usuario normal."
    exit 1
fi
# Verificar que estamos en el directorio correcto
if [ ! -f "install.sh" ]; then
    print_error "Ejecutá este script desde el directorio dotfiles/"
    exit 1
fi
print_info "Iniciando instalación..."
sleep 2

# ============================================
# 1. ACTUALIZAR SISTEMA
# ============================================
print_info "Actualizando sistema..."
sudo apt update -y && sudo apt upgrade -y
print_success "Sistema actualizado"

# ============================================
# 2. INSTALAR DEPENDENCIAS BASE
# ============================================
print_info "Instalando dependencias base..."
sudo apt install -y \
    build-essential \
    git \
    curl \
    wget \
    zsh \
    kitty \
    rofi \
    feh \
    ranger \
    i3lock-fancy \
    flameshot \
    htop \
    lsd \
    bat \
    fonts-noto-color-emoji \
    cpufrequtils \
    libxcb-util0-dev \
    libxcb-ewmh-dev \
    libxcb-randr0-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-xinerama0-dev \
    libasound2-dev \
    libxcb-xtest0-dev \
    libxcb-shape0-dev \
    cmake \
    cmake-data \
    pkg-config \
    python3-sphinx \
    libcairo2-dev \
    libxcb1-dev \
    libxcb-util0-dev \
    libxcb-randr0-dev \
    libxcb-composite0-dev \
    python3-xcbgen \
    xcb-proto \
    libxcb-image0-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-cursor-dev \
    libasound2-dev \
    libpulse-dev \
    libjsoncpp-dev \
    libmpdclient-dev \
    libnl-genl-3-dev \
    meson \
    libxext-dev \
    libxcb-damage0-dev \
    libxcb-dpms0-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-render-util0-dev \
    libxcb-render0-dev \
    libxcb-composite0-dev \
    libxcb-image0-dev \
    libxcb-present-dev \
    libxcb-randr0-dev \
    libxcb-glx0-dev \
    libpixman-1-dev \
    libdbus-1-dev \
    libconfig-dev \
    libgl-dev \
    libegl-dev \
    libpcre2-dev \
    libevdev-dev \
    uthash-dev \
    libev-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev
print_success "Dependencias instaladas"

# ============================================
# 3. COMPILAR BSPWM, SXHKD, POLYBAR, PICOM
# ============================================
print_info "Compilando BSPWM, SXHKD, Polybar y Picom..."
mkdir -p ~/tools
cd ~/tools
# BSPWM
if [ ! -d "bspwm" ]; then
    git clone https://github.com/baskerville/bspwm.git
    cd bspwm && make && sudo make install
    cd ..
    print_success "BSPWM compilado"
else
    print_warning "BSPWM ya existe, saltando..."
fi
# SXHKD
if [ ! -d "sxhkd" ]; then
    git clone https://github.com/baskerville/sxhkd.git
    cd sxhkd && make && sudo make install
    cd ..
    print_success "SXHKD compilado"
else
    print_warning "SXHKD ya existe, saltando..."
fi
# POLYBAR
if [ ! -d "polybar" ]; then
    git clone --recursive https://github.com/polybar/polybar.git
    cd polybar && mkdir -p build && cd build
    cmake .. && make -j$(nproc) && sudo make install
    cd ../..
    print_success "Polybar compilado"
else
    print_warning "Polybar ya existe, saltando..."
fi
# PICOM
if [ ! -d "picom" ]; then
    git clone https://github.com/yshui/picom.git
    cd picom && meson setup --buildtype=release build
    ninja -C build && sudo ninja -C build install
    cd ..
    print_success "Picom compilado"
else
    print_warning "Picom ya existe, saltando..."
fi
cd ~/dotfiles

# ============================================
# 4. INSTALAR OH MY ZSH + POWERLEVEL10K
# ============================================
print_info "Instalando Oh My Zsh y Powerlevel10k..."
# Para usuario actual
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    print_success "Oh My Zsh instalado para $USER"
else
    print_warning "Oh My Zsh ya instalado para $USER"
fi
# Cambiar shell a ZSH
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    print_success "Shell cambiado a ZSH"
fi
# Para root
print_info "Instalando Oh My Zsh para root..."
sudo bash -c '
if [ ! -d "/root/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
    chsh -s $(which zsh)
    echo "✅ Oh My Zsh instalado para root"
else
    echo "⚠️  Oh My Zsh ya instalado para root"
fi
'

# ============================================
# 5. COPIAR CONFIGURACIONES
# ============================================
print_info "Copiando configuraciones..."
mkdir -p ~/.config/{bspwm,sxhkd,polybar,kitty,rofi}
cp -r config/bspwm/*    ~/.config/bspwm/    2>/dev/null || print_warning "No se encontró config de bspwm"
cp -r config/sxhkd/*    ~/.config/sxhkd/    2>/dev/null || print_warning "No se encontró config de sxhkd"
cp -r config/polybar/*  ~/.config/polybar/  2>/dev/null || print_warning "No se encontró config de polybar"
cp -r config/kitty/*    ~/.config/kitty/    2>/dev/null || print_warning "No se encontró config de kitty"
cp -r config/rofi/*     ~/.config/rofi/     2>/dev/null || print_warning "No se encontró config de rofi"
cp config/.zshrc   ~/.zshrc   2>/dev/null || print_warning "No se encontró .zshrc"
cp config/.p10k.zsh ~/.p10k.zsh 2>/dev/null || print_warning "No se encontró .p10k.zsh"
chmod +x ~/.config/bspwm/bspwmrc                    2>/dev/null
chmod +x ~/.config/sxhkd/sxhkdrc                    2>/dev/null
chmod +x ~/.config/polybar/launch.sh                2>/dev/null
chmod +x ~/.config/polybar/shapes/scripts/*         2>/dev/null
print_success "Configuraciones copiadas"

# ============================================
# 6. DETECCIÓN AUTOMÁTICA DE INTERFACES DE RED
# ============================================
print_info "Detectando interfaces de red..."
ETH_INTERFACE=$(ip link show | grep -E "^[0-9]:" | grep -v "lo:" | grep -E "en|eth" | head -1 | awk '{print $2}' | sed 's/://')
if [ -z "$ETH_INTERFACE" ]; then
    ETH_INTERFACE="enp0s25"
    print_warning "No se detectó interfaz Ethernet, usando fallback: $ETH_INTERFACE"
else
    print_success "Interfaz Ethernet detectada: $ETH_INTERFACE"
fi
WIFI_INTERFACE=$(ip link show | grep -E "^[0-9]:" | grep -v "lo:" | grep -E "wl" | head -1 | awk '{print $2}' | sed 's/://')
if [ -z "$WIFI_INTERFACE" ]; then
    WIFI_INTERFACE="wlp3s0"
    print_warning "No se detectó interfaz WiFi, usando fallback: $WIFI_INTERFACE"
else
    print_success "Interfaz WiFi detectada: $WIFI_INTERFACE"
fi
if [ -f ~/.config/polybar/shapes/modules.ini ]; then
    sed -i "s/interface = eth0/interface = $ETH_INTERFACE/g"   ~/.config/polybar/shapes/modules.ini
    sed -i "s/interface = wlan0/interface = $WIFI_INTERFACE/g" ~/.config/polybar/shapes/modules.ini
    sed -i "s/interface = enp0s25/interface = $ETH_INTERFACE/g" ~/.config/polybar/shapes/modules.ini
    sed -i "s/interface = wlp3s0/interface = $WIFI_INTERFACE/g" ~/.config/polybar/shapes/modules.ini
    print_success "Polybar configurado con interfaces: $ETH_INTERFACE (Ethernet) y $WIFI_INTERFACE (WiFi)"
fi
if [ -f ~/.config/polybar/shapes/scripts/ethernet_status.sh ]; then
    sed -i "s/enp0s25/$ETH_INTERFACE/g" ~/.config/polybar/shapes/scripts/ethernet_status.sh
    print_success "Script ethernet_status actualizado"
fi

# ============================================
# 7. OPTIMIZACIONES DEL SISTEMA
# ============================================
print_info "Aplicando optimizaciones del sistema..."
sudo apt install -y cpufrequtils
echo 'GOVERNOR="performance"' | sudo tee /etc/default/cpufrequtils
sudo systemctl restart cpufrequtils 2>/dev/null || print_warning "cpufrequtils no se pudo reiniciar (normal en algunos sistemas)"
print_success "CPU Governor configurado a 'performance'"
if ! grep -q "vm.swappiness=10" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    print_success "Swappiness configurado a 10"
else
    print_warning "Swappiness ya configurado"
fi
sudo systemctl disable bluetooth   2>/dev/null || print_warning "Bluetooth no encontrado"
sudo systemctl stop bluetooth      2>/dev/null || print_warning "Bluetooth no se pudo detener"
sudo systemctl disable ModemManager 2>/dev/null || print_warning "ModemManager no encontrado"
sudo systemctl stop ModemManager   2>/dev/null || print_warning "ModemManager no se pudo detener"
print_success "Servicios innecesarios deshabilitados"
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
print_success "TRIM habilitado para SSD"
gsettings set org.mate.Marco.general compositing-manager false 2>/dev/null || print_warning "MATE no encontrado, saltando compositor"

# ============================================
# 8. OPTIMIZACIONES DE GRUB (NVIDIA NOUVEAU)
# ============================================
print_info "Verificando GPU..."
if lspci | grep -i nvidia > /dev/null; then
    print_info "GPU NVIDIA detectada, configurando parámetros de Nouveau..."
    sudo cp /etc/default/grub /etc/default/grub.backup
    if ! grep -q "nouveau.config=NvClkMode=auto" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nouveau.config=NvClkMode=auto nouveau.noaccel=0"/' /etc/default/grub
        sudo update-grub
        print_success "Parámetros de Nouveau agregados a GRUB (requiere reinicio)"
    else
        print_warning "Parámetros de Nouveau ya configurados"
    fi
else
    print_info "GPU NVIDIA no detectada, saltando configuración de Nouveau"
fi

# ============================================
# 9. CREAR ENTRADA DE BSPWM EN LIGHTDM/GDM
# ============================================
print_info "Creando entrada de BSPWM en el gestor de sesiones..."
sudo tee /usr/share/xsessions/bspwm.desktop > /dev/null << 'BSPWM_DESKTOP'
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=bspwm
Type=Application
BSPWM_DESKTOP
print_success "Entrada de BSPWM creada"

# ============================================
# 10. NEOVIM + NVCHAD
# ============================================
print_info "Instalando Neovim + NvChad..."
sudo apt install -y neovim
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1
    print_success "NvChad instalado (abrí nvim para completar la instalación)"
else
    print_warning "~/.config/nvim ya existe, saltando NvChad"
fi

# ============================================
# 11. HERRAMIENTAS DE TERMINAL
# ============================================
print_info "Instalando herramientas de terminal..."
sudo apt install -y \
    fzf \
    lemonbar \
    zsh-syntax-highlighting \
    yt-dlp
print_success "Herramientas de terminal instaladas"

# ============================================
# 12. GITHUB CLI
# ============================================
print_info "Instalando GitHub CLI..."
if ! command -v gh &>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update -y && sudo apt install -y gh
    print_success "GitHub CLI instalado"
else
    print_warning "GitHub CLI ya instalado"
fi

# ============================================
# 13. BRAVE BROWSER
# ============================================
print_info "Instalando Brave Browser..."
if ! command -v brave-browser &>/dev/null; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update -y && sudo apt install -y brave-browser
    print_success "Brave Browser instalado"
else
    print_warning "Brave Browser ya instalado"
fi

# ============================================
# 14. VSCODIUM
# ============================================
print_info "Instalando VSCodium..."
if ! command -v codium &>/dev/null; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
    sudo apt update -y && sudo apt install -y codium
    print_success "VSCodium instalado"
else
    print_warning "VSCodium ya instalado"
fi

# ============================================
# 15. PROTON MAIL + PROTON VPN
# ============================================
print_info "Instalando Proton Mail y ProtonVPN..."
# Proton Mail (deb desde releases oficiales)
if ! dpkg -l proton-mail &>/dev/null; then
    PROTON_MAIL_URL=$(curl -s https://api.github.com/repos/ProtonMail/proton-bridge/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4 | head -1)
    if [ -n "$PROTON_MAIL_URL" ]; then
        wget -O /tmp/proton-mail.deb "$PROTON_MAIL_URL"
        sudo apt install -y /tmp/proton-mail.deb
        rm /tmp/proton-mail.deb
        print_success "Proton Mail instalado"
    else
        print_warning "No se pudo obtener la URL de Proton Mail, instalá manualmente desde https://proton.me/mail/bridge"
    fi
else
    print_warning "Proton Mail ya instalado"
fi
# ProtonVPN
if ! dpkg -l protonvpn-stable-release &>/dev/null; then
    wget -O /tmp/protonvpn-stable-release.deb "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb"
    sudo apt install -y /tmp/protonvpn-stable-release.deb
    sudo apt update -y && sudo apt install -y proton-vpn-gnome-desktop
    rm /tmp/protonvpn-stable-release.deb
    print_success "ProtonVPN instalado"
else
    print_warning "ProtonVPN ya instalado"
fi

# ============================================
# 16. BITWARDEN
# ============================================
print_info "Instalando Bitwarden..."
if ! dpkg -l bitwarden &>/dev/null; then
    BW_URL=$(curl -s https://api.github.com/repos/bitwarden/clients/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4 | head -1)
    if [ -n "$BW_URL" ]; then
        wget -O /tmp/bitwarden.deb "$BW_URL"
        sudo apt install -y /tmp/bitwarden.deb
        rm /tmp/bitwarden.deb
        print_success "Bitwarden instalado"
    else
        print_warning "No se pudo obtener la URL de Bitwarden, instalá manualmente desde https://bitwarden.com/download"
    fi
else
    print_warning "Bitwarden ya instalado"
fi

# ============================================
# 17. OBSIDIAN
# ============================================
print_info "Instalando Obsidian..."
if ! dpkg -l obsidian &>/dev/null; then
    OBS_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4 | head -1)
    if [ -n "$OBS_URL" ]; then
        wget -O /tmp/obsidian.deb "$OBS_URL"
        sudo apt install -y /tmp/obsidian.deb
        rm /tmp/obsidian.deb
        print_success "Obsidian instalado"
    else
        print_warning "No se pudo obtener la URL de Obsidian, instalá manualmente desde https://obsidian.md"
    fi
else
    print_warning "Obsidian ya instalado"
fi

# ============================================
# 18. DOCKER COMPOSE + PODMAN + BUILDAH
# ============================================
print_info "Instalando Docker Compose, Podman y Buildah..."
sudo apt install -y docker-compose podman podman-docker buildah
print_success "Docker Compose, Podman y Buildah instalados"

# ============================================
# 19. GOLANG 1.24
# ============================================
print_info "Instalando Go 1.24..."
sudo apt install -y golang-1.24-go golang-go
print_success "Go 1.24 instalado"

# ============================================
# 20. OPENJDK 25
# ============================================
print_info "Instalando OpenJDK 25..."
sudo apt install -y openjdk-25-jdk
print_success "OpenJDK 25 instalado"

# ============================================
# 21. VOLATILITY3
# ============================================
print_info "Instalando Volatility3..."
sudo apt install -y volatility3
print_success "Volatility3 instalado"

# ============================================
# 22. LIMPIAR LAUNCHERS HUÉRFANOS
# ============================================
print_info "Limpiando launchers huérfanos..."
sudo rm -f /usr/share/applications/native-sqlitebrowser.desktop \
           /usr/share/applications/vim.desktop
print_success "Launchers huérfanos eliminados"

# ============================================
# 23. RESUMEN FINAL
# ============================================
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        ✅ INSTALACIÓN COMPLETADA          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
echo ""
print_info "Configuración instalada:"
echo "  🪟  Window Manager : BSPWM"
echo "  🎨  Terminal       : Kitty"
echo "  🐚  Shell          : ZSH (Oh My Zsh + Powerlevel10k)"
echo "  📊  Bar            : Polybar (tema: shapes)"
echo "  🌐  Ethernet       : $ETH_INTERFACE"
echo "  📶  WiFi           : $WIFI_INTERFACE"
echo "  🔒  VPN            : ProtonVPN"
echo "  📝  Editor         : Neovim + NvChad / VSCodium"
echo "  🐳  Containers     : Docker Compose / Podman / Buildah"
echo "  🔍  Forense        : Volatility3"
echo "  ☕  Java           : OpenJDK 25"
echo "  🐹  Go             : 1.24"
echo ""
print_warning "IMPORTANTE: Reiniciá el sistema para aplicar todos los cambios"
print_info "Después del reinicio, seleccioná 'bspwm' en el gestor de sesiones"
echo ""
read -p "¿Querés reiniciar ahora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[SsYy]$ ]]; then
    print_info "Reiniciando en 3 segundos..."
    sleep 3
    sudo reboot
else
    print_info "Recordá reiniciar manualmente para aplicar todos los cambios"
fi
