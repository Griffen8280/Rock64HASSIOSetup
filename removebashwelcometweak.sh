# Simple bit of code to remove the bashwelcometweak
#!/bin/bash

user=$(who | cut -d' ' -f1)
sed -i '/ROCK64 PROFILE START/,/ROCK64 PROFILE END/d' "/home/$user/.bashrc"
