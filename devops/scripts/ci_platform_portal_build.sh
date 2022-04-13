#! /bin/sh

WORKSPACE=$1
SERVICENAME=$2
BUILD_NUMBER=$3
echo $BUILD_NUMBER
app=vishalhassanandani
version=ci_platform_portal_build; export version;
buildid=ci_platform_portal_build_unix; export buildid;

CURRENT_USER=`whoami`; export CURRENT_USER

if [ ${CURRENT_USER} == "secbuild" ]; then
   root_path_dir=/build2; export root_path_dir
else
   root_path_dir=/build1; export root_path_dir
fi

if [[ ${JOB_NAME} =~ "Prod-HF-CI" ]]; then
   export BUILD_NUMBER=${HOTFIX_TAG_NAME_PREFIX}-${BUILD_NUMBER}
fi

echo "ROOT PATH=$root_path_dir"

jenkins_root=${root_path_dir}/build_dca/rbuild/${app}/${version}/jenkins; export jenkins_root
cfg_root=${root_path_dir}/build_dca/rbuild/${app}; export cfg_root
BUILD_BASE=$cfg_root/$version/$buildid/${app}; export BUILD_BASE
cfg_relroot=${root_path_dir}/build_dca/release/$app/$version; export 
#WAR_DIR=/ux/target/wars; export WAR_DIR
#EB_EXT_DIR=/ux/devops/ebextensions; export EB_EXT_DIR

DEVKITS_DIR=/build/devkits; export DEVKITS_DIR
#export JAVA_HOME=$DEVKITS_DIR/tools/build_software/jdk/openjdk-11/jdk-11
#export _JAVA_OPTIONS="-Xverify:none -Duser.home=${root_path_dir}/build_dca/local_maven_repo/$app/${version} -Xms512m -Xmx1024m"
#export MAVEN3_HOME=$DEVKITS_DIR/tools/build_software/maven/3.6.2
#export MAVEN_OPTS="-Xms1024m -Xmx2048m -XX:MaxMetaspaceSize=2048m -XX:MetaspaceSize=1024m -XX:LoopUnrollLimit=1 -Xss1m"
#export ANT_HOME=$DEVKITS_DIR/tools/build_software/ant/apache-ant-1.8.4
#export NODEJS_PATH=$DEVKITS_DIR/tools/build_software/nodejs/v8.11.2/node-v8.11.2-linux-x64/bin
export BUILD_NUMBER=$BUILD_NUMBER
export CODE_PATH=${WORKSPACE}
#export PATH=$PATH:/devkits/tools/build_software/clm_nodejs/nodejs/bin:/devkits/tools/build_software/clm_jruby/jruby/bin

#RELEASEAREA=$cfg_relroot; export RELEASEAREA
#echo "Release Area = $RELEASEAREA"
#M2_SETTINGS=/data1/tools/m2; export M2_SETTINGS
SERVICE_IMAGE_CONTENT=${SERVICENAME}
##########################################################################
# log command and execute
##########################################################################
logexe()
{
  echo '['`date +%y%m%d-%H%M%S`'][CMD]' "$@"
  "$@"
}

##########################################################################
# log message with the timestamp to stderr
##########################################################################
warn()
{
        echo '['`date +%y%m%d-%H%M%S`'][WARNING]' "$@" >&2
}

#rm -rf /build1/build_dca/local_maven_repo/caas/ci_caas_portal_build/.m2/repository/com/bmc/caas/api-client

echo "
##########################################################################
# Platform Portal Build
##########################################################################
"
cd $CODE_PATH
#$MAVEN3_HOME/bin/mvn clean package -DskipTests -Dcobertura.skip -s $M2_SETTINGS/settings.xml

if [ -d $BUILD_BASE/ux/dist/platform-portal ]; then
   echo "Dir $BUILD_BASE/ux/dist/platform-portal already exist"
  else
    mkdir -p $BUILD_BASE/ux/dist/platform-portal;
  fi

cp Dockerfile $BUILD_BASE/ux/dist/platform-portal
cp -r app $BUILD_BASE/ux/dist/platform-portal
cp -r devops $BUILD_BASE/ux/dist/platform-portal



echo "
###########################################################################
# Copy recommendation_service and devops folder to build archive location &
# 
###########################################################################
"

BUILD_ARCHIVE_DIR=${cfg_relroot}/build.${BUILD_NUMBER}; export BUILD_ARCHIVE_DIR
if [ -d $BUILD_BASE/ux/dist/platform-portal ]; then
   echo $BUILD_ARCHIVE_DIR
   logexe mkdir -p ${BUILD_ARCHIVE_DIR}
   logexe rsync -a $BUILD_BASE/ux/devops ${BUILD_ARCHIVE_DIR}/
   logexe cp -rf $BUILD_BASE/ux/dist/platform-portal ${BUILD_ARCHIVE_DIR}/${SERVICE_IMAGE_CONTENT}
     
  else
   warn "Can not access -> $BUILD_BASE/ux/dist/platform-portal";
fi
