#!/bin/bash
 
cd ../src/pages
 
# Add IonicPage import and decorator
for i in **/*.ts; do
    echo "import { IonicPage } from 'ionic-angular';" | cat - $i > temp && mv temp $i
    sed -i '' 's/@Component/@IonicPage()@Component/g' $i
done
 
for d in *; do
 
    # Create the correct name of the Page
    parts=$(echo $d | tr "-" "\n")
    finalString=""
    for part in $parts; do
        upperCaseName="$(tr a-z A-Z <<< ${part:0:1})${part:1}"
        finalString=$finalString$upperCaseName
    done
 
    # Remove Page Import from other pages
    cd ..
    pageName=$finalString"Page"
    exclude="pages/$d/$d.ts"
    
    for f in $(find pages -type f -name "*.ts"); do
        if [ $f != $exclude ]
        then
            # Replace Page usage with 'Page' for lazy loading
            sed -i '' 's/'$pageName'/'\'$pageName\''/g' "$f"
            
            # Remove all imports of the page
            sed -i '' '/'$d'/d' $f
        fi
    done
 
    # back to correct folder
    cd pages
    
    # Copy the template file into the page folder
    cp ../../upgrade-script/page-template.ts "$d/$d.module.ts"
 
    # Replace the Placeholder inside the page template
    sed -i '' 's/_PAGENAME_/'$finalString'/g' "$d/$d.module.ts"
    sed -i '' 's/_FILENAME_/'$d'/g' "$d/$d.module.ts"
 
    # Remove imports, declarations and entryComponents
    sed -i '' '/'$pageName'/d' '../app/app.module.ts'
done
