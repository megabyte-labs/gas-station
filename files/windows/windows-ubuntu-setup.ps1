Remove-Item -path "C:\professor-manhattan-windows-ubuntu-setup.ps1"
cd $HOME/Documents
Write-Host "Updating Ubuntu and installing dependencies." -ForegroundColor DarkGreen -BackgroundColor White
ubuntu run sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev && sudo dpkg-reconfigure openssh-server
Write-Host "Installing Python dependencies" -ForegroundColor DarkGreen -BackgroundColor White
ubuntu run pip3 install pywinrm[credssp]
Write-Host "Cloning the Playbooks to your Documents folder" -ForegroundColor DarkGreen -BackgroundColor White
ubuntu run git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
# Can't figure out how to add "&& ansible-playbook main.yml" to the end of this - can anybody figure this out?
# So these steps are added:
Write-Host "Set up finished! Now, run the following commands to run the playbooks:" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "1. ubuntu --- this will open the Ubuntu shell" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "2. cd /mnt/c/Users/USER_FOLDER_NAME/Documents/Playbooks" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "3. ansible-playbook main.yml" -ForegroundColor DarkGreen -BackgroundColor White