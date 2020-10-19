# Simple bit of code to remove the bashwelcometweak


su -c "sed -i '/ROCK64 PROFILE START/,/ROCK64 PROFILE END/d' '$HOME/.bashrc'" -s /bin/sh $(who | cut -d' ' -f1)
