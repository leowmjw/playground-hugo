#!/bin/bash
#

echo "Sinar Project Refesh ArangoDB with PopIt Data!!"

mycat=$1
# DEBUG:
# echo "Category is $mycat"

if [ "${mycat}X" == "X" ]
    then
    echo "ERROR"
elif [ "${mycat}X" == "ALLX" ]
    then
    # Trubcate DB first .. :P
    arangosh --javascript.execute ./TOOLS/truncate-arangos.js
    # ALL
    for curcat in `ls PROCESS`
        do
        # Source all the dependencies function for each type
        . ./TOOLS/arangodb-utility.bash
        
        # DEBUG:
        # echo "Going into folder PROCESS/${curcat}"
        # cd into the correct one inside PROCESS folder
        cd ./PROCESS/${curcat}
        # DEBUG:
        # echo "Got in .. now in `pwd`"        
        
        # Can use below if Bash 4 and above ..
        # curcat={$curcat,,}
        curcat=`echo ${curcat} | tr '[:upper:]' '[:lower:]'`
        
        # Truncate the Collection first ..
        # Below not really needed .. :P
        truncate_collection ${curcat} 
        
        # Use httpie to get the top level file of current category
        # DEBUG:
        echo "Downloading http://api.popit.sinarproject.org/en/${curcat}?format=json"
        # http http://api.popit.sinarproject.org/en/${curcat}?format=json -o ${curcat}-sample.json
        # Use jq to figure out the number ofpages to be loadded
        pages=`cat ${curcat}-sample.json | jq '.num_pages'`
        # DEBUG:
        # pages=1
        
        # DEBUG:
        # echo "Number of pages is ${pages}"
        # From page 1 till <page_num>
        for (( i=1; i<=${pages} ; i++ ))
            do
            # Use httpie to download the raw file; saved with <resource-name>-pg-<current_page>.json
            # DEBUG:
            echo "Getting page ${i}  =====>>>>>>>>>"
            # DEBUG:
            echo "Downloading http://api.popit.sinarproject.org/en/${curcat}?format=json&page=${i}"
            http http://api.popit.sinarproject.org/en/${curcat}?format=json -o ${curcat}-page-${i}.json
            
            # Extract out only results; move the key (ID) to be primary
            # Save as for use by arangodbimp next; with the pattern arangodb-<resource-name>-pg-<current_page>.json
            cat ${curcat}-page-${i}.json | jq '.results[] | { _key: .id, data: values } | del(.data.id)' \
                | jq -c '.' >arangodb-${curcat}-page-${i}.json
                        
            # Load using arangoimp (maybe just later in one fell swoop??)
            arangoimp --server.database=sinar --collection=${curcat} --file=arangodb-${curcat}-page-${i}.json
        done
        
        # Finish; use cd - to get back to top level directory
        cd -
        # DEBUG:
        # echo "Got out .. now in `pwd`"
    done 
else
    echo "Going into folder PROCESS/${mycat}"
    # Check first if folder exists??
fi
 
# Source all the dependencies function for global

# Assumption: Sourced source-arangodb first; and in same folder as top level hugo?

# Pre-reqs check; must have POPIT_ARANGODB defined
# otherwise do not continue
# also must see the PROCESS folder

# For each major catregory

    # and continue on the next category .. if not specified 
    # ALL or <specific>: POSTS, ORGANIZATIONS, MEMBERSHIPS, PERSONS
    
    