#!/bin/bash

# Retrieve the username dynamically
username=$(whoami)
USER_PATH="/home/$username"

# Function to handle mv command with trigger
mv() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        command mv "$@"
        return
    fi

    # Extract source and destination paths
    src_paths=("${@:1:$#-1}")
    dest_path="${!#}"

    # Load .bashrc and extract sourced .sh and .py files
    bashrc_file="$USER_PATH/.bashrc"
    sh_py_paths=($(grep -oP '(?<=source\s)[^ ]+\.(sh|py)' "$bashrc_file"))

    for src in "${src_paths[@]}"; do
        # Resolve absolute paths
        abs_src=$(realpath "$src")
        abs_dest=$(realpath "$dest_path")

        for script in "${sh_py_paths[@]}"; do
            # Resolve absolute script path
            abs_script="$USER_PATH/$script"
            abs_script=$(realpath "$abs_script" 2>/dev/null)

            if [ -z "$abs_script" ]; then
                continue
            fi

            script_dir="${abs_script%/*}"

            # Check if script_dir is within src being moved
            if [[ "$script_dir" == "$abs_src"* ]]; then
                # Compute new script path
                relative_dir="${script_dir#$USER_PATH/}"
                new_script_dir="${abs_dest}/${relative_dir}"
                new_script_path="${new_script_dir}/${script##*/}"

                # Update .bashrc with new script path using sed
                sed -i "s|source $abs_script|source $new_script_path|" "$bashrc_file"
                echo "Updated .bashrc: source $abs_script -> source $new_script_path"
            fi
        done
    done

    # Execute the actual mv command
    command mv "$@"
}
