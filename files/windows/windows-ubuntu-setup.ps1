cd $HOME/Documents
echo "Running in Ubuntu WSL: sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev"
ubuntu run sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev && sudo dpkg-reconfigure openssh-server
ubuntu run pip3 install pywinrm[credssp]
ubuntu run git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
# Can't figure out how to add "&& ansible-playbook main.yml" to the end of this - can anybody figure this out?
# So these steps are added:
echo "Now run the following commands:"
echo "1. ubuntu --- this will open the Ubuntu shell"
echo "2. cd /mnt/c/Users/USER_FOLDER_NAME/Documents/Playbooks"
echo "3. ansible-playbook main.yml"