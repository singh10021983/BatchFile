# Define the path to your Git workspace
$workspacePath = "C:\git\sep\sa"

# Task 1: Clean the Git workspace
cd $workspacePath


Write-Host "Cleaning SA Repo and pulling latest at " $workspace

#git clean -xdf
#git reset --hard

# Task 2: Pull the latest Git code from remote
#git pull

# Task 3: Store the latest commit hash in a file
#$commitHash = git rev-parse HEAD
#$commitHash | Set-Content -Path "C:\temp\sa-commit.txt"

# Task 4: Check if the 'sanightly' folder is present
#$sanightlyFolderPath = "C:\git\sep\sanightly"

#if (Test-Path $sanightlyFolderPath -PathType Container) {
    # Task 5: Clean the Git workspace and get the latest from remote for 'sanightly'
#    cd $sanightlyFolderPath
#    git clean -xdf
#    git reset --hard
#    git pull
#}

# Optionally, you can add error handling and logging as needed.
