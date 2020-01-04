$releaseName = 'playing-with-kubernetes'
$releases = helm list

if ($releases[1] -like "*$releaseName*") {
    # upgrade instead of install
    helm upgrade $releaseName ./charts
}
else {
    helm install -name $releaseName ./charts -n 'default'
}
