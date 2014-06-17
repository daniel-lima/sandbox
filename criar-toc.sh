#!/bin/bash

if [ -z $1 ]; then
    echo "Utilizacao: $0 dir";
    exit -1;
fi

dir="$1"

if [ ! -d "${dir}" ]; then
    echo "${dir} nao existe";
    exit -1;
fi

arq_result_find=`mktemp /tmp/find.XXXXXXXX`

cd "${dir}"
(find . -name "*" | sort) > ${arq_result_find}

# Salva stdin
exec 5<&0
# Agora, stdin eh arq_result_find
exec < ${arq_result_find}

while read arquivo; do
    arquivo=`echo "${arquivo}" | sed 's/.\///'`;
    
    if [ -f "${arquivo}" ]; then
	md5sum "${arquivo}"
    elif [ -d "${arquivo}" ]; then
	echo "################################ ${arquivo}"
    fi
done

# Restaura stdin
exec 0<&5 5<&-

rm -f ${arq_result_find};

