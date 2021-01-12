#!/bin/bash
# mlucas_entrypoint ver 0.1 - 12 Jan 2021 pvn <pvn@novarese.net>
#
# Copyright (C) 2021 Paul Novarese pvn@novarese.net
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# for x86_64 container images, there should be multiple mlucas binaries
# in /usr/local/bin, all built for different instruction sets
# (sse, avx, avx2, etc)
MLUCAS_EXE_BASE=/usr/local/bin/mlucas

# determine arch
ARCH=$(uname -m)

# determine which instructions are available
# first thing, let's make sure cpuinfo even exists
CPUINFO="/proc/cpuinfo"

if [[ -f ${CPUINFO} ]];then
    echo "${CPUINFO} exists"
else
    echo "FATAL: ${CPUINFO} doesn't exist"
    exit 1
    #not sure if this is actually fatal, maybe just run the
    #least-capable version and hope it works?
fi

if [ ${ARCH} == 'x86_64' ]; then

    echo "intel x86_64 detected"
    if grep -q avx512 ${CPUINFO}; then
        echo "avx512 found"
        MLUCAS_EXE=${MLUCAS_EXE_BASE}-avx512
    else
        if grep -q avx2 ${CPUINFO}; then
            echo "avx2 found"
            MLUCAS_EXE=${MLUCAS_EXE_BASE}-avx2
        else
            if grep -q avx ${CPUINFO}; then
                echo "avx found"
                MLUCAS_EXE=${MLUCAS_EXE_BASE}-avx
            else
                if grep -q sse2 ${CPUINFO}; then
                    echo "sse2 found"
                    MLUCAS_EXE=${MLUCAS_EXE_BASE}-sse2
                else
                    echo "FATAL: no extensions found"
                    exit 1
                fi
            fi
        fi
    fi
else
    if [ ${ARCH} == 'aarch64' ]; then
        echo "aarch64 detected"
        if grep -q asimd ${CPUINFO}; then
            echo "asimd found"
            MLUCAS_EXE=${MLUCAS_EXE_BASE}-c2simd
        else
            echo "no asimd found"
            MLUCAS_EXE=${MLUCAS_EXE_BASE}-nosimd
        fi
    else
        echo "FATAL: only x86_64 and aarch64 are supported"
        exit 1
    fi
fi


# how to differentiate between skylake and phi/knights landing???



# execute appropriate mlucas with arguments
echo "mlucas exe should be: " ${MLUCAS_EXE}
${MLUCAS_EXE} $@
