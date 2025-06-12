# create python virtual environment
pve() {
    set -e
    current_dir="$(pwd)"
    venv_dot_path="$current_dir/.venv"
    venv_path="$current_dir/venv"
    venv_dot_activate="$venv_dot_path/bin/activate"
    venv_activate="$venv_path/bin/activate"

    if [ -d "$venv_dot_path" ]; then
        echo -e "The following Python virtual environment was found:\n\n$venv_dot_path.\n\nActivating..."
        source "$venv_dot_activate"
    elif [ -d "$venv_path" ]; then
        echo -e "The following Python virtual environment was found:\n\n$venv_path.\n"
        read -rp "Would you like to rename it to .venv before activating? [y/n] " response
        if [ "$response" = "y" ]; then
            mv "$venv_path" "$venv_dot_path"
            # fix activation scripts
            sed -i 's/venv/.venv/g' .venv/bin/activate
            # update pyvenv.cfg file
            sed -i 's/venv/.venv/g' .venv/pyvenv.cfg
            echo "Changes made. Activating..."
            source "$venv_dot_activate"
        else
            echo "No changes made. Activating..."
            source "$venv_activate"
        fi
    else
        echo "No Python virtual environment was found. Creating..."
        python3 -m venv .venv
        echo -e "\nThe following Python virtual environment has been created:\n\n$venv_dot_path.\n\nActivating..."
        source "$venv_dot_activate"
    fi
}