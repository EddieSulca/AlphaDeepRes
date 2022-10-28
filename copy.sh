clear
file="families.txt"
families_filename="FAMILIES"

[ -d $families_filename ] || mkdir $families_filename

declare -a arr
ind=1
while read -r line; do
    arr+=($line)
    ind=`expr $ind + 1`
done <$file

name_indices=(1 4 5)

base_dir=/Users/fs008/Desktop/EddieSulca/BIOINF
to_dir=/Users/fs008/Desktop/EddieSulca/AlphaDeepRes

for family in "${arr[@]}"
do
    cd $to_dir/$families_filename
    [ -d $family ] || mkdir $family
    cd $family
    [ -d Alpha ] || mkdir Alpha
    [ -d Deep ] || mkdir Deep
    cd $base_dir/R4/$family
    for dir in *; do
        extension="${dir##*.}"
        filename="${dir%.*}"
        if [ $extension = "zip" ] 
        then
            if [ -d $filename ]
            then
                cd $filename
                for dir2 in *; do                 
                    extension2="${dir2##*.}"
                    filename2="${dir2%.*}"   
                    if [ $extension2 = "pdb" ]
                    then
                        IFS='_'
                        read -a arrstr  <<< "$filename2"
                        IFS=' '
                        new_name=${arrstr[0]}
                        for value in "${name_indices[@]}"
                        do
                            new_name+="_"
                            new_name+=${arrstr[$value]}
                        done
                        new_name+=".pdb"
                        origin_dir=$(pwd)/$dir2                
                        final_dir=$to_dir/$families_filename/$family/Alpha/$new_name   
                        if ! [ -f $final_dir ]
                        then                        
                            cp "$origin_dir" "$final_dir"
                            echo "Copied!!!!"
                        fi
                        
                    fi
                done
                cd ..
            else
                echo $dir
                unzip $dir -d $filename
            fi
        fi
    done 

    cd $base_dir/R5/$family
    for dir in *
    do
        extension="${dir##*.}"
        filename="${dir%.*}"
        IFS='_'
        read -a arrstr  <<< "$filename"
        IFS=' '
        if [ ${arrstr[0]} == $family ]
        then
            origin_dir=$(pwd)/$dir                   
            final_dir=$to_dir/$families_filename/$family/Deep/$dir      
            if ! [ -f $final_dir ]
            then                        
                cp "$origin_dir" "$final_dir"
                echo "Copied!!!!"
            else
                echo "Already copied!"
            fi
        fi
    done
    echo 
done
