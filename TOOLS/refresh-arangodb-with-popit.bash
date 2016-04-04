#!/bin/bash
#

echo "Sinar Project Refesh ArangoDB with PopIt Data!!"

mycat=$1
# DEBUG:
echo "Category is $mycat"

if [ "${mycat}X" == "X" ]
    then
    echo "ERROR"
elif [ "${mycat}X" == "ALLX" ]
    then
    # ALL
    for curcat in `ls PROCESS`
        do
        # DEBUG:
        # echo "Going into folder PROCESS/${curcat}"
        # cd into the correct one inside PROCESS folder
        cd ./PROCESS/${curcat}
        # DEBUG:
        echo "Got in .. now in `pwd`"
        
        # Source all the dependencies function for each type
        # Can use below if Bash 4 and above ..
        # curcat={$curcat,,}
        curcat=`echo ${curcat} | tr '[:upper:]' '[:lower:]'`
        
        # Use httpie to get the top level file of current category
        # DEBUG:
        echo "Downloading http://api.popit.sinarproject.org/en/${curcat}?format=json"
        # http http://api.popit.sinarproject.org/en/${curcat}?format=json -o ${curcat}-sample.json
        # Use jq to figure out the number ofpages to be loadded
        pages=`cat ${curcat}-sample.json | jq '.num_pages'`
        
        # DEBUG:
        echo "Number of pages is ${pages}"
        # From page 1 till <page_num>
        for (( i=2; i<=${pages} ; i++ ))
            do
            # Use httpie to download the raw file; saved with <resource-name>-pg-<current_page>.json
            # DEBUG:
            echo "Getting page ${i}"
            # DEBUG:
            echo "Downloading http://api.popit.sinarproject.org/en/${curcat}?format=json&page=${i}"
            # Extract out only results; move the key (ID) to be primary
        
            # Save as for use by arangodbimp next; with the pattern arangodb-<resource-name>-pg-<current_page>.json
        
            # Load using arangoimp (maybe just later in one fell swoop??)
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
    
    