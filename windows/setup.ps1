$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP
# Can't figure out how to add "&& ansible-playbook main.yml" to the end of this - can anybody figure this out?
cd $HOME/Documents
echo "Running in Ubuntu WSL: sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev"
ubuntu run sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install git ansible python3-pip libffi-dev libssl-dev
ubuntu run pip3 install pywinrm[credssp]
ubuntu run git clone https://gitlab.com/ProfessorManhattan/Playbooks.git
ubuntu run chmod 755 Playbooks
cd Playbooks
ubuntu run ansible-playbook main.yml