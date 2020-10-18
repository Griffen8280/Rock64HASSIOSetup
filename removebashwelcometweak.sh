# Simple bit of code to remove the bashwelcometweak


sed -i '/ROCK64 PROFILE START/,/ROCK64 PROFILE END/d' "$HOME/.bashrc"
