
# ===== RUN POWERSHELL AS ADMIN - START ======================================================
# Returns a WindowsIdentity object that represents the current Windows user.
$CurrentWindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
#creating a new object of type WindowsPrincipal, and passing the Windows Identity to the constructor.
$CurrentWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($CurrentWindowsIdentity)
#Return True if specific user is Admin else return False
if ($CurrentWindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) 
{
 
# Write-Host "Write your logical code to execute in Admin mode" -ForegroundColor Green
Write-Host  " "
Write-Host "[ SUCCES ] Script running as administrator" -ForegroundColor Green

}
else {
# If Powershell is not running as administrator
Write-Warning "This script must run as Administrator"
Write-Warning "This script needs admin to make changes to the OpenSSH agent"
Write-Warning "Open PowerShell as Administrator and run this script again."
Read-Host -Prompt "Press ENTER to stop the script.."
Exit
}
# ===== RUN POWERSHELL AS ADMIN - END ======================================================



# ===== Check if GIT is installed - START ======================================================
try
{
    git | Out-Null
    Write-Host  " "
    Write-Host "[ SUCCES ] Git is installed" -ForegroundColor Green
}
catch [System.Management.Automation.CommandNotFoundException]
{
    Write-Host  " "
    Write-Warning "Git must be installed. Install Git and Start a new Powershell as Administrator and run the script again."
    Read-Host -Prompt "Press ENTER to stop the script.."
    Exit
}


# ===== Check if GIT is installed - END ======================================================

Write-Host "------------------------------------------"
Write-Host "----- Setup SSH for Microsoft Devops -----"
Write-Host "------------------------------------------"

# githubemail="USER INPUT"
Write-Host  " "
Write-Host "Enter your Microsoft Devops email (example: john@doe.com)"
Write-Host  " "
$githubemail= Read-Host -Prompt "Email"


# fullname="USER INPUT"
Write-Host  " "
$fullname= Read-Host -Prompt "Enter fullname"


# keyname="USER INPUT"
Write-Host  " "
Write-Host  "SSH will create a key. The default name is 'id_rsa', but you can give it another name here "
Write-Host  "Example: devops_id_rsa"
$keyname= Read-Host -Prompt "Enter SSH Key name"
Write-Host  " "

if ("$keyname" -eq "" ) 
{
Write-Host  "[ INFO ] NO SSH Key name is specified, the defauls name 'id_rsa' will be used"
 $keyname="id_rsa"
}

# # GITHUB --------------------------------------------------------------------------------------
# # 1. Open Terminal
# -N new_passphrase
# -f output_keyfile]
# ssh-keygen -t rsa -b 4096 -C "your@email.com" -f "/home/username/.ssh/id_rsa_test" -N ""

Write-Host "[ INFO ] When asked for a passphrase, press ENTER, without writing anything" -ForegroundColor Green
Write-Host  " "

ssh-keygen -t rsa -b 4096 -C "$githubemail" -f "$env:USERPROFILE\.ssh\$keyname"

# # 3. Starting ssh-agent is running
# In windows: Start Menu > Type "Services" > OpenSSH Authentication Agent
Write-Host " "
Write-Host "[ INFO ] Starting SSH Agent"  -ForegroundColor Green
Write-Host " "
# This will start the Open SSH Agent every time windows start
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent

# # 4. Add your SSH private key to the ssh-agent.
Write-Host " "
Write-Host "[ INFO ] Adding your SSH private key to the ssh-agent"  -ForegroundColor Green
Start-Sleep -Milliseconds 1500
$keyfullpath="$env:USERPROFILE\.ssh\$keyname"
ssh-add "$keyfullpath"

Start-Sleep -Milliseconds 1500

# # 5. Copy content of "~/.ssh/keyname.pub" til https://github.com/settings/keys
Write-Host "TWO OPTIONS: --------------------------"
Write-Host "Now you need to add the keys below in github. There are two ways to add them:"
Write-Host "A: To a profile - The computer can access ALL you repositories."
Write-Host "B: To a repositorie - The computer can access ONLY the repositories, where you add the keys.."
Write-Host ""
Write-Host "OPTION A:"
Write-Host "----- 1. Go to site: https://github.com/settings/keys -----"
Write-Host "----- 2. Click: New SSH key"
Write-Host "----- 3. Copy the text below to the 'Key' field. Then click Add Ssh Key"
Write-Host ""
Write-Host "OPTION B:"
Write-Host "----- 1. Go to repository: https://github.com/username/repo-name"
Write-Host "----- 2. Go to repository > Settings > Deploy Key > Add Deploy Key"
Write-Host "----- 3. Copy the text below to the 'Key' field. Then click Add Ssh Key"
Write-Host ""
cat "$env:USERPROFILE\.ssh\$keyname.pub"
Write-Host ""

# Press a key to continue
Write-Host "When you have created the Ssh key on Azure Devops."
Read-Host -Prompt "Then press ENTER key to continue.."

# # 6. Authorize that your computer trusts Github.com, write verbatim:
Write-Host "[ INFO ] Type: yes"  -ForegroundColor Green

ssh -T git@ssh.dev.azure.com -i "$env:USERPROFILE\.ssh\$keyname"

# # 7. Tell git that it should use SSH instead of HTTP login / password
# git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global url."git@ssh.dev.azure.com:v3".insteadOf https://dev.azure.com

#  8. configure "~/.ssh/config" file:
# host github.com
#  HostName github.com
#  IdentityFile ~/.ssh/github_martin_privat
#  User git

# Check if file doesn't exists
# if (-not(Test-Path -Path "$env:USERPROFILE\.ssh\config" -PathType Leaf)) {
# 	# File doesn't exist
# }

# HACK: We need to create a config file that does not have BOM, so the easy hack is to set the encoding to ASCII instead

@"
Host ssh.dev.azure.com
   PubkeyAcceptedKeyTypes=ssh-rsa
   HostName ssh.dev.azure.com
   IdentityFile $env:USERPROFILE\.ssh\$keyname
   User git
"@ | Out-File -FilePath "$env:USERPROFILE\.ssh\config" -encoding ASCII


Start-Sleep -Milliseconds 500

# FILE="$env:USERPROFILE\.ssh\config"
# if [ -f "$FILE" ]; then
#     echo "$FILE exists."
# else 
#     touch ~/.ssh/config
#     sleep 0.5
# fi

# echo "" >> ~/.ssh/config
# echo "host github.com" >> ~/.ssh/config
# echo " HostName github.com" >> ~/.ssh/config
# echo " IdentityFile ~/.ssh/$keyname" >> ~/.ssh/config
# echo " User git" >> ~/.ssh/config
 

# # 10. Put your name and email:
git config --global user.name "$fullname"
git config --global user.email "$githubemail"

Write-Host "[ SUCCES ] DONE - FINISHED" -ForegroundColor Green



# Links:
# https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops#questions-and-troubleshooting
# https://dev.to/koddr/quick-how-to-clone-your-private-repository-from-github-to-server-droplet-vds-etc-39jm
