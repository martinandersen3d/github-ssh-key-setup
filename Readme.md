# Quick Setup of SSH Keys for Github And Azure

# Github SSH Setup:

This sccript is in two versions:
- **Linux:** github-ssh-setup.sh
- **Windows+Git Bash:** github-ssh-setup_OS_WINDOWS.sh

## 1. Clone this project
```
git clone https://github.com/martinandersen3d/github-ssh-key-setup.git
```
## 2. Run the script
```
cd github-ssh-key-setup/
./github-ssh-setup.sh
```
# Step 3, has two options:
### 3A. Add Keys on your Profile (Computer will have access to ALL your repositories):
Use this option if your are settings up your developer computer.

https://github.com/settings/keys 

![alt](guide-profile-keys.png)


### 3B. Add Keys on a git repository (Computer will have access ONLY on the repositories, where you add the key):
Use this option if your have a server, that needs access to ONE or more private/public repositories.
1. Go to the repository you want the server to access.
2. Go into repository > Settings
3. Deploy keys 
4. Add Deploy key

![alt](guide-repo-keys.png)


## Demonstration
![alt](demo.gif)

# Azure Devops SSH Setup:

Todo:
- Currently it overwrites the file in c:\users\\$USER\\.ssh\config, if you have any data there, make a backup before you run the script
- Replace all github descriptions with Azure Devops descriptions

## Demonstration - Azure
![alt](azure.gif)

Note: For some stupid reason Microsoft needs TWO domains to make the SSH work for Azure, and not one domain like everyone else.

Example of config file:
C:\Users\MyUsername\.ssh\config
```
Host ssh.dev.azure.com
   PubkeyAcceptedKeyTypes=ssh-rsa
   HostName ssh.dev.azure.com
   IdentityFile C:\Users\MyUsername\.ssh\azure_rsa
   IdentitiesOnly yes
   AddKeysToAgent yes
   PasswordAuthentication=no
   User git

Host vs-ssh.visualstudio.com
  IdentityFile C:\Users\MyUsername\.ssh\azure_rsa
  IdentitiesOnly yes
```

# Important Note on using Multiple Deploy keys in eg. github
You should have a config file in:
Windows:
```
C:\Users\<username>\.ssh\config
```
Linux:
```
~/.ssh/config
```

If you have mulitple repos from github you want to add Deploy keys to, you might need to edit the config file, like this:
Windows example:
```
host github_superman
 HostName github.com
 IdentityFile C:/Users/username/.ssh/github_superman_id_rsa
 User git

host github_catwoman
 HostName github.com
 IdentityFile C:/Users/username/.ssh/github_catwoman_id_rsa
 User git
```

And your `git clone`, command will need to be changed:

```
git clone git@github_superman:githubusername/repo.git
git clone git@github_catwoman:githubusername/repo.git
```


----

# TODO: Notes: Azure devops

https://stackoverflow.com/questions/61130895/unable-to-clone-azure-devops-repository-via-ssh-password-required

2025: Tror der er lavet nogle ændringer, den her konfigi virker
C:\Users\<user>\.ssh\config
```
Host ssh.dev.azure.com
   PubkeyAcceptedKeyTypes=ssh-rsa
   HostName ssh.dev.azure.com
   IdentityFile C:\Users\mmmb\.ssh\id_rsa
   User git

```


