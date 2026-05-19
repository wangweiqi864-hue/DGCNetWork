
#!/bin/bash

DIR=$(pwd)
#OUTPATH="$DIR/pb_out/"
OUTPATH="$DIR/../../DGCNetWork/Classes/PB/"

rm -rf $OUTPATH

mkdir $OUTPATH

echo "开始执行PB脚本--------"
echo "生成文件pb文件目录=$OUTPATH"

#startCompliePB(){
#
#    if [ ${dir##*.} == "proto" ]; then
#
#        protoc --proto_path=./ --proto_path=../ $dir --objc_out=$outDir
#
##                exit 1
##                    echo "filename: ${dir%.*}"    # Chrome
##                    echo "extension: ${dir##*.}"  # exe
#    fi
#}

#编译PB
compliePB(){
    CURRDIR=$1
#    echo "编译===$CURRDIR"
    # 进入目录 编译
    cd $CURRDIR
#    echo "当前目录---$CURRDIR"
    for dir in $(ls ./)
    do
    #    echo $dir
        if [ -d $dir ]
        then
            echo "目录$dir"
            compliePB $dir
        else
            outDir="$OUTPATH$CURRDIR"
#            echo "outdir ===== $outDir"
            if [ ! -d $outDir ]; then
                mkdir -p $outDir
            fi

#            echo "文件-😁-$dir"

            if [ ${dir##*.} == "proto" ]; then
                
#                protoc --proto_path=./ --proto_path=../ $dir --objc_out=$outDir
                protoc --swift_opt=Visibility=Public --proto_path=./ --proto_path=../ $dir --swift_out=$outDir
                
#                exit 1
#                    echo "filename: ${dir%.*}"    # Chrome
#                    echo "extension: ${dir##*.}"  # exe
            fi
        fi
    done
  
    # 退出当前目录
    cd ..
}

for dir in $(ls ./)
do
#    echo $dir
    if [ -d $dir ]
    then
#        echo "目录$dir"
        compliePB $dir
#    else
#        echo "文件-$dir"
    fi
done




#compliePB
