# Simple bit of code to remove the bashwelcometweak
#!/bin/bash

exec su -l $(who | cut -d' ' -fl)
sed -i '/ROCK64 PROFILE START/,/ROCK64 PROFILE END/d' "$HOME/.bashrc"
