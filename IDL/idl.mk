# This file is a part of the NCS project. (c) 1999-2002 All rights reserved.
# $Id: idl.mk,v 1.2 2006/10/14 16:53:22 vpashka Exp $

# Общий файл для IDL
# Нужно иметь в виду, что когда порождаемые omniidl файлы
# будут кем-либо изменены, они перегенерируются только
# при изменении исходного IDL

IDLFLAGS = -I$(top_builddir)/IDL

# Получения списков генерируемых файлов
HHTARG=$(patsubst %.idl, ${HHDIR}/%.hh, ${IDLFILES})
CCTARG=$(patsubst %.idl, ${CCDIR}/%SK.cc, ${IDLFILES})

########################################################################

all: ${HHTARG} ${CCTARG}
	

dynamic: all
	

${HHTARG} ${CCTARG}: ${IDLFILES}
	for i in $^; do ${IDL} -v -bcxx ${IDLFLAGS} $$i; done
	mv --target-directory=${HHDIR} *.hh
	mv --target-directory=${CCDIR} *.cc

.PHONY: clean depend
clean:
	${RM} ${HHTARG} ${CCTARG}

depend:
	

install:
	
