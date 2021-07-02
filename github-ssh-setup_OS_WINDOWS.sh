#!/bin/bash
LANG=en_US.UTF-8

# githubemail="USER INPUT"
read -p "Enter your Github email (example: john@doe.com): " githubemail

# fullname="USER INPUT"
read -p "Enter fullname: " fullname

# keyname="USER INPUT"
echo "SSH will create a key. The default name is 'id_rsa', but you can give it another name here: "
read -p "Enter SSH Key name: " keyname
echo "----- Starting Setup -----"

OsUsername=$(whoami)

# # GITHUB --------------------------------------------------------------------------------------
# # 1. Open Terminal
# -N new_passphrase
# -f output_keyfile]
# ssh-keygen -t rsa -b 4096 -C "your@email.com" -f "/home/username/.ssh/id_rsa_test" -N ""
ssh-keygen -t rsa -b 4096 -C "$githubemail" -f "/c/Users/$OsUsername/.ssh/$keyname" -N ""

# # 3. Check ssh-agent is running
echo "----- Check: is ssh-agent started: -----"
eval "$(ssh-agent -s)"

# # 4. Add your SSH private key to the ssh-agent.

sleep 0.5
keyfullpath="/c/Users/$OsUsername/.ssh/$keyname"
ssh-add "$keyfullpath"

# # 5. Copy content of "~/.ssh/keyname.pub" til https://github.com/settings/keys
echo "TWO OPTIONS: --------------------------"
echo "Now you need to add the keys below in github. There are two ways to add them:"
echo "A: To a profile - The computer can access ALL you repositories."
echo "B: To a repositorie - The computer can access ONLY the repositories, where you add the keys.."
echo ""
echo "OPTION A:"
echo "----- 1. Go to site: https://github.com/settings/keys -----"
echo "----- 2. Click: New SSH key"
echo "----- 3. Copy the text below to the 'Key' field. Then click Add Ssh Key"
echo ""
echo "OPTION B:"
echo "----- 1. Go to repository: https://github.com/username/repo-name"
echo "----- 2. Go to repository > Settings > Deploy Key > Add Deploy Key"
echo "----- 3. Copy the text below to the 'Key' field. Then click Add Ssh Key"
echo ""
cat "/c/Users/$OsUsername/.ssh/$keyname.pub"
echo ""

# Press a key to continue
echo "When you have created the Ssh key on github."
read -n 1 -r -s -p $'Press ENTER key to continue\n'

# # 6. Authorize that your computer trusts Github.com, write verbatim:
echo "-----TYPE: yes -----"
ssh -T git@github.com -i "/c/Users/$OsUsername/.ssh/$keyname"

# # 7. Tell GitHub that it should use SSH instead of HTTP login / password
git config --global url.ssh://git@github.com/.insteadOf https://github.com/


#  8. configure "~/.ssh/config" file:
# host github.com
#  HostName github.com
#  IdentityFile ~/.ssh/github_martin_privat
#  User git



FILE="/c/Users/$OsUsername/.ssh/config"
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    touch "/c/Users/$OsUsername/.ssh/config"
    sleep 0.5
fi

echo "" >> "/c/Users/$OsUsername/.ssh/config"
echo "host github.com" >> "/c/Users/$OsUsername/.ssh/config"
echo " HostName github.com" >> "/c/Users/$OsUsername/.ssh/config"
echo " IdentityFile C:/Users/$OsUsername/.ssh/$keyname" >> "/c/Users/$OsUsername/.ssh/config"
echo " User git" >> "/c/Users/$OsUsername/.ssh/config"
 
## 9. Put the correct rights to the file "~/.ssh/Config"
chmod 600 "/c/Users/$OsUsername/.ssh/config"

# # 10. Put your name and email:
git config --global user.name "$fullname"
git config --global user.email "$githubemail"

echo "----- DONE -----"


# Links:
# https://dev.to/koddr/quick-how-to-clone-your-private-repository-from-github-to-server-droplet-vds-etc-39jm
