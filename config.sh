# Auxiliary script to setup common system configuration for the compilation scripts.
# Should be sourced from the compilation scripts can_*.sh

PYTHON_VERSION=`python3 -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'`
py_cfg_dir=`echo /usr/lib/python${PYTHON_VERSION}/config-${PYTHON_VERSION}-*`
INCLUDE="-I/usr/include/python${PYTHON_VERSION} -I./scans"
PY_LIB="-L${py_cfg_dir} -lpython${PYTHON_VERSION}"
