# usage:
# $ chrome index.html
function chrome() {
    open $@ --args --allow-file-access-from-files
}

# usage:
# $ server
alias server='open http://localhost:8000 && python -m SimpleHTTPServer'
