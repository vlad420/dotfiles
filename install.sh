#!/bin/bash

# pacman -Qe -> lista cu toate pachetele instalate manual
PACKAGES=("alacritty" "cursor-bin" "git" "feh")

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

install_yay() {
    echo "Instalarea Yay AUR Helper..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd ..
    rm -rf yay-bin
    echo -e "${GREEN}Yay a fost instalat și folderul clonat a fost șters cu succes.${NC}"
}

stow_directories() {
    clone_dotfiles_repo
    cd ~/dotfiles

    # Verifică dacă stow este instalat, dacă nu, îl instalează
    if ! command -v stow &> /dev/null; then
        echo -e "${RED}Stow nu este instalat. Se încearcă instalarea...${NC}"
        install_packages_with_yay stow
    fi

    # Obține toate directoarele care nu încep cu "."
    local dirs=$(find . -maxdepth 1 -type d ! -name '.*' -exec basename {} \; | tail -n +2)

    # Execută comanda stow pentru fiecare director găsit
    if [ -n "$dirs" ]; then
        stow $dirs
        echo -e "${GREEN}Directoarele au fost stow-uite cu succes.${NC}"
    else
        echo -e "${RED}Nu s-au găsit directoare care să nu înceapă cu '.'${NC}"
    fi
}

copy_dark_gtk_settings() {
    local source_file="dark-gtk-settings.ini"
    local destination_file="settings.ini"
    local gtk3_dir="$HOME/.config/gtk-3.0"
    local gtk4_dir="$HOME/.config/gtk-4.0"

    if [ ! -f "$source_file" ]; then
        echo -e "${RED}Fișierul $source_file nu există.${NC}"
        return 1
    fi

    # Verifică dacă folderul gtk-3.0 există și copiază fișierul
    if [ -d "$gtk3_dir" ]; then
        cp "$source_file" "$gtk3_dir/$destination_file"
        echo -e "${GREEN}Fișierul $source_file a fost copiat în $gtk3_dir${NC}"
    else
        echo -e "${RED}Folderul $gtk3_dir nu există.${NC}"
    fi

    # Verifică dacă folderul gtk-4.0 există și copiază fișierul
    if [ -d "$gtk4_dir" ]; then
        cp "$source_file" "$gtk4_dir/$destination_file"
        echo -e "${GREEN}Fișierul $source_file a fost copiat în $gtk4_dir${NC}"
    else
        echo -e "${RED}Folderul $gtk4_dir nu există.${NC}"
    fi
}

enable_pacman_colors() {
    local pacman_conf="/etc/pacman.conf"

    if grep -q "^#Color" "$pacman_conf"; then
        sudo sed -i 's/^#Color/Color/' "$pacman_conf"
        echo -e "${GREEN}Culorile au fost activate în pacman.${NC}"
    elif ! grep -q "^Color" "$pacman_conf"; then
        echo "Color" | sudo tee -a "$pacman_conf" > /dev/null
        echo -e "${GREEN}Culorile au fost adăugate și activate în pacman.${NC}"
    else
        echo -e "${GREEN}Culorile sunt deja activate în pacman.${NC}"
    fi
}

install_packages_with_yay() {
    local packages=("$@")
    if [ -z "$(command -v yay)" ]; then
        echo -e "${RED}Yay nu este instalat. Instalați yay mai întâi.${NC}"
        return 1
    fi

    echo "Instalarea pachetelor: ${packages[*]}"
    sudo yay -S --needed --noconfirm --answerclean All --removemake "${packages[@]}"
    echo -e "${GREEN}Pachetele au fost instalate cu succes și fișierele de construire au fost șterse.${NC}"
}

fix_asus_aura() {
    local packages=("asusctl" "supergfxctl")
    echo -e "${GREEN}Instalarea pachetelor necesare pentru ASUS Aura.${NC}"
    install_packages_with_yay "${packages[@]}"

    echo -e "${GREEN}Activarea și pornirea serviciului supergfxd.${NC}"
    sudo systemctl enable supergfxd
    sudo systemctl start supergfxd

    echo -e "${GREEN}Setarea modului LED pentru ASUS Aura.${NC}"
    asusctl led-mode -n
    asusctl led-mode -n
    asusctl led-mode -n
    asusctl led-mode -n
}

clone_dotfiles_repo() {
    local repo_url="https://github.com/vlad420/dotfiles.git"
    local destination_dir="$HOME/dotfiles"

    if [ -d "$destination_dir" ]; then
        echo -e "${RED}Folderul $destination_dir deja există. Ștergeți-l manual dacă doriți să re-clonați repo-ul.${NC}"
    else
        git clone "$repo_url" "$destination_dir"
        echo -e "${GREEN}Repo-ul a fost clonat cu succes în $destination_dir.${NC}"
    fi
}

copy_dark_gtk_settings
enable_pacman_colors
install_yay
fix_asus_aura
install_packages_with_yay "${PACKAGES[@]}"
stow_directories
