# Quick Setup of SSH Keys for Github

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

