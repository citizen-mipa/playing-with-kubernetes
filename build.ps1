$application="playing-with-kubernetes"
$version=(cargo pkgid).split('#')[1]

docker build -t $application':'$version .
docker tag $application':'$version $application':latest'

#docker image prune -f