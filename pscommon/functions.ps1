function BuildContainer {
    Param (
        [String] $ApplicationName = 'playing-with-kubernetes'
    )

    $version=GetApplicationVersion
    
    docker build -t $ApplicationName':'$version .
    docker tag $ApplicationName':'$version $ApplicationName':latest'
  
    #docker image prune -f (disabled, testing if this ruins cache)

    return @{
        "version"=$version
    }
  }

function DeployContainer {
    Param (
        [String] $ApplicationVersion = 'latest',
        [String] $ReleaseName = 'playing-with-kubernetes'
    )

    $releases = helm list
    
    if ($releases[1] -like "*$ReleaseName*") {
        # upgrade instead of install
        Write-Host "Upgrading to version $ApplicationVersion"
        helm upgrade $ReleaseName ./charts --set image.tag=$ApplicationVersion
        
    }
    else {
        Write-Host "Installing version $ApplicationVersion"
        helm install -name $ReleaseName ./charts -n 'default' --set image.tag=$ApplicationVersion
        
    }
}

function RunContainer {
    Param (
        [String] $ReleaseName = 'playing-with-kubernetes'
    )

    # remove container on exit
    docker run --rm --publish-all -it $ReleaseName
}

function RunCargo {
    cargo run
}

function GetApplicationVersion {
    return (cargo pkgid).split('#')[1]
}