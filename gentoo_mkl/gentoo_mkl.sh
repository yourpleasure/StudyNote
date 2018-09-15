#!/bin/bash - 
#===============================================================================
#
#          FILE: test.sh
# 
#         USAGE: ./test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 09/13/2018 23:11
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -x
MKL_LIBDIR=/opt/intel/mkl/lib/intel64
MKL_KERN="core"
MKL_DIR=/opt/intel/mkl
MKL_ROOT=/opt/intel
mkl_make_generic_profile() {
	# produce eselect files
	# don't make them in FILESDIR, it changes every major version
	cat  > eselect.blas <<-EOF || echo "error"
		${MKL_LIBDIR}/libmkl_blas95_lp64.a /usr/@LIBDIR@/libblas.a
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/libblas.so
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/libblas.so.0
	EOF
	cat  > eselect.cblas <<-EOF || echo "error"
		${MKL_LIBDIR}/libmkl_lapack95_lp64.a /usr/@LIBDIR@/libcblas.a
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/libcblas.so
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/libcblas.so.0
		${MKL_DIR}/include/mkl_cblas.h /usr/include/cblas.h
	EOF
	cat > eselect.lapack <<-EOF || echo "error"
		${MKL_LIBDIR}/libmkl_lapack95_lp64.a /usr/@LIBDIR@/liblapack.a
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/liblapack.so
		${MKL_LIBDIR}/libmkl_rt.so /usr/@LIBDIR@/liblapack.so.0
	EOF
}

# usage: mkl_add_profile <profile> <interface_lib> <thread_lib> <rtl_lib>
mkl_add_profile() {
	local prof=${1}
    echo $#
    if [ $# -eq 5 ]
    then
        local external1=$4
        local external2=$5
    else
        local external1=""
        local external2=""
    fi
	local x
	for x in blas cblas lapack; do
		cat > ${x}-${prof}.pc <<-EOF
			prefix=${MKL_DIR}
			libdir=${MKL_LIBDIR}
			includedir=${MKL_DIR}/include
			omplibdir=${MKL_ROOT}/lib/intel64
			Name: ${x}
			Description: Intel(R) Math Kernel Library implementation of ${x}
			Version: 2019.0.117
			URL: https://software.intel.com/en-us/mkl
		EOF
	done
	cat >> blas-${prof}.pc <<-EOF || echo "error"
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core ${external1} ${external2} -lpthread -lm -ldl
	EOF
	cat >> cblas-${prof}.pc <<-EOF || echo "error"
		Requires: blas
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core ${external1} ${external2} -lpthread -lm -ldl
		Cflags: -I\${includedir}
	EOF
	cat >> lapack-${prof}.pc <<-EOF || echo "error"
		Requires: blas
		Libs: -Wl,--no-as-needed -L\${libdir} ${2} ${3} -lmkl_core -lmkl_lapack ${external1} ${external2} -lpthread -lm -ldl
	EOF
	echo ${MKL_LIBDIR}
	for x in blas cblas lapack; do
		echo "${x}-${prof}.pc"
		cp eselect.${x} eselect.${x}.${prof}
		echo "/opt/intel/mkl/bin/pkgconfig/${x}-${prof}.pc /usr/@LIBDIR@/pkgconfig/${x}.pc" \
			>> eselect.${x}.${prof} || echo "error"
		eselect ${x} add lib64 eselect.${x}.${prof} ${prof}
	done
}

mkl_make_profiles() {
	local clib="gf"
	local slib="-lmkl_sequential"
	local rlib='-L${omplibdir} -liomp5'
	local pbase="mkl"
	local c
	for c in ${clib}; do
		local ilib="-lmkl_${c}_lp64"
		local tlib="-lmkl_${c/gf/gnu}_thread"
		local comp="${c/gf/gfortran}"
		comp="${comp/intel/ifort}"
		mkl_add_profile ${pbase}-${comp} ${ilib} ${slib}
		mkl_add_profile ${pbase}-${comp}-threads ${ilib} ${tlib} ${rlib}
	done
}
cd /opt/intel/mkl/bin/pkgconfig/
mkl_make_generic_profile
mkl_make_profiles
