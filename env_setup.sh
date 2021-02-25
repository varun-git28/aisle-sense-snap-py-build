MAC_ID="$1"
INSTALLDIR="${UTILS_DIR:-./wesense_utilities}"
if [[ ! -d "${INSTALLDIR}" ]]; then
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  BASE_DIR="$( dirname "$SCRIPT_DIR" )"

  INSTALLDIR="${BASE_DIR}"
fi

export UTILS_DIR="$INSTALLDIR"
export _UTILS_DIR_="$UTILS_DIR"

# parse command line options
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -pyver)
    python_version=$2
    echo python_version = "${python_version}"
    shift
    ;;
    *)
    # unknown option
    ;;
esac
shift
done

if [ -e $INSTALLDIR/openvx ]; then
    export LD_LIBRARY_PATH=$INSTALLDIR/openvx/lib:$LD_LIBRARY_PATH
fi

if [ -e $INSTALLDIR/deployment_tools/inference_engine ]; then
    export InferenceEngine_DIR=$UTILS_DIR/deployment_tools/inference_engine/share
    system_type=$(\ls $UTILS_DIR/deployment_tools/inference_engine/lib/)
    IE_PLUGINS_PATH=$UTILS_DIR/deployment_tools/inference_engine/lib/$system_type

    if [[ -e ${IE_PLUGINS_PATH}/arch_descriptions ]]; then
        export ARCH_ROOT_DIR=${IE_PLUGINS_PATH}/arch_descriptions
    fi

    export HDDL_INSTALL_DIR=$INSTALLDIR/deployment_tools/inference_engine/external/hddl
    if [[ "$OSTYPE" == "darwin"* ]]; then
        export DYLD_LIBRARY_PATH=$INSTALLDIR/deployment_tools/inference_engine/external/mkltiny_mac/lib:$INSTALLDIR/deployment_tools/inference_engine/external/tbb/lib:$IE_PLUGINS_PATH:$DYLD_LIBRARY_PATH
        export LD_LIBRARY_PATH=$INSTALLDIR/deployment_tools/inference_engine/external/mkltiny_mac/lib:$INSTALLDIR/deployment_tools/inference_engine/external/tbb/lib:$IE_PLUGINS_PATH:$LD_LIBRARY_PATH
    else
        export LD_LIBRARY_PATH=/opt/intel/opencl:$HDDL_INSTALL_DIR/lib:$INSTALLDIR/deployment_tools/inference_engine/external/gna/lib:$INSTALLDIR/deployment_tools/inference_engine/external/mkltiny_lnx/lib:$INSTALLDIR/deployment_tools/inference_engine/external/tbb/lib:$IE_PLUGINS_PATH:$LD_LIBRARY_PATH
    fi
fi

if [ -e $INSTALLDIR/deployment_tools/ngraph ]; then
    export LD_LIBRARY_PATH=$INSTALLDIR/deployment_tools/ngraph/lib:$LD_LIBRARY_PATH
fi
    
if [ -e "$INSTALLDIR/opencv" ]; then
    if [ -f "$INSTALLDIR/opencv/setupvars.sh" ]; then
        source "$INSTALLDIR/opencv/setupvars.sh"
    else
        export OpenCV_DIR="$INSTALLDIR/opencv/share/OpenCV"
        export LD_LIBRARY_PATH="$INSTALLDIR/opencv/lib:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="$INSTALLDIR/opencv/share/OpenCV/3rdparty/lib:$LD_LIBRARY_PATH"
    fi
fi

export PATH="$UTILS_DIR/deployment_tools/model_optimizer:$PATH"
export PYTHONPATH="$UTILS_DIR/deployment_tools/model_optimizer:$PYTHONPATH"

if [ -e $UTILS_DIR/deployment_tools/open_model_zoo/tools/accuracy_checker ]; then
    export PYTHONPATH="$UTILS_DIR/deployment_tools/open_model_zoo/tools/accuracy_checker:$PYTHONPATH"
fi

if [ -z "$python_version" ]; then
    if command -v python3.7 >/dev/null 2>&1; then
        python_version=3.7
        python_bitness=$(python3.7 -c 'import sys; print(64 if sys.maxsize > 2**32 else 32)')
    elif command -v python3.6 >/dev/null 2>&1; then
        python_version=3.6
        python_bitness=$(python3.6 -c 'import sys; print(64 if sys.maxsize > 2**32 else 32)')
    elif command -v python3.5 >/dev/null 2>&1; then
        python_version=3.5
        python_bitness=$(python3.5 -c 'import sys; print(64 if sys.maxsize > 2**32 else 32)')
    elif command -v python3.4 >/dev/null 2>&1; then
        python_version=3.4
        python_bitness=$(python3.4 -c 'import sys; print(64 if sys.maxsize > 2**32 else 32)')
    elif command -v python2.7 >/dev/null 2>&1; then
        python_version=2.7
    elif command -v python >/dev/null 2>&1; then
        python_version=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    fi
fi

OS_NAME=""
if command -v lsb_release >/dev/null 2>&1; then
    OS_NAME=$(lsb_release -i -s)
fi

if [ ! -z "$python_version" ]; then
    if [ "$python_version" != "2.7" ]; then
        # add path to OpenCV API for Python 3.x
        export PYTHONPATH="$UTILS_DIR/python/python3:$PYTHONPATH"
    fi
    # add path to Inference Engine Python API
    export PYTHONPATH="$UTILS_DIR/python/python$python_version:$PYTHONPATH"
fi

echo "[env_setup.sh] Wesense environment initialized"
./aisle-sense $MAC_ID
