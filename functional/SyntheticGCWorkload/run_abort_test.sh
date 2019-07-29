#!/bin/bash

LOG_DIR="../log"
CONFIG="$1"
HEAP="$2"
CONFIG_NAME="${CONFIG##*/}"
VM_OPTIONS_BASE="-Xdump:none -Xgcpolicy:gencon -Xnocompactgc -Xgcthreads16 -Xcompressedrefs"

run_test(){
	DATE_TIME=`date "+%Y-%m-%dT_%H-%M-%S"`
	VERBOSE_FILE=$LOG_DIR"/"$CONFIG_NAME"_"$DATE_TIME"_verbose.xml"
	STDOUT_FILE=$LOG_DIR"/"$CONFIG_NAME"_"$DATE_TIME"_stdout.txt"
	CONFIG_COPY=$LOG_DIR"/"$CONFIG_NAME"_"$DATE_TIME".xml"
	cp "$CONFIG" "$CONFIG_COPY" 
	
	( sleep 10; java net.adoptopenjdk.casa.verbose_gc_parser.VerboseGCTailer "$VERBOSE_FILE" ) & 	
	
	java $VM_OPTIONS -Xmx$HEAP -Xms$HEAP -Xverbosegclog:"$VERBOSE_FILE" net.adoptopenjdk.casa.workload_sessions.Main "$CONFIG" --log_file "$STDOUT_FILE"
	
	
	#java $VM_OPTIONS -Xmx$HEAP -Xms$HEAP -verbose:gc -Xtgc:largeAllocationVerbose -Xtrace:iprint=j9mm{alloclarge} net.adoptopenjdk.casa.gc_workload.Main "$CONFIG" --log_file "$STDOUT_FILE" --silent &> stdout_"$DATE_TIME".txt
	
	java net.adoptopenjdk.casa.verbose_gc_parser.VerboseGCParser "$VERBOSE_FILE" -ts	
}

fail(){
	tail "$VERBOSE_FILE"
}

#VM_OPTIONS_BASE=$VM_OPTIONS_BASE" -XXgc:stdSplitFreeListSplitAmount=1"

#VM_OPTIONS_BASE=$VM_OPTIONS_BASE" -Xgc:scvTenureAge=1,scvNoAdaptiveTenure" 

echo $CONFIG
VM_OPTIONS=$VM_OPTIONS_BASE
run_test 

#killall java 2> /dev/null || killall 2> /dev/null 

#VM_OPTIONS=$VM_OPTIONS_BASE" -Xgc:scvTenureAge=1,scvNoAdaptiveTenure"
#run_test 

#VM_OPTIONS=$VM_OPTIONS_BASE" -Xgc:concurrentSlack=auto"
#run_test 

#VM_OPTIONS=$VM_OPTIONS_BASE" -Xgc:concurrentSlack=500000000"
#run_test 
