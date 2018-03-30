#!/bin/bash
 
cd ../src/pages
 
# Add IonicPage import and decorator
for page in **/*.ts; do
	echo "Handle page $page"

    echo "import { IonicPage } from 'ionic-angular';" | cat - $page > temp && mv temp $page
    sed -i '' 's/@Component/@IonicPage()@Component/g' $page
done
 
for d in *; do
	echo "Handle dir $d"

    echo "Create the correct name of the Page"
    parts=$(echo $d | tr "-" "\n")
    finalString=""
    for part in $parts; do
        upperCaseName="$(tr a-z A-Z <<< ${part:0:1})${part:1}"
        finalString=$finalString$upperCaseName
    done
 
	echo "name=$finalString"

    # Remove Page Import from other pages
    cd ..
    pageName=$finalString"Page"
    exclude="pages/$d/$d.ts"
    
    for f in $(find pages -type f -name "*.ts"); do
        if [ $f != $exclude ]
        then
            echo "Replace Page usage with 'Page' for lazy loading"
            sed -i '' 's/'$pageName'/'\'$pageName\''/g' "$f"
            
            echo "Remove all imports of the page"
            sed -i '' '/'$d'/d' $f
        fi
    done
 
    # back to correct folder
    cd pages
    
    echo "Copy the template file into the page folder: $d/$d.module.ts"
	cp ../../upgrade/page-template.ts "$d/$d.module.ts"
 
    echo "Replace the Placeholder inside the page template"
	echo "_PAGENAME_ ==> $finalString"
	echo "_FILENAME_ ==> $d"
	
    sed -i '' 's/_PAGENAME_/'$finalString'/g' "$d/$d.module.ts"
    sed -i '' 's/_FILENAME_/'$d'/g' "$d/$d.module.ts"
 
    # Remove imports, declarations and entryComponents
    echo "Remove imports, declarations and entryComponents"
    sed -i '' '/'$pageName'/d' '../app/app.module.ts'
done
