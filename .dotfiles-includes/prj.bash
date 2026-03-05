# handling options
# https://wiki.bash-hackers.org/howto/getopts_tutorial

prjDatabase=~/.prj

if [[ ! -e $prjDatabase ]]; then
    mkdir $prjDatabase
fi

function prj() {
    if [[ $* == *"--help"* || $* == *"-h"* ]]; then
        prj-h
        return
    fi

    if [[ $# -eq 0 ]]; then
    # prj called without params list available projects
        prj-l
    elif [[ $# -eq 1 ]]; then
    # prj {name} called with a project name to open project
        prj-o $1
    elif [[ $# -gt 1 ]]; then
        # prj {name} -d -f
        if [[ $* == *"--delete"* || $* == *"-d"* ]]; then
            prj-d $*
            return
        fi

        # prj {name} -e
        if [[ $* == *"--edit"* || $* == *"-e"* ]]; then
            prj-e $1
            return
        fi

        # prj {name} -i
        if [[ $* == *"--infos"* || $* == *"-i"* ]]; then
            prj-i $1
            return
        fi

        # prj {name} {path} [--vim] [--tmux] [--force] creates a project called {name} for {path}
        prj-c $*
    fi
}

function prj-h() {
    cat <<- EOHELP
Usage
prj : List projects in $prjDatabase

prj {name} : Open project {name}

prj {name} {path} [--tmux] [--vim] [--force] : Create new project {name} for {path}
    Name must be unique
    Path can be an absolute path or a relative path to a directory or a file
    --tmux  Setup a tmux session when opening project
    --vim   Launch vim when opening project
    --force Overwrite existing project

prj {name} --edit : Edit project's file

prj {name} --delete [--force] : Delete project {name}
    --force Do NOT ask for confirmation

prj {name} --infos : View project's path and instructions

prj --help : Show help
EOHELP
}

function prj-l() {
    projectsList=$(ls -t $prjDatabase)

    if [[ -z $projectsList ]]; then
        echo "No projects"
    else
        echo $projectsList
    fi
}

function prj-o() {
    prjFile=$prjDatabase/$1

    if [[ -f $prjFile ]]; then
        touch $prjFile
        source $prjFile
    else
        echo "Invalid project name: '$1'"
    fi
}

function prj-d() {
    prjFile=$prjDatabase/$1

    if [[ ! -f $prjFile ]]; then
        echo "Invalid project name: '$1'"
        return
    fi

    if [[ $* == *"--force"* || $* == *"-f"* ]]; then
        response="y"
    else
        read -r -p "Are you sure? [y/N] " response
        response=${response,,} # tolower
    fi

    if [[ $response =~ ^(yes|y| ) ]] && [[ -n $response ]]; then
        rm $prjFile
    else
        echo "Project NOT deleted"
    fi
}

function prj-e() {
    prjFile=$prjDatabase/$1

    if [[ -f $prjFile ]]; then
        vim $prjFile
    else
        echo "Invalid project name: '$1'"
    fi
}

function prj-i() {
    prjFile=$prjDatabase/$1

    if [[ -f $prjFile ]]; then
        echo -e "# Path\n$prjFile\n"

        echo -e "# Instructions"
        cat $prjFile
    else
        echo "Invalid project name: '$1'"
    fi
}

function prj-c() {
    prjName=$1
    prjPath=$2
    prjFile=$prjDatabase/$prjName

    if [[ -e $prjFile && ! $* == *"--force"* && ! $* == *"-f"* ]]; then
        echo "Project '$prjName' already exists, add --force to overwrite"
    else
        prjDirname=$([[ -d $prjPath ]] && echo $prjPath || echo $(dirname $prjPath))
        prjDirectory=$(cd $prjDirname && pwd) # Handle relative and absolute paths

        prjContent="cd $prjDirectory"

        if [[ $* == *"--vim"* ]]; then
            vimEntryFile=$([[ -d $prjPath ]] && echo '.' || echo $(basename $prjPath))
            vimCommand="vim $vimEntryFile"
        fi

        if [[ $* == *"--tmux"* ]]; then
            prjContent+="\ntmux new -d -s '$prjName'"

            if [[ -n "$vimCommand" ]]; then
                prjContent+="\ntmux send-keys -t '$prjName' '$vimCommand' Enter"
            fi

            prjContent+="\ntmux a -t '$prjName'"
        else
            prjContent+="\n$vimCommand"
        fi
    
        echo -e $prjContent > $prjFile
    fi
}
