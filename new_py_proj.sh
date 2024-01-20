# read project name from user
project_name=$1
if [ -z "$project_name" ]; then
    echo "Project name is empty"
    exit 1
elif [ -d "$project_name" ]; then
    echo "Project name already exists"
    exit 1
fi

mkdir $project_name
touch $project_name/__init__.py
echo "if __name__ == '__main__':" >> $project_name/main.py
touch $project_name/tests.py
touch $project_name/requirements.txt

mkdir -p $project_name/.vscode
echo "{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    \"version\": \"0.2.0\",
    \"configurations\": [
        {
            \"name\": \"Python: Current File\",
            \"type\": \"python\",
            \"request\": \"launch\",
            \"program\": \"\${file}\",
            \"console\": \"integratedTerminal\",
            \"justMyCode\": true
        }
    ]
}" >> $project_name/.vscode/launch.json

echo "# $project_name
## Description
### {insert description here}
## Requirements
### pip install-r {inser module here}" >> $project_name/README.md
