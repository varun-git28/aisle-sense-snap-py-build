echo "Initializing automation aisle-sense py build"
AISLE_SENSE_REPO="aislesense"
AISLE_SENSE_BUILD_REPO="aisle-sense"
BUILD_BRANCH="send_emp"
DIR=$PWD"/"$AISLE_SENSE_REPO
echo $DIR

#************** Checking aisle-sense dir exist, if not cloning the aisle-sense Repository **************#
if [ -d "$DIR" ]; then rm -Rf $DIR; rm -Rf $AISLE_SENSE_BUILD_REPO; fi

if [ -d "$DIR" ]; then
    cd $AISLE_SENSE_REPO
    echo "${PWD} Exists..."
else
    # Take action if $DIR NOT exists. #
    echo "${DIR} Directory not exists..."
    echo "CLONING AISLE_SENSE REPO"
    git init
    git config user.email "vaarunkumar13@gmail.com"
    git config user.name "varunkumar_123"
    git clone https://varun-git28:varunkumar_123@github.com/aryabhatta-robotics/aislesense.git
    echo "AISLE_SENSE REPO PULLED SUCCESSFULLY"
    #cd aislesense
    chmod -R 777 $AISLE_SENSE_REPO
    cd $AISLE_SENSE_REPO
    git checkout .
    git status
    git checkout $BUILD_BRANCH
    git status
    echo "GIVEN FOLDER PERMISSION 777"
fi;
git checkout .
git status
#************** Checking aisle-sense dir exist, if not cloning the aisle-sense Repository **************#


# exit

#************** Pyinstaller build command starts here **************#
echo "Creating aisle-sense PyInstaller build in path $PWD"
BUILD_CMD="sudo python3.5 -m PyInstaller --add-data ${dqt}${PWD}/wesense_utilities/deployment_tools/inference_engine/lib/intel64/plugins.xml:.${dqt} aisle-sense.py --hidden-import=${dqt}${PWD}/wesense_utilities/python/python3.5/openvino${dqt} --additional-hooks-dir=${PWD}"
echo $BUILD_CMD
$BUILD_CMD
#************** Pyinstaller build command ends here **************#


#************** Copying build common models and openvino files starts here **************#
sudo chmod -R 777 dist/
cp -a wesense_utilities/ dist/aisle-sense/
cp -a models/ dist/aisle-sense/
cp env_setup.sh dist/aisle-sense/env_setup.sh
cp wesense-ai-cloud.json dist/aisle-sense/wesense-ai-cloud.json
sudo cp -a wesense_utilities/python/python3.5/openvino/ dist/aisle-sense/
#************** Copying build common models and openvino files ends here **************#


#************** After PyInstaller build success push the changes to aisle-py-build repository code starts here **************#
cp -a -R dist/aisle-sense/ ../
cd ..
cd aisle-sense/
sudo chmod -R 777 aisle-sense
echo "####################################   PWD   #######################################";
echo $PWD
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
build_branch="build_automation_"$timestamp
git init
git config user.email "vaarunkumar13@gmail.com"
git config user.name "varunkumar_123"
git remote add origin https://github.com/varun-git28/aisle-sense-snap-py-build.git
git branch
git status
git checkout -b "${build_branch}"
git add .
git commit -m "build automation test branch changes ${timestamp}"
git branch
git push https://varun-git28:varunkumar_123@github.com/varun-git28/aisle-sense-snap-py-build.git ${build_branch}

#************** After PyInstaller build success push the changes to aisle-py-build repository code ends here **************#

